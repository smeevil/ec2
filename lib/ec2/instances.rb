module Instances
  def self.included(klass)
  end

  def instances(ec2=self,options={})
    @instances||=Instances.new(ec2,options)
  end

  class Instances
    def initialize(ec2,options={})
      @ec2=ec2
    end

    def method_missing(*args)
      @ec2.send(*args)
    end

    def help
      puts "Available commands for Instances :"
      puts
      puts "- list"
      puts "- create"
      puts "  Required : "
      puts "    --description='temp server'"
      puts "  Optionals : "
      puts "    --type='c1.medium' *defaults to m1.small"
      puts "    --ami='ami-0810387c' *defaults to 'ami-0810387c' (debian lenny net install)"
      puts "    --group=my_sec_group *defaults to 'default'"
      puts "    --zone=eu-west-1b *defaults to '#{self.region}#{self.zone}'"
      puts "    --keypair=somekey.pem *defaults to '#{self.key_pair}'"
      puts "- terminate / reboot / log / console"
      puts "  Required : "
      puts "    --instance='i-f222222d'"
    end

    def list
      instances=self.connection.describe_instances
      instances.reject!{|i|i[:aws_state] == "terminated"}
      if instances.any?
        instances.each do |instance|
          next if instance[:aws_state] == "terminated"
          puts "instance : #{instance[:aws_instance_id]} in #{instance[:aws_availability_zone]}"
          puts "status \t : #{instance[:aws_state]} (image : #{instance[:aws_image_id]} #{instance[:aws_instance_type]}), started at #{instance[:aws_launch_time]}"
          puts "firewall : #{instance[:aws_groups]}"
          puts "dns \t : #{instance[:dns_name]}"
          puts      
      #    {:private_dns_name=>"ip-10-226-135-150.eu-west-1.compute.internal", :aws_instance_type=>"m1.small", :ami_launch_index=>"0", :aws_reason=>"", :aws_launch_time=>"2010-03-17T07:26:10.000Z", :aws_owner=>"186237999711", :aws_kernel_id=>"aki-7e0d250a", :ssh_key_name=>"default", :aws_state=>"running", :aws_reservation_id=>"r-54528f23", :aws_ramdisk_id=>"ari-7d0d2509", :aws_instance_id=>"i-8e2183f9", :aws_availability_zone=>"eu-west-1b", :aws_groups=>["Rails"], :aws_image_id=>"ami-0810387c", :aws_product_codes=>[], :dns_name=>"ec2-79-125-87-5.eu-west-1.compute.amazonaws.com", :aws_state_code=>"16"}
        end
      else
        puts "Currently you have no instances running :D"
      end
    end
    
    def create
      return puts("please give a description for this instance like : --description='temp server'") unless options[:description] && options[:description].present?
      ami=options[:ami]||="ami-0810387c"
      group=options[:group]||="default"
      zone=options[:zone]||="#{self.region}#{self.zone}"
      key_pair=options[:keypair]||=self.key_pair
      description=options[:description]
      type=options[:type]||="m1.small"
      
      puts "launching instance of ami #{ami}..."
      self.connection.launch_instances(ami, :group_ids=>group, :availability_zone=>zone, :key_name=>key_pair.gsub(".pem",""), :instance_type=>type, :user_data=>description)
      puts "Instance is booting !"
      list
    end
    
    def terminate
      return puts("please give an instance identifier like : --instance='i-f222222d'") unless options[:instance] && options[:instance].present?
      puts "terminating #{options[:instance]} ..."
      self.connection.terminate_instances([options[:instance]])
      list
    end
    
    def reboot
      return puts("please give an instance identifier like : --instance='i-f222222d'") unless options[:instance] && options[:instance].present?
      puts "rebooting #{options[:instance]} ..."
      self.connection.reboot_instances([options[:instance]])
      list
    end
    
    def log
      return puts("please give an instance identifier like : --instance='i-f222222d'") unless options[:instance] && options[:instance].present?
      puts "Fetching log for #{options[:instance]} ..."
      puts self.connection.get_console_output([options[:instance]])
      
    end
    
    def console
      return puts("please give an instance identifier like : --instance='i-f222222d'") unless options[:instance] && options[:instance].present?
      instances=self.connection.describe_instances
      dns=nil
      instances.each do |instance|
        puts "checking #{instance[:aws_instance_id]}"
        if instance[:aws_instance_id]==options[:instance]
          dns=instance[:dns_name]
          break 
        end
      end
      return "No dns found for instance #{options[:instance]}" if dns.nil?
      exec("ssh -i ~/.ec2/#{self.key_pair} root@#{dns}")
    end
    
    
  end

end







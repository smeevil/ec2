module Firewall
  def self.included(klass)
  end

  def firewall(ec2=self,options={})
    @firewall||=Firewall.new(ec2,options)
  end

  class Firewall
    def initialize(ec2,options={})
      @ec2=ec2
    end

    def method_missing(*args)
      @ec2.send(*args)
    end

    def help
      puts "Available commands for Firewall :"
      puts
      puts "- list"
      puts "- open or close"
      puts "  Required : "
      puts "    --port=80"
      puts
      puts "  Optionals : "
      puts "    --group='my group' *defaults to 'default'"
      puts "    --till-port=85 *defaults to --port"
      puts "    --protocol=udp *defaults to TCP"
      puts "    --address='192.168.1.0/32' *defaults to '0.0.0.0/0'"
      puts
      puts "- newgroup / deletegroup"
      puts "  Required : "
      puts "    --name='awesome group"
      puts
      puts "  Optionals : "
      puts "    --description='awesome group of mine"
      
    end

    def list
      self.connection.describe_security_groups.each do |sec|
        puts "Group : '#{sec[:aws_group_name]}' Owner : '#{sec[:aws_owner]}'"
        puts "Description : #{sec[:aws_description]}"
        sec[:aws_perms].each do |permission|
          next unless permission.has_key?(:cidr_ips)
          puts "IP : #{permission[:cidr_ips]} port: #{permission[:from_port]} #{"- #{permission[:to_port]}" unless permission[:to_port]==permission[:from_port]} protocol : #{permission[:protocol]}"
        end
        puts
        puts
      end
    end

    def open
      return puts("Please specify a (numeric) port like : --port=80") unless options[:port] && options[:port]=~/^\d+$/
      port      = options[:port]
      till_port = options[:"till-port"] || options[:port]
      group     = options[:group]       || "default"
      protocol  = options[:protocol]    || "tcp"
      address   = options[:address]     || "0.0.0.0/0"

      if self.connection.authorize_security_group_IP_ingress(group, port, till_port, protocol, address)
        puts "Added !"
        list
      end
    end

    def close
      return puts("Please specify a (numeric) port like : --port=80") unless options[:port] && options[:port]=~/^\d+$/
      port      = options[:port]
      till_port = options[:"till-port"] || options[:port]
      group     = options[:group]       || "default"
      protocol  = options[:protocol]    || "tcp"
      address   = options[:address]     || "0.0.0.0/0"

      if self.connection.revoke_security_group_IP_ingress(group, port, till_port, protocol, address)
        puts "Removed !"
        list
      end
    end

    def newgroup
      return puts("Please specify a name for the group and a description like : --name='new group' --description='my awesome new security group'") unless options[:name] && options[:description] && options[:name].present? && options[:description].present?
      self.connection.create_security_group(options[:name],options[:description])
      puts "Security Group #{options[:name]} has been created !"
    end

    def deletegroup
      return puts("Please specify a name of the group like : --name='old group'") unless options[:name] && options[:name].present?
      self.connection.delete_security_group(options[:name])
      puts "Security Group #{options[:name]} has been removed !"
    end
  end

end


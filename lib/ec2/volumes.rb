module Volumes
  def self.included(klass)
  end

  def volumes(ec2=self,options={})
    @volumes||=Volumes.new(ec2,options)
  end

  class Volumes
    def initialize(ec2,options={})
      @ec2=ec2
    end

    def method_missing(*args)
      @ec2.send(*args)
    end

    def help
      puts "Available commands for Volumes :"
      puts
      puts "- list"
      puts "- create"
      puts "  Optionals : "
      puts "    --size=2 *defaults to 10 (GB)"
      puts
      puts "- snapshot / detach / destroy"
      puts "  Requires : "
      puts "    --volume='vol-1234'"
      puts
      puts "- attach"
      puts "  Requires : "
      puts "    --volume='vol-1234'"
      puts "    --instance='i-1asd234'"
      puts "  Optionals : "
      puts "    --mountpoint='/dev/sdf' *defaults to /dev/sdh"
      
    end

    def list
      volumes=self.connection.describe_volumes
      volumes.reject!{|v|v[:aws_status] == "deleting"}
      if volumes.any?
        volumes.each do |vol|
          puts "#{vol[:aws_id]} (#{vol[:aws_size]} GB) in zone #{vol[:zone]}"
          puts "snapshot id : #{vol[:snapshot_id]}"
          puts "created at : #{vol[:aws_created_at]}"
          print "status : #{vol[:aws_status]}"
          print " by #{vol[:aws_instance_id]} mounted on #{vol[:aws_device]}" if vol[:aws_status]=="in-use"
          puts
          puts
        end
      else
        puts "No Volumes found..."
      end
    end
    
    def create
      size=options[:size]||="10"
      zone=options[:zone]||="#{self.region}#{self.zone}"
      puts "Creating volume of #{size} GB..."      
      self.connection.create_volume('', size, zone)
      list
    end
    
    def destroy
      return puts("Please specify the volume id") unless options[:volume] && options[:volume].present?
      puts "Destroying volume :#{options[:volume]}"
      self.connection.delete_volume(options[:volume])
      list
    end
    
    def snapshot
      return puts("Please specify the volume id") unless options[:volume] && options[:volume].present?
      puts "Snapshotting #{options[:volume]} ..."
      self.connection.create_snapshot(options[:volume])
    end
    
    def attach
      return puts("Please specify the volume id and instance id ") unless options[:volume] && options[:volume].present? && options[:instance] && options[:instance].present?
      mount_point=options[:mountpoint]||='/dev/sdh'
      puts "Attaching volume : #{options[:volume]} to instacne #{options[:instacne]} on mount point : #{mount_point}"
      self.connection.attach_volume(options[:volume], options[:instance], mount_point)
      list
    end

    def detach
      return puts("Please specify the volume id") unless options[:volume] && options[:volume].present?
      puts "Detaching volume : #{options[:volume]}"
      self.connection.detach_volume(options[:volume])
      list
    end
  end
end







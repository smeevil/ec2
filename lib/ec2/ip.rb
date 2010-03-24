module Ip
  def self.included(klass)
  end

  def ip(ec2=self,options={})
    @ip||=Ip.new(ec2,options)
  end

  class Ip
    def initialize(ec2,options={})
      @ec2=ec2
    end

    def method_missing(*args)
      @ec2.send(*args)
    end

    def help
      puts "Available commands for Ip :"
      puts
      puts "- list"
      puts "- get"
      puts
      puts "- release / unassign"
      puts "  Requires : "
      puts "    --ip=87.233.10.2"
      puts
      puts "- assign"
      puts "  Requires : "
      puts "    --ip=87.233.10.2"
      puts "    --instance=i-fffffff"
    end

    def list
      ips=self.connection.describe_addresses
      # volumes.reject!{|v|v[:aws_status] == "deleting"}
      if ips.any?
        ips.each do |ip|
          puts "#{ip[:public_ip]} => #{ip[:instance_id] || "Available"}"
        end
      else
        puts "No Ips found..."
      end
    end
    
    def get
      puts "Requesting a new ip address..."
      self.connection.allocate_address
      list
    end
    
    def release
      return puts("please give an ip address : --ip='87.233.10.2'") unless options[:ip] && options[:ip].present?
      puts "Releasing ip address ..."
      self.connection.release_address(options[:ip])
      list
    end
    
    def assign
      return puts("please give an ip address : --ip='87.233.10.2' and an instance like --instance=i-fffffff") unless options[:ip] && options[:ip].present? && options[:instance] && options[:instance].present?
      puts "Assigning #{options[:ip]} to #{options[:instance]}"
      self.connection.associate_address(options[:instance], options[:ip])
      list
    end
    
    def unassign
      return puts("please give an ip address : --ip='87.233.10.2'") unless options[:ip] && options[:ip].present?
      puts "unassigning #{options[:ip]}"
      self.connection.disassociate_address(options[:ip])
      list
    end
  end
end

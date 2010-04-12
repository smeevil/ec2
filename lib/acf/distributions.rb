module Distributions
  def self.included(klass)
  end

  def distributions(acf=self,options={})
    @distributions||=Distributions.new(acf,options)
  end

  class Distributions
    def initialize(acf,options={})
      @acf=acf
    end

    def method_missing(*args)
      @acf.send(*args)
    end

    def help
      puts "Available commands for Distributions :"
      puts
      puts "- list"      
    end

    def list
      self.connection.list_distributions.each do |dist|
        details=self.connection.get_distribution(dist[:aws_id])
        puts "Domain name : #{details[:domain_name]} => Enabled : #{details[:enabled]}"
        puts "Comment : #{details[:comment]}"
        puts "Aws_id : #{dist[:aws_id]}"
        puts "Etag : #{details[:e_tag]}"
        puts "Origin : #{details[:origin]} (#{details[:status]} #{details[:last_modified_time]})"
        details[:cnames].each do |cname|
          puts "- #{cname}"
        end
        puts
      end
    end
    
    def delete
      return puts("Please specify a aws_id and e_tag like : --aws-id=E2REJM3VUN5RSI --etag=E39OHHU1ON65SI") unless options[:"aws-id"] && options[:"aws-id"].present? && options[:etag] && options[:etag].present?
      puts "Deleting distribution #{options[:"aws-id"]} - #{options[:etag]}..."
      self.connection.delete_distribution(options[:"aws-id"], options[:etag])
      list
    end
    
    def disable
      return puts("Please specify a aws_id : --aws-id=E2REJM3VUN5RSI") unless options[:"aws-id"] && options[:"aws-id"].present?
      puts "Disabling distribution #{options[:"aws-id"]}"
      config=self.connection.get_distribution_config(options[:"aws-id"])
      config[:enabled]=false
      self.connection.set_distribution_config(options[:"aws-id"], config)
      list
    end
    
    def enable
      return puts("Please specify a aws_id : --aws-id=E2REJM3VUN5RSI") unless options[:"aws-id"] && options[:"aws-id"].present?
      puts "Enabling distribution #{options[:"aws-id"]}"
      config=self.connection.get_distribution_config(options[:"aws-id"])
      config[:enabled]=true
      self.connection.set_distribution_config(options[:"aws-id"], config)
      list
    end
    
  end
end


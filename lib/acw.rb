require "#{LIB_PATH}/acw/metrics"

class Acw
  include Metrics

  attr_accessor :options
  attr_accessor :access_key
  attr_accessor :secret_key
  attr_accessor :connection
  attr_accessor :zone
  attr_accessor :region

  def initialize(options)
    config=YAML.load(File.read("#{ENV['HOME']}/.ec2/aws.yml"))
    raise "#{options[:config]} not defined" unless config.has_key?(options[:config])

    self.options=options
    self.access_key=config[options[:config]]["access_key"]
    self.secret_key=config[options[:config]]["secret_key"]
    self.region=config[options[:config]]["region_info"]["region"]
    self.zone=config[options[:config]]["region_info"]["zone"]
    
    
    self.connect
  end

  def connect
    self.connection=RightAws::AcwInterface.new(self.access_key, self.secret_key, {:logger=>Log})
  end

end


class Log
  def self.info(*args)
    puts "INFO : #{args.inspect}"
  end

  def self.error(*args)
    puts "Error : #{args.inspect}"
  end

  def self.warn(*args)
    puts "Warning : #{args.inspect}"
  end
end

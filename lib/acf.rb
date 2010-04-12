require "#{LIB_PATH}/acf/distributions"

class Acf
  include Distributions

  attr_accessor :options
  attr_accessor :access_key
  attr_accessor :secret_key
  attr_accessor :connection

  def initialize(options)
    config=YAML.load(File.read("#{ENV['HOME']}/.ec2/aws.yml"))
    raise "#{options[:config]} not defined" unless config.has_key?(options[:config])

    self.options=options
    self.access_key=config[options[:config]]["access_key"]
    self.secret_key=config[options[:config]]["secret_key"]
    
    self.connect
  end

  def connect
    self.connection=RightAws::AcfInterface.new(self.access_key, self.secret_key, :logger=>Log)
  end

end


class Log
  def self.info(*args)
    # puts "INFO : #{args.inspect}"
  end

  def self.error(*args)
    puts "Error : #{args.inspect}"
  end

  def self.warn(*args)
    puts "Warning : #{args.inspect}"
  end
end

%w(active_support).each { |l| require l rescue nil }

require 'ec2/firewall'

# Git rid of ssl verification warning
class Net::HTTP
  alias_method :old_initialize, :initialize
  def initialize(*args)
    old_initialize(*args)
    @ssl_context = OpenSSL::SSL::SSLContext.new
    @ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end
end


class Ec2
  include Firewall
  
  attr_accessor :access_key
  attr_accessor :secret_key
  attr_accessor :key_pair
  attr_accessor :region
  attr_accessor :connection
  attr_accessor :options
  
  def initialize(options)
    config=YAML.load(File.read("#{ENV['HOME']}/.ec2/aws.yml"))
    raise "#{options[:config]} not defined" unless config.has_key?(options[:config])    
    
    self.options=options
    self.access_key=config[options[:config]]["access_key"]
    self.secret_key=config[options[:config]]["secret_key"]
    self.key_pair=config[options[:config]]["key_pair"]
    self.region=config[options[:config]]["region_info"]["region"]
    
    self.connect
  end
  
  def connect
    self.connection=RightAws::Ec2.new(self.access_key, self.secret_key, :region=>self.region, :logger=>Log)
  end
  
end


class Log
  def self.info(*args)
    # puts "INFO : #{args.inspect}"
  end
end


%w(activesupport active_support).each { |l| require l rescue nil }

class Ec2
  def initialize(options=Hash.new)
  end
end
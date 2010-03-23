Gem::Specification.new do |s|
  # Project
  s.name         = 'ec2'
  s.summary      = "ec2 tools"
  s.description  = s.summary
  s.version      = '0.1'
  s.date         = '2010-03-23'
  s.platform     = Gem::Platform::RUBY
  s.authors      = ["Gerard de Brieder", "Wes Oldenbeuving"]
  s.email        = "smeevil@me.com"
  s.homepage     = "http://www.github.com/smeevil/ec2"

  # Files
  root_files     = %w[README.markdown Rakefile fresnel.gemspec]
  bin_files      = %w[ec2]
  fresnel_files  = %w[cache cli date_parser frame lighthouse setup_wizard string input_detector]
  lib_files      = %w[ec2] + fresnel_files.map {|f| "ec2/#{f}"}
  s.bindir       = "bin"
  s.require_path = "lib"
  s.executables  = bin_files
  s.test_files   = []
  s.files        = root_files + s.test_files + bin_files.map {|f| 'bin/%s' % f} + lib_files.map {|f| 'lib/%s.rb' % f}

  # rdoc
  s.has_rdoc         = true
  s.extra_rdoc_files = %w[ README.markdown]
  s.rdoc_options << '--inline-source' << '--line-numbers' << '--main' << 'README.rdoc'

  # Dependencies

  # Requirements
  s.required_ruby_version = ">= 1.8.0"
end

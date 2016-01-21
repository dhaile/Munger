Gem::Specification.new do |s|
  s.name = "Data Checker"
  s.summary = "Check for mismatch"
  s.description = File.read(File.join(File.dirname(__FILE__), 'README'))
  s.requirements = ['csv']
  s.version = "0.0.1"
  s.author = "Dawit Haile"
  s.email = "dawityhaile@gmail.com"
  s.homepage = "http://www.dawithaile.com"
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>=1.9'
  s.files = Dir['**/**']
  s.executables = ['yt_data_checker_beta']
  s.test_files = Dir["test/test*.rb"]
  s.has_rdoc = true
end
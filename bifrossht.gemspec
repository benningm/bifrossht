require File.join([File.dirname(__FILE__),'lib','bifrossht','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'bifrossht'
  s.version = Bifrossht::VERSION
  s.license = 'GPL-3.0+'
  s.author = 'Markus Benning'
  s.email = 'ich@markusbenning.de'
  s.homepage = 'https://markusbenning.de'
  s.platform = Gem::Platform::RUBY
  s.summary = 'SSH auto-routing proxy command'
  s.files = Dir.glob('lib/**/*.rb') + Dir.glob('bin/*') + Dir.glob('[A-Z]*') + Dir.glob('test/**/*')
  s.require_paths << 'lib'
  s.rdoc_options << '--title' << 'bifrossht' << '--main' << 'README.md' << '-ri'
  s.bindir = 'bin'
  s.executables << 'bifrossht'
  s.add_development_dependency('rake', '~> 12')
  s.add_development_dependency('rdoc', '~> 6')
  s.add_runtime_dependency('gli', '~> 2')
end

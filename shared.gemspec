## shared.gemspec
#

Gem::Specification::new do |spec|
  spec.name = "shared"
  spec.version = "1.1.1"
  spec.platform = Gem::Platform::RUBY
  spec.summary = "shared"
  spec.description = "a clean way to factor class/instance mixins in ruby"
  spec.license = "same as ruby's"

  spec.files =
["README", "Rakefile", "lib", "lib/shared.rb", "readme.erb", "shared.gemspec"]

  spec.executables = []
  
  spec.require_path = "lib"

  spec.test_files = nil

### spec.add_dependency 'lib', '>= version'
#### spec.add_dependency 'map'

  spec.extensions.push(*[])

  spec.rubyforge_project = "codeforpeople"
  spec.author = "Ara T. Howard"
  spec.email = "ara.t.howard@gmail.com"
  spec.homepage = "https://github.com/ahoward/shared"
end

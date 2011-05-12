# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{expirable_locking}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Eric Chapweske"]
  s.date = %q{2011-03-21}
  s.description = %q{A tiny ActiveRecord extension for expirable locking.}
  s.email = %q{eac@zendesk.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "expirable_locking.gemspec",
     "lib/expirable_locking.rb",
     "test/expirable_locking_test.rb",
     "test/helper.rb"
  ]
  s.homepage = %q{http://github.com/eac/expirable_locking}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{A tiny ActiveRecord extension for expirable locking.}
  s.test_files = [
    "test/expirable_locking_test.rb",
     "test/helper.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end


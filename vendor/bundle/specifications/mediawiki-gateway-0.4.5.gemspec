# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "mediawiki-gateway"
  s.version = "0.4.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jani Patokallio"]
  s.date = "2012-04-19"
  s.description = ""
  s.email = "jpatokal@iki.fi"
  s.extra_rdoc_files = ["README"]
  s.files = ["README"]
  s.homepage = "http://github.com/jpatokal/mediawiki-gateway"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.25"
  s.summary = "Connect to the mediawiki API"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rest-client>, [">= 1.3.0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<sham_rack>, [">= 0"])
      s.add_development_dependency(%q<rr>, [">= 0"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 1.3"])
      s.add_development_dependency(%q<ruby-debug>, [">= 0"])
      s.add_development_dependency(%q<sinatra>, [">= 0"])
      s.add_development_dependency(%q<activemodel>, [">= 0"])
    else
      s.add_dependency(%q<rest-client>, [">= 1.3.0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<sham_rack>, [">= 0"])
      s.add_dependency(%q<rr>, [">= 0"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 1.3"])
      s.add_dependency(%q<ruby-debug>, [">= 0"])
      s.add_dependency(%q<sinatra>, [">= 0"])
      s.add_dependency(%q<activemodel>, [">= 0"])
    end
  else
    s.add_dependency(%q<rest-client>, [">= 1.3.0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<sham_rack>, [">= 0"])
    s.add_dependency(%q<rr>, [">= 0"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 1.3"])
    s.add_dependency(%q<ruby-debug>, [">= 0"])
    s.add_dependency(%q<sinatra>, [">= 0"])
    s.add_dependency(%q<activemodel>, [">= 0"])
  end
end

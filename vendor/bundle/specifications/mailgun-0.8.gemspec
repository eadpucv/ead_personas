# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "mailgun"
  s.version = "0.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Akash Manohar J", "Sean Grove"]
  s.date = "2014-04-09"
  s.description = "Mailgun library for Ruby"
  s.email = ["akash@akash.im"]
  s.homepage = "http://github.com/HashNuke/mailgun"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.25"
  s.summary = "Idiomatic library for using the mailgun API from within ruby"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rest-client>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 2"])
      s.add_development_dependency(%q<debugger>, [">= 0"])
      s.add_development_dependency(%q<vcr>, [">= 0"])
    else
      s.add_dependency(%q<rest-client>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 2"])
      s.add_dependency(%q<debugger>, [">= 0"])
      s.add_dependency(%q<vcr>, [">= 0"])
    end
  else
    s.add_dependency(%q<rest-client>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 2"])
    s.add_dependency(%q<debugger>, [">= 0"])
    s.add_dependency(%q<vcr>, [">= 0"])
  end
end

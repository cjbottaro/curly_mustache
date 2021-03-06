# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{curly_mustache}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Christopher J Bottaro"]
  s.date = %q{2010-02-23}
  s.email = %q{cjbottaro@alumni.cs.utexas.edu}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc",
     "TODO"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "TODO",
     "VERSION.yml",
     "curly_mustache.gemspec",
     "lib/curly_mustache.rb",
     "lib/curly_mustache/attributes.rb",
     "lib/curly_mustache/attributes/definition.rb",
     "lib/curly_mustache/attributes/manager.rb",
     "lib/curly_mustache/attributes/types.rb",
     "lib/curly_mustache/base.rb",
     "lib/curly_mustache/connection.rb",
     "lib/curly_mustache/crud.rb",
     "lib/curly_mustache/default_types.rb",
     "lib/curly_mustache/errors.rb",
     "lib/curly_mustache/locking.rb",
     "lib/curly_mustache/serialization.rb",
     "test/abstract_adapter_test.rb",
     "test/adapters.yml",
     "test/attributes_test.rb",
     "test/callbacks_test.rb",
     "test/crud_test.rb",
     "test/locking_test.rb",
     "test/models/account.rb",
     "test/models/feed.rb",
     "test/models/imbecile.rb",
     "test/models/page.rb",
     "test/models/user.rb",
     "test/serialization_test.rb",
     "test/test_helper.rb",
     "test/types_test.rb",
     "test/validations_test.rb"
  ]
  s.homepage = %q{http://github.com/cjbottaro/curly_mustache}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{ActiveModel implemention that provides an ActiveRecord-like interface for various data stores.}
  s.test_files = [
    "test/abstract_adapter_test.rb",
     "test/attributes_test.rb",
     "test/callbacks_test.rb",
     "test/crud_test.rb",
     "test/locking_test.rb",
     "test/models/account.rb",
     "test/models/feed.rb",
     "test/models/imbecile.rb",
     "test/models/page.rb",
     "test/models/user.rb",
     "test/serialization_test.rb",
     "test/test_helper.rb",
     "test/types_test.rb",
     "test/validations_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end


# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{curly_mustache}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Christopher J Bottaro"]
  s.date = %q{2009-06-12}
  s.email = %q{cjbottaro@alumni.cs.utexas.edu}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION.yml",
    "lib/adapters/abstract.rb",
    "lib/adapters/memcache.rb",
    "lib/adapters/redis.rb",
    "lib/adapters/tokyo_tyrant.rb",
    "lib/association_collection.rb",
    "lib/association_manager.rb",
    "lib/associations.rb",
    "lib/attributes/definer.rb",
    "lib/attributes/definitions.rb",
    "lib/attributes/typecaster.rb",
    "lib/attributes/types.rb",
    "lib/base.rb",
    "lib/crud.rb",
    "lib/curly_mustache.rb",
    "lib/errors.rb",
    "lib/helpers.rb",
    "test/associations_test.rb",
    "test/crud_test.rb",
    "test/test_helper.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/cjbottaro/curly_mustache}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{Like ActiveRecord, but uses key-value stores (Tokyo Cabinet, Redis, MemcacheDB, etc) instead of relational databases.}
  s.test_files = [
    "test/associations_test.rb",
    "test/crud_test.rb",
    "test/test_helper.rb"
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

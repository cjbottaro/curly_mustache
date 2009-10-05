require 'rubygems'
require 'test/unit'
require 'mocha'

require 'curly_mustache'

class Test::Unit::TestCase
end

adapter = ENV["ADAPTER"] || :memcache
CurlyMustache::Base.establish_connection(:adapter => adapter)
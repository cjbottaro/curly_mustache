require 'rubygems'
require 'test/unit'
require 'mocha'

$LOAD_PATH.unshift "lib"

require 'curly_mustache'

# This has to go before the model definitions or class_inheritable_accessor won't inherit.
adapter = ENV["ADAPTER"] || :memcache
CurlyMustache::Base.establish_connection(:adapter => adapter)

Dir.glob(File.dirname(__FILE__) + "/models/*").each{ |file_name| require file_name }

class Test::Unit::TestCase
end
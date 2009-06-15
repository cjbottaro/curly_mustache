require 'rubygems'
require 'test/unit'
require 'mocha'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'curly_mustache'

class Test::Unit::TestCase
end

adapter = ENV["ADAPTER"] || :memcache
CurlyMustache::Base.establish_connection(:adapter => adapter)
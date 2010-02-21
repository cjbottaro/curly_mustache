require 'rubygems'
require 'test/unit'
require 'mocha'

$LOAD_PATH.unshift "lib"

require 'curly_mustache'

# This has to go before the model definitions or class_inheritable_accessor won't inherit.
adapter = ENV["ADAPTER"] || ENV["adapter"] || "memcached"
configs = YAML.load(File.open(File.dirname(__FILE__)+"/adapters.yml"){ |f| f.read })
CurlyMustache::Base.establish_connection(configs[adapter].merge(:adapter => adapter))

# This also has to go before the model definitions or class_inheritable_accessor won't inherit.
class CurlyMustache::Base
  if connection.class.name.include?("Cassandra")
    serializer.in do |attributes|
      attributes.inject({}) do |memo, (k, v)|
        memo[k] = String(v)
        memo
      end
    end
  end
end

# Load model definitions.
Dir.glob(File.dirname(__FILE__) + "/models/*").each{ |file_name| require file_name }

class ActiveSupport::TestCase
  
  def disable_tests
    methods.select{ |method| method =~ /^test_/ }.each do |method|
      self.class.send(:define_method, method){ nil }
    end
  end
  
end
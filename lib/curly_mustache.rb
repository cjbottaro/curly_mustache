require 'rubygems'

gem "activemodel", "3.0.0.beta1"

require "active_support"
require "active_support/core_ext"
require "active_model"

require "digest"
require "ostruct"

require "curly_mustache/adapters"
require "curly_mustache/errors"
require "curly_mustache/connection"
require "curly_mustache/attributes"
require "curly_mustache/crud"
require "curly_mustache/base"

# Load all the default adapters
require "curly_mustache/adapters/memcached"
CurlyMustache::Adapters.register(CurlyMustache::Adapters::Memcached)
require "curly_mustache/adapters/cassandra"
CurlyMustache::Adapters.register(CurlyMustache::Adapters::Cassandra)
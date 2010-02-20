require 'rubygems'

gem "activemodel", "3.0.0.beta1"

require "active_support"
require "active_support/core_ext"
require "active_model"

require "digest"
require "ostruct"

require "adapters/abstract"
require "curly_mustache/helpers"
require "curly_mustache/errors"
require "curly_mustache/connection"
require "curly_mustache/attributes"
require "curly_mustache/crud"
require "curly_mustache/serialization"
require "curly_mustache/locking"
require "curly_mustache/base"
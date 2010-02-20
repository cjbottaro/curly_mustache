require "test_helper"

class TypesTest < ActiveSupport::TestCase

  def test_clear
    assert !CurlyMustache::Attributes::Types.definitions.blank?
    CurlyMustache::Attributes::Types.clear
    assert CurlyMustache::Attributes::Types.definitions.blank?
    load File.dirname(__FILE__) + "/../lib/curly_mustache/default_types.rb"
    assert !CurlyMustache::Attributes::Types.definitions.blank?
  end
  
end
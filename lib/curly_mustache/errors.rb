module CurlyMustache
  class NoKeyError < RuntimeError; end
  class AttributeNotDefinedError < RuntimeError; end
  class InvaildAttributeType < ArgumentError; end
  class InvalidAssociation < RuntimeError; end
  class RecordNotFound < RuntimeError; end
  class ValidationError < RuntimeError; end
end
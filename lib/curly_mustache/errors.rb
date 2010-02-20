module CurlyMustache
  class NoKeyError < RuntimeError; end
  class AttributeNotDefinedError < RuntimeError; end
  class IdNotSettableError < RuntimeError; end
  class InvaildAttributeType < ArgumentError; end
  class InvalidAssociation < RuntimeError; end
  class NotImplementedError < RuntimeError
    def initialize
      super("Not implemented!")
    end
  end
  class RecordNotFound < RuntimeError; end
  class ValidationError < RuntimeError; end
end
class Hash
  def to_struct(name = nil)
    name = "Hash" if name.blank?
    struct = Struct.new(name.to_s, *(keys.collect{ |key| key.to_sym }))
    returning(struct.new){ |struct| each{ |k, v| struct.send("#{k}=", v) }}
  end
end

class Object
  def meta_eval(&block)
    (class << self; self; end).instance_eval(&block)
  end
  def full?
    !blank?
  end
end
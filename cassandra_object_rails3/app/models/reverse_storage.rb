module ReverseStorage
  def encode(str)
    str.reverse
  end
  module_function :encode

  def decode(str)
    str.reverse
  end
  module_function :decode
end

class Hash
  def fetch_deep(path)
    new_path_style = path.split('.').clone
    current = self.from_array_to_hash.stringify_keys
    while new_path_style.size > 1 && current do
      v = current[new_path_style.shift]
      current = v
    end
    current ? current[new_path_style.first] : nil
  end
end

class Hash
  def stringify_keys
    new_hash_style = {}
    map do |key, value|
      value = value.stringify_keys if value.is_a?(Hash) || value.is_a?(Array)
      new_hash_style[key.to_s] = value
    end
    new_hash_style
  end
end

class Array
  def stringify_keys
    new_array_style = []
    map do |value|
      value = value.stringify_keys if value.is_a?(Hash) || value.is_a?(Array)
      new_array_style = value
    end
    new_array_style
  end
end

class Hash
  def from_array_to_hash
    current = self
    current.each do |k, _|
      if current[k].is_a?(Array)
        current[k] = current[k].map.with_index { |x, i| [i, x] }.to_h
      elsif current[k].is_a?(Hash)
        current[k].from_array_to_hash
      end
    end
  end
end

class Hash
  def reshape(shape)
    shape.map do |key, value|
      [key, value.is_a?(String) ? self.fetch_deep(value) : self.reshape(value)]
    end.to_h
  end
end

class Array
  def reshape(shape)
    curr = self.map { |i| i.from_array_to_hash }
    curr.map { |i| i.reshape(shape) }
  end
end

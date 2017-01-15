class DataModel
  def initialize(hash = {})
    @attributes = hash
    @data_store
    @id
  end
  class << self
    def attributes(*args)
      @attributes = args.to_a.map { |item| item.to_sym }
    end

    def data_store
    end

    def where
    end
  end

  def save
  end

  def delete
  end
end

class DataStore
  attr_reader :storage

  def initialize
    @storage
  end

  def create
  end

  def find
  end

  def update
  end

  def delete
  end
end

class ArrayStore < DataStore
  attr_reader :id

  def initialize
    @storage = []
    @id = 1
  end

  def create(record)
    @storage[@id] = record
    @id += 1
  end

  def find(request)
    finded = []
    request1 = request.to_a
    new_storage = @storage.map { |item| item.to_a }
    new_storage.each do |item|
      finded.push(item.to_h) if (item & request1) != []
    end
    finded
  end

  def update(id_num, new_record)
    @storage[id_num] = new_record
  end

  def delete(request)
    @storage.delete(request)
  end
end

class HashStore < DataStore
  attr_reader :storage, :id
  def initialize
    @storage = {}
    @id = 1
  end

  def create(record)
    @storage[@id] = record
    @id += 1
  end

  def find(request)
    finded = []
    request1 = request.to_a
    new_storage = @storage.each_value.map { |hash| hash.to_a }
    new_storage.each do |item|
      finded.push(item.to_h) if (item & request1) != []
    end
    finded
  end

  def update(id_num, new_record)
    @storage[id_num] = new_record
  end

  def delete(request)
    @storage.delete_if { |_, value| value == request }
  end
end

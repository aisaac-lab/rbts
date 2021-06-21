class Rbts::Type
  class Atom
    AVAILABLES = [:number, :string, :null]

    def initialize(sym)
      unless Rbts::Type::Atom::AVAILABLES.include?(sym)
        raise 'sym is invalid'
      end

      @sym = sym
    end

    def to_s
      @sym.to_s
    end

    def match?(value)
      case @sym
      when :number
        value.is_a?(Numeric)
      when :string
        value.is_a?(String)
      when :null
        value.nil?
      end
    end
  end

  class Object
    def initialize(hash)
      unless hash.is_a?(Hash)
        raise 'hash is invalid'
      end

      @hash = hash.map { |k, v| [k, Rbts.typenize(v)] }.to_h
    end

    def match?(value)
      return false unless value.is_a?(Hash)
      return false if @hash.keys.sort != value.keys.sort

      @hash.keys.all? { |key|
        @hash.fetch(key).match?(value.fetch(key))
      }
    end

    def to_s
      str = @hash.map { |k, v| "#{k}: #{v.to_s}" }.join(", ")
      "{ #{str} }"
    end
  end

  class List
    def initialize(type)
      @type = type
    end

    def match?(value)
      return false unless value.is_a?(Array)

      value.all? { |v| @type.match?(v) }
    end

    def to_s
      "#{@type}[]"
    end
  end

  def initialize(type)
    @types = [type]
  end

  def to_s
    @types.map(&:to_s).join(' | ')
  end

  def match?(v)
    @types.any? { |t| t.match?(v) }
  end

  def |(type)
    @types << type
    self
  end

  def []
    raise "[] can't call on OR type" if 1 < @types.count
    Rbts::Type::List.new(@types[0])
  end
end
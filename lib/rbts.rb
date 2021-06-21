# frozen_string_literal: true

require_relative "rbts/version"
require_relative "rbts/type"

module Rbts
  class Error < StandardError; end

  def number
    Rbts::Type.new Rbts::Type::Atom.new(__method__)
  end

  def string
    Rbts::Type.new Rbts::Type::Atom.new(__method__)
  end

  def null
    Rbts::Type.new Rbts::Type::Atom.new(__method__)
  end

  def self.typenize(obj)
    case obj
    when Hash
      Rbts::Type::Object.new(obj)
    when Rbts::Type, Rbts::Type::List
      obj
    else
      raise "#{obj.inspect} is invalid"
    end
  end
end

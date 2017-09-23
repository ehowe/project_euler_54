class Card # :nodoc:
  include Comparable

  attr_reader :value, :suit

  def self.order
    %w[2 3 4 5 6 7 8 9 T J Q K A]
  end

  def initialize(pair)
    @value, @suit = pair.scan(/\w/)
  end

  def <=>(other)
    self.class.order.index(value) <=> self.class.order.index(other.value)
  end

  def eql?(other)
    other.value.eql?(value)
  end

  def hash
    @value.hash
  end
end

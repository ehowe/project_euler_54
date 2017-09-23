class Hand # :nodoc:
  include Comparable
  attr_reader :player, :cards

  class << self
    attr_accessor :order
  end

  self.order = %w[
    royal_flush
    straight_flush
    four_of_a_kind
    full_house
    flush
    straight
    three_of_a_kind
    two_pairs pair
    high_card
  ]

  def initialize(player, cards)
    @player = player
    @cards  = cards.map { |c| Card.new(c) }.sort
  end

  def high_card
    cards.last.value
  end

  def pairs
    cards.select { |c| cards.map(&:value).count(c.value) == 2 }
  end

  def three_of_a_kind
    cards.select { |c| cards.map(&:value).count(c.value) == 3 }
  end

  def four_of_a_kind
    cards.select { |c| cards.map(&:value).count(c.value) == 4 }
  end

  def high_card?
    # this is the default method
    # it just needs to return true for comparison later
    true
  end

  def pair?
    find_duplicate_cards.select { |_k, v| v == 2 }.count == 1
  end

  def two_pairs?
    find_duplicate_cards.select { |_k, v| v == 2 }.count == 2
  end

  def three_of_a_kind?
    find_duplicate_cards.select { |_k, v| v == 3 }.any?
  end

  def straight?
    orders = cards.map { |c| Card.order.index(c.value) }
    orders[4] - orders[3] == 1 &&
      orders[3] - orders[2] == 1 &&
      orders[2] - orders[1] == 1 &&
      orders[1] - orders[0] == 1
  end

  def flush?
    suits.uniq.count == 1
  end

  def full_house?
    three_of_a_kind? && pair?
  end

  def four_of_a_kind?
    find_duplicate_cards.select { |_k, v| v == 4 }.any?
  end

  def straight_flush?
    straight? && flush?
  end

  def royal_flush?
    straight_flush? && cards.last.value == 'A'
  end

  def suits
    cards.map(&:suit)
  end

  def highest_win
    self.class.order.detect { |m| send("#{m}?".to_sym) }
  end

  def <=>(other)
    value = -(self.class.order.index(highest_win) <=>
              self.class.order.index(other.highest_win))

    if value.zero? && highest_win == 'high_card'
      value = Card.order.index(high_card) <=> Card.order.index(other.high_card)
    elsif value.zero?
      case highest_win
      when 'pair', 'two_pairs'
        value = pairs.last <=> other.pairs.last
      when 'three_of_a_kind', 'full_house'
        value = three_of_a_kind.last <=> other.three_of_a_kind.last
      when 'straight', 'flush', 'straight_flush', 'royal_flush'
        value = cards.last <=> other.cards.last
      when 'four_of_a_kind'
        value = four_of_a_kind.last <=> other.four_of_a_kind.last
      end
    end

    value
  end

  private

  def find_duplicate_cards
    cards.each_with_object(Hash.new(0)) do |c, total|
      total[c.value] += 1
    end
  end
end

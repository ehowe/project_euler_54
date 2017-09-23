require_relative 'spec_helper'
require_relative 'poker'
require_relative 'player'
require_relative 'hand'
require_relative 'card'

describe 'poker' do
  let(:player1) { Player.new }
  let(:player2) { Player.new }

  it 'has player 1 winning 376 times' do
    Poker.play(player1, player2)
    expect(player1.wins).to eq(376)
    expect(player2.wins).to eq(624)
  end
end

describe 'hands' do
  let(:player)                { Player.new }
  let(:high_card)             { Hand.new(player, %w[2H 3C 4H 5D AS]) }
  let(:pair)                  { Hand.new(player, %w[2H 2C 3H 4D TS]) }
  let(:other_pair)            { Hand.new(player, %w[3H 3C 2D 4D 5D]) }
  let(:two_pairs)             { Hand.new(player, %w[2H 2C 3H 3C 4H]) }
  let(:three_of_a_kind)       { Hand.new(player, %w[2H 2C 2D 3H 4D]) }
  let(:other_three_of_a_kind) { Hand.new(player, %w[3H 3C 3D 4H 5D]) }
  let(:straight)              { Hand.new(player, %w[2H 3C 4D 5H 6D]) }
  let(:other_straight)        { Hand.new(player, %w[3H 4C 5D 6H 7D]) }
  let(:flush)                 { Hand.new(player, %w[2H 4H 6H 8H TH]) }
  let(:full_house)            { Hand.new(player, %w[2H 2C 6D 6H 6D]) }
  let(:four_of_a_kind)        { Hand.new(player, %w[2H 2C 2D 2S 4D]) }
  let(:other_four_of_a_kind)  { Hand.new(player, %w[3H 3C 3D 3S 4D]) }
  let(:straight_flush)        { Hand.new(player, %w[2H 3H 4H 5H 6H]) }
  let(:royal_flush)           { Hand.new(player, %w[TS JS QS KS AS]) }

  it 'uniqs the pair' do
    expect(pair.cards.uniq.count).to eq(4)
  end

  it 'the pair beats the high card' do
    expect(pair.highest_win).to eq('pair')
    expect(high_card.highest_win).to eq('high_card')
    expect(pair).to be > high_card
  end

  it 'the higher pair beats the lower pair' do
    expect(other_pair).to be > pair
  end

  it 'the two pairs beats the pair and the high card' do
    expect(two_pairs.highest_win).to eq('two_pairs')
    expect(two_pairs).to be > pair
    expect(two_pairs).to be > high_card
  end

  it 'the three of a kind beats the two pairs, pair and the high card' do
    expect(three_of_a_kind.highest_win).to eq('three_of_a_kind')
    expect(three_of_a_kind.three_of_a_kind.map(&:value)).to contain_exactly('2', '2', '2')
    expect(three_of_a_kind).to be > two_pairs
    expect(three_of_a_kind).to be > pair
    expect(three_of_a_kind).to be > high_card
  end

  it 'the highest three of a kind hand wins' do
    expect(other_three_of_a_kind).to be > three_of_a_kind
  end

  it 'the straight beats every hand below it' do
    expect(straight.highest_win).to eq('straight')
    expect(straight).to be > three_of_a_kind
    expect(straight).to be > two_pairs
    expect(straight).to be > pair
    expect(straight).to be > high_card
  end

  it 'the highest straight hand wins' do
    expect(other_straight).to be > straight
  end

  it 'the flush beats every hand below it' do
    expect(flush.highest_win).to eq('flush')
    expect(flush).to be > straight
    expect(flush).to be > three_of_a_kind
    expect(flush).to be > two_pairs
    expect(flush).to be > pair
    expect(flush).to be > high_card
  end

  it 'the full house beats every hand below it' do
    expect(full_house.highest_win).to eq('full_house')
    expect(full_house).to be > flush
    expect(full_house).to be > straight
    expect(full_house).to be > three_of_a_kind
    expect(full_house).to be > two_pairs
    expect(full_house).to be > pair
    expect(full_house).to be > high_card
  end

  it 'the four of a kind beats every hand below it' do
    expect(four_of_a_kind.highest_win).to eq('four_of_a_kind')
    expect(four_of_a_kind.four_of_a_kind.map(&:value)).to contain_exactly('2', '2', '2', '2')
    expect(four_of_a_kind).to be > full_house
    expect(four_of_a_kind).to be > flush
    expect(four_of_a_kind).to be > straight
    expect(four_of_a_kind).to be > three_of_a_kind
    expect(four_of_a_kind).to be > two_pairs
    expect(four_of_a_kind).to be > pair
    expect(four_of_a_kind).to be > high_card
  end

  it 'the highest four of a kind hand wins' do
    expect(other_four_of_a_kind).to be > four_of_a_kind
  end

  it 'the straight flush beats every hand below it' do
    expect(straight_flush.highest_win).to eq('straight_flush')
    expect(straight_flush).to be > four_of_a_kind
    expect(straight_flush).to be > full_house
    expect(straight_flush).to be > flush
    expect(straight_flush).to be > straight
    expect(straight_flush).to be > three_of_a_kind
    expect(straight_flush).to be > two_pairs
    expect(straight_flush).to be > pair
    expect(straight_flush).to be > high_card
  end

  it 'the royal flush beats every hand below it' do
    expect(royal_flush.highest_win).to eq('royal_flush')
    expect(royal_flush).to be > four_of_a_kind
    expect(royal_flush).to be > full_house
    expect(royal_flush).to be > flush
    expect(royal_flush).to be > straight
    expect(royal_flush).to be > three_of_a_kind
    expect(royal_flush).to be > two_pairs
    expect(royal_flush).to be > pair
    expect(royal_flush).to be > high_card
  end
end

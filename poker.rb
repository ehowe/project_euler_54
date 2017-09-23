require 'active_support/core_ext/string'

class Poker # :nodoc:
  def self.play(player1, player2)
    lines = File.readlines('poker.txt').map(&:strip).map { |h| h.gsub(/\s/, '').chars.each_slice(2).map(&:join).each_slice(5).to_a }

    player1_hands = lines.map(&:first)
    player2_hands = lines.map(&:last)

    player1_hands.each_with_index do |hand, i|
      hands = [Hand.new(player1, hand), Hand.new(player2, player2_hands[i])].sort

      hands.last.player.wins += 1
    end
  end
end

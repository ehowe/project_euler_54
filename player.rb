class Player < Poker # :nodoc:
  attr_reader :hands
  attr_accessor :wins

  def initialize
    @wins  = 0
    @hands = []
  end
end

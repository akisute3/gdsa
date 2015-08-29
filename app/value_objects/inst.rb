class Inst
  DRUMS = ['Drum']
  GUITARS = ['Guitar', 'Base']

  def self.from_game(game)
    case game
    when *DRUMS
      new :drum
    when *GUITARS
      new :guitar
    end
  end

  def initialize(sym)
    @sym = sym
  end

  def to_sym
    @sym
  end

  def games
    case @sym
    when :drum
      DRUMS
    when :guitar
      GUITARS
    end
  end

  def game_ids
    MstGame.where(name: games).pluck(:id)
  end
end

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

  def self.from_game_id(game_id)
    drum_ids = MstGame.where(name: DRUMS).pluck(:id)
    guitar_ids = MstGame.where(name: GUITARS).pluck(:id)

    case game_id.to_i
    when *drum_ids
      new :drum
    when *guitar_ids
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

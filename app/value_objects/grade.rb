class Grade
  def self.from_achievement(achievement)
    case achievement.to_f
    when 0
      new '-'
    when 0...63
      new 'C'
    when 63...73
      new 'B'
    when 73...80
      new 'A'
    when 80...95
      new 'S'
    when 95..100
      new 'SS'
    end
  end


  def initialize(letter)
    @letter = letter
  end

  def to_s
    @letter.to_s
  end
end

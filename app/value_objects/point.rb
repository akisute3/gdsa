class Point
  include Comparable

  def self.calc(level, achievement = 0)
    new((achievement / 100.0) * level * 20.0)
  end

  def initialize(point)
    @point = point
  end

  def +(other)
    self.class.new(@point + other.to_f)
  end

  def -(other)
    self.class.new(@point - other.to_f)
  end

  def +@
    self
  end

  def -@
    self.class.new(-@point)
  end

  def <=>(other)
    to_f <=> other.to_f
  end

  def to_f
    @point
  end

  def to_s
    @point.to_s
  end

  def format
    '%.2f' % @point
  end
end

class Percentage
  include Comparable

  def initialize(percentage)
    @percentage = percentage
  end

  def +(other)
    self.class.new(@percentage + other.to_f)
  end

  def -(other)
    self.class.new(@percentage - other.to_f)
  end

  def +@
    self
  end

  def -@
    self.class.new(-@percentage)
  end

  def <=>(other)
    to_f <=> other.to_f
  end

  def diff(other)
    @percentage ? self - other : self.class.new(nil)
  end

  def to_f
    @percentage || 0
  end

  def to_s
    self.to_f.to_s
  end

  def format
    (@percentage.nil?) ? '' : '%.2f %' % @percentage
  end
end

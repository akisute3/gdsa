class Skill < ActiveRecord::Base

  belongs_to :mst_level

  validates :achievement,
    numericality: {more_than_or_equal_to: 0, less_than_or_equal_to: 100}
  validates :goal,
    allow_blank: true,
    numericality: {more_than_or_equal_to: 0, less_than_or_equal_to: 100}

end

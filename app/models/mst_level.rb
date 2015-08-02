class MstLevel < ActiveRecord::Base
  has_many :skills
  belongs_to :mst_music
  belongs_to :mst_game
  belongs_to :mst_difficulty
end

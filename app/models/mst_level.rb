# coding: utf-8
class MstLevel < ActiveRecord::Base
  has_many :skills
  belongs_to :mst_music
  belongs_to :mst_game
  belongs_to :mst_difficulty

  # edit メソッドで変更を許可しない mst_game_id の配列を返す
  def disabled_ids
    return unless self.mst_music_id
    self.mst_game_id == 1 ? [2, 3] : [1]
  end

  # レベルを文字列で返す。
  # ただし、ギタフリなら Guitar か Base を判別する文字を付ける
  def format
    str = '%.2f' % level
    str += " (#{level.mst_game.name[0, 1]})" if mst_game.inst.to_sym == :guitar
    str
  end
end

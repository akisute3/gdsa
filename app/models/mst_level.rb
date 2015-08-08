# coding: utf-8
class MstLevel < ActiveRecord::Base
  has_many :skills
  belongs_to :mst_music
  belongs_to :mst_game
  belongs_to :mst_difficulty

  # 同じゲーム (ドラムorギター) かつ同じ曲の全レベルの id リストを取得
  def extract_same_group_ids
    game_ids = (self.mst_game.name == 'Drum') ? [1] : [2, 3]
    music_id = self.mst_music.id
    self.class.where(mst_game_id: game_ids, mst_music_id: music_id)
  end

  # edit メソッドで変更を許可しない mst_game_id の配列を返す
  def disabled_ids
    return unless self.mst_music_id
    self.mst_game_id == 1 ? [2, 3] : [1]
  end
end

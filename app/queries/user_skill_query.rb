# coding: utf-8
class UserSkillQuery
  def initialize(relation = Skill.all)
    @relation = relation
  end

  # 引数のユーザ、楽器、曲種のスキル一覧をスキルポイントの高い順にソートして返す。
  # inst は :guitar / :drum、music_type は :hot / :other。
  def find(user_id, inst, music_type)
    inst = Inst.new(inst)
    is_hot = (music_type == :hot)

    @relation.includes(mst_level: [:mst_music, :mst_game, :mst_difficulty])
      .where(user_id: user_id)
      .where('mst_musics.hot' => is_hot)
      .where('mst_games.id' => inst.game_ids)
      .sort_by {|s| -s.point }
  end
end

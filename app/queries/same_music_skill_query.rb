# coding: utf-8
class SameMusicSkillQuery
  def initialize(relation = Skill.all)
    @relation = relation
  end

  def find(user_id, level_params)
    @relation.where(opts(user_id, level_params))
  end

  # level_param の難易度が存在しなければ
  # mst_level_id = -1 (存在しない level_id) で初期化する
  def find_or_initialize(user_id, level_params)
    @relation.find_or_initialize_by(opts(user_id, level_params)) do |skill|
      skill.user_id = user_id
      skill.mst_level = MstLevel.find_by(level_params) || -1
    end
  end


  private
    # スキルを上書きすべき MstLevel を取得するための SQL の条件式を返す
    def opts(user_id, level_params)
      {user_id: user_id, mst_level_id: same_music_level_ids(level_params)}
    end

    # 同じ曲扱いになる全 level_id を返す
    # (引数の level_params が Guitar のある曲のある難易度に対応している場合は、
    #  Guitar と Base のその曲の全難易度の level_id の配列を返す)
    def same_music_level_ids(level_params)
      inst = Inst.from_game_id(level_params[:mst_game_id])
      opts = {mst_game_id: inst.game_ids, mst_music_id: level_params[:mst_music_id]}
      MstLevel.where(opts).pluck(:id)
    end
end

# coding: utf-8
class Skill < ActiveRecord::Base
  belongs_to :mst_level

  validates :achievement,
    numericality: {more_than_or_equal_to: 0, less_than_or_equal_to: 100}
  validates :goal,
    allow_blank: true,
    numericality: {more_than_or_equal_to: 0, less_than_or_equal_to: 100}


  GAMES_GUITAR = ["Guitar", "Base"]
  GAMES_DRUM = "Drum"

  # 引数のユーザ、曲種、ゲームのスキル一覧をスキルポイント順にソートして返す。
  # game_type は :guitar / :drum、music_type は :hot / :other。
  def self.find_target(id, game_type, music_type)
    games = (game_type == :guitar) ? GAMES_GUITAR : GAMES_DRUM
    is_hot = (music_type == :hot)

    skills = Skill.includes(mst_level: [:mst_music, :mst_game, :mst_difficulty])
             .where("user_id" => id)
             .where("mst_musics.hot" => is_hot)
             .where("mst_games.name" => games)

    skills.sort_by {|s| -s.point }
  end


  # スキル計算に使用される曲の順位の下限
  HOT_SKILL_LIMIT = OTHER_SKILL_LIMIT = 25

  # game_type は :guitar / :drum、skill_type は :current / :goal。
  # 返り値は {current: 現在スキル, hot: 新曲スキル, other: 旧曲スキル, all: 全曲スキル}。
  def self.point_list(id, game_type, skill_type)
    skills = {
      hot: self.find_target(id, game_type, :hot),
      other: self.find_target(id, game_type, :other)
    }

    if skill_type == :current
      skill_points = skills.map {|k,v| [k, v.map{|a| a.point }] }.to_h
    else
      skill_points = skills.map {|k,v| [k, v.map{|a| a.goal_point }] }.to_h
    end

    hot = skill_points[:hot].slice(0, HOT_SKILL_LIMIT).inject(0, :+)
    other = skill_points[:other].slice(0, OTHER_SKILL_LIMIT).inject(0, :+)
    all = skill_points[:hot].inject(0, :+) + skill_points[:other].inject(0, :+)

    {current: hot + other, hot: hot, other: other, all: all}
  end


  # 曲レベルと達成率からスキルポイントを計算して返す
  def point
    return (self.achievement / 100) * self.mst_level.level * 20
  end

  # 曲レベルと目標達成率からスキルポイントを計算して返すが
  # target を設定していなければスキルポイントを返す
  def goal_point
    return point unless self.goal
    return (self.goal / 100) * self.mst_level.level * 20
  end


  # save の事前処理追加版
  def check_and_save
    # mst_level が存在しなければ nil を返す
    return nil unless self.mst_level

    # 重複する Skill を削除してから save
    delete_existing_target
    save
  end

  # update の事前処理追加版
  def check_and_update(skill_params, level_params)
    # mst_level_id が存在しなければ nil を返す
    l = MstLevel.find_by(level_params)
    l ? update(skill_params.merge(mst_level_id: l.id)) : nil
  end


  private
    def delete_existing_target
      same_group_ids = self.mst_level.extract_same_group_ids
      self.class.delete_all(user_id: self.user_id, mst_level_id: same_group_ids)
    end
end

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
  # inst は :guitar / :drum、music_type は :hot / :other。
  def self.find_target(id, inst, music_type)
    games = (inst == :guitar) ? GAMES_GUITAR : GAMES_DRUM
    is_hot = (music_type == :hot)

    skills = Skill.includes(mst_level: [:mst_music, :mst_game, :mst_difficulty])
             .where("user_id" => id)
             .where("mst_musics.hot" => is_hot)
             .where("mst_games.name" => games)

    skills.sort_by {|s| -s.point }
  end


  # スキル計算に使用される曲の順位の下限
  HOT_SKILL_LIMIT = OTHER_SKILL_LIMIT = 25

  # inst は :guitar / :drum、skill_type は :current / :goal。
  # 返り値は {current: 現在スキル, hot: 新曲スキル, other: 旧曲スキル, all: 全曲スキル}。
  def self.point_list(id, inst, skill_type)
    skills = {
      hot: find_target(id, inst, :hot),
      other: find_target(id, inst, :other)
    }

    if skill_type == :current
      skill_points = skills.map {|k,v| [k, v.map{|a| a.point.to_f }] }.to_h
    else
      skill_points = skills.map {|k,v| [k, v.map{|a| a.goal_point.to_f }] }.to_h
    end

    hot = skill_points[:hot].slice(0, HOT_SKILL_LIMIT).inject(0, :+)
    other = skill_points[:other].slice(0, OTHER_SKILL_LIMIT).inject(0, :+)
    all = skill_points[:hot].inject(0, :+) + skill_points[:other].inject(0, :+)

    {current: hot + other, hot: hot, other: other, all: all}
  end


  # カラムの float を Percentage オブジェクトにすり替える
  def achievement
    @achievement ||= Percentage.new(self.read_attribute(:achievement))
  end

  # カラムの float を Percentage オブジェクトにすり替える
  def goal
    @goal ||= Percentage.new(self.read_attribute(:goal))
  end

  # 曲レベルと達成率からスキルを計算した Point オブジェクトを返す
  def point
    @point ||= Point.calc(mst_level.level, achievement.to_f)
  end

  # 曲レベルと目標達成率からスキルを計算した Point オブジェクトを返す
  def goal_point
    @goal_point ||= Point.calc(mst_level.level, goal.to_f)
  end


  # 達成率から評価を求める (返り値は文字列、未クリアなら '-' を返す)
  def grade
    case self.achievement.to_f
    when 0
      '-'
    when 0...63
      'C'
    when 63...73
      'B'
    when 73...80
      'A'
    when 80...95
      'S'
    when 95..100
      'SS'
    end
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

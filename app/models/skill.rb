# coding: utf-8
class Skill < ActiveRecord::Base
  belongs_to :mst_level

  validates :user_id, presence: true
  validates :mst_level, presence: true
  validates :mst_level, unique_music: true, on: :create
  validates :raw_achievement,
    format: {with: /\A\d+(\.\d{1,2})?\z/},
    numericality: {more_than_or_equal_to: 0, less_than_or_equal_to: 100}
  validates :raw_goal,
    allow_blank: true,
    format: {with: /\A\d+(\.\d{1,2})?\z/},
    numericality: {more_than_or_equal_to: 0, less_than_or_equal_to: 100}


  # スキル計算に使用される曲の順位の下限
  HOT_SKILL_LIMIT = OTHER_SKILL_LIMIT = 25

  # inst は :guitar / :drum、skill_type は :current / :goal。
  # 返り値は {current: 現在スキル, hot: 新曲スキル, other: 旧曲スキル, all: 全曲スキル}。
  def self.point_list(id, inst, skill_type)
    skills = {
      hot: UserSkillQuery.new.find(id, inst, :hot),
      other: UserSkillQuery.new.find(id, inst, :other)
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
    @achievement ||= Percentage.new(read_attribute(:achievement))
  end

  def goal
    @goal ||= Percentage.new(read_attribute(:goal))
  end

  def raw_achievement
    read_attribute(:achievement)
  end

  def raw_goal
    read_attribute(:goal)
  end

  # 曲レベルと達成率からスキルを計算した Point オブジェクトを返す
  def point
    @point ||= Point.calc(mst_level.level, achievement.to_f)
  end

  # 曲レベルと目標達成率からスキルを計算した Point オブジェクトを返す
  def goal_point
    @goal_point ||= Point.calc(mst_level.level, goal.to_f)
  end

  def grade
    @grade ||= Grade.from_achievement(achievement)
  end
end

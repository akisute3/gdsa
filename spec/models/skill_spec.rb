# coding: utf-8
require 'rails_helper'

RSpec.describe Skill, type: :model do
  fixtures(:all)

  # 有効なパラメータのときに create が正常動作
  it '存在する難易度にスキルを登録できる' do
    expect(build(:valid_difficulty)).to be_valid
  end

  # バリデーションを失敗させるデータを正常完了させない
  it 'ユーザ ID が未入力のスキルは登録しない' do
    skill = build(:valid_difficulty, user_id: nil)
    skill.valid?
    expect(skill.errors[:user_id]).to include("can't be blank")
  end

  it '存在しない難易度には登録しない' do
    skill = build(:invalid_difficulty)
    skill.valid?
    expect(skill.errors[:mst_level]).to include("can't be blank")
  end

  it '同じユーザが同じ楽器の同じ曲に複数のスキルを登録できない' do
    create(:valid_difficulty)
    skill = build(:duplication_difficulty)
    skill.valid?
    expect(skill.errors[:mst_level]).to include('が同じグループに属するスキルは既に登録されています。')
  end


  shared_examples 'パーセントのバリデーションテスト' do
    it '0 より小さい値は登録できない' do
      expect(build(:valid_difficulty, @col => -0.01)).to_not be_valid
    end

    it '0 を登録できる' do
      expect(build(:valid_difficulty, @col => 0.0)).to be_valid
    end

    it '100 を登録できる' do
      expect(build(:valid_difficulty, @col => 100.0)).to be_valid
    end

    it '100 より大きい値は登録できない' do
      expect(build(:valid_difficulty, @col => 100.01)).to_not be_valid
    end

    it '整数を入力可能' do
      expect(build(:valid_difficulty, @col => 99)).to be_valid
    end

    it '小数点第 2 位を入力可能' do
      expect(build(:valid_difficulty, @col => 99.99)).to be_valid
    end

    it '小数点第 3 位は入力不可' do
      expect(build(:valid_difficulty, @col => 99.999)).to_not be_valid
    end
  end

  context '達成率' do
    before do
      @col = :achievement
    end

    it_should_behave_like 'パーセントのバリデーションテスト'
  end


  context '目標達成率' do
    before do
      @col = :goal
    end

    it_should_behave_like 'パーセントのバリデーションテスト'
  end

  # インスタンスメソッドの期待通りの挙動
  it 'スキルポイントリストを取得できる'

  context 'カラム名で Percentage オブジェクトを取得できる' do
    it '達成率' do
      skill = build(:valid_difficulty)
      expect(skill.achievement).to be_a_kind_of(Percentage)
      expect(skill.achievement.to_f).to eq 85.0
    end

    it '目標達成率' do
      skill = build(:valid_difficulty)
      expect(skill.goal).to be_a_kind_of(Percentage)
      expect(skill.goal.to_f).to eq 98.0
    end
  end

  context 'カラム名で Point オブジェクトを取得できる' do
    it 'スキルポイント' do
      skill = build(:valid_difficulty)
      expect(skill.point).to be_a_kind_of(Point)
      expect(skill.point.to_f).to eq 113.9
    end

    it '目標スキルポイント' do
      skill = build(:valid_difficulty)
      expect(skill.goal_point).to be_a_kind_of(Point)
      expect(skill.goal_point.to_f).to eq 131.32
    end
  end

  it '達成率の評価となる Grade オブジェクトを取得できる' do
    skill = build(:valid_difficulty)
    expect(skill.grade).to be_a_kind_of(Grade)
    expect(skill.grade.to_s).to eq 'S'
  end
end

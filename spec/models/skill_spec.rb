# coding: utf-8
require 'rails_helper'

RSpec.describe Skill, type: :model do
  fixtures(:all)

  # 有効なパラメータのときに create が正常動作
  it '存在する難易度にスキルを登録できる' do
    expect(build(:valid_difficulty)).to be_valid
  end

  # バリデーションを失敗させるデータを正常完了させない
  it '存在しない難易度には登録しない' do
    expect(build(:invalid_difficulty)).to_not be_valid
  end

  it '同じユーザが同じ楽器の同じ曲に複数のスキルを登録できない' do
    create(:valid_difficulty)
    expect(build(:duplication_difficulty)).to_not be_valid
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
  it '95.0〜100.0 が SS、80.0〜 が S、 73.0〜 が A、63.0〜 が B、それ以外は C 評価とする'
  it '達成率より目標達成率が低い場合は、現在の達成率を目標達成率として計算する'
end

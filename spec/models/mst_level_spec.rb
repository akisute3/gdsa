# coding: utf-8
require 'rails_helper'

RSpec.describe MstLevel, type: :model do
  context '難易度の表示用文字列を返すことができる' do
    it 'Drum は少数第 2 位までの数値' do
      level = MstLevel.find(1)
      expect(level.format).to eq '2.30'
    end

    it 'Guitar は少数第 2 位までの数値の後ろに (G) が付く' do
      level = MstLevel.find(6)
      expect(level.format).to eq '4.20 (G)'
    end

    it 'Bass は少数第 2 位までの数値の後ろに (B) が付く' do
      level = MstLevel.find(10)
      expect(level.format).to eq '3.70 (B)'
    end
  end
end

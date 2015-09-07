# coding: utf-8
require 'rails_helper'

RSpec.describe MstGame, type: :model do
  context 'ゲームに対応した Inst オブジェクトを取得できる' do
    it 'Drum' do
      game = MstGame.find_by(name: 'Drum')
      expect(game.inst.to_sym).to eq :drum
    end
    it 'Guitar' do
      game = MstGame.find_by(name: 'Guitar')
      expect(game.inst.to_sym).to eq :guitar
    end
    it 'Bass' do
      game = MstGame.find_by(name: 'Bass')
      expect(game.inst.to_sym).to eq :guitar
    end
  end
end

# coding: utf-8
require 'rails_helper'

RSpec.describe Inst, type: :value_object do
  shared_examples 'ゲーム毎のテスト' do
    it 'シンボルを取得できる' do
      expect(@inst.to_sym).to eq @sym
    end

    it 'ゲーム名リストを取得できる' do
      expect(@inst.games).to eq @games
    end

    it 'ゲーム ID リストを取得できる' do
      expect(@inst.game_ids).to eq @game_ids
    end
  end

  describe 'Drum' do
    before do
      @inst = Inst.from_game('Drum')
      @sym = :drum
      @games = ['Drum']
      @game_ids = [1]
    end

    it_should_behave_like 'ゲーム毎のテスト'
  end

  describe 'Guitar' do
    before do
      @inst = Inst.from_game('Guitar')
      @sym = :guitar
      @games = ['Guitar', 'Base']
      @game_ids = [2, 3]
    end

    it_should_behave_like 'ゲーム毎のテスト'
  end

  describe 'Base' do
    before do
      @inst = Inst.from_game('Guitar')
      @sym = :guitar
      @games = ['Guitar', 'Base']
      @game_ids = [2, 3]
    end

    it_should_behave_like 'ゲーム毎のテスト'
  end
end

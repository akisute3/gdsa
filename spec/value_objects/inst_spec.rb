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

    it '別の楽器のゲーム名リストを取得できる' do
      expect(@inst.reversed_games).to eq @reversed_games
    end

    it '別の楽器のゲーム ID リストを取得できる' do
      expect(@inst.reversed_game_ids).to eq @reversed_game_ids
    end
  end

  describe 'Drum' do
    before do
      @inst = Inst.from_game('Drum')
      @sym = :drum
      @games, @reversed_games = ['Drum'], ['Guitar', 'Bass']
      @game_ids, @reversed_game_ids = [1], [2, 3]
    end

    it_should_behave_like 'ゲーム毎のテスト'
  end

  describe 'Guitar' do
    before do
      @inst = Inst.from_game('Guitar')
      @sym = :guitar
      @games, @reversed_games = ['Guitar', 'Bass'], ['Drum']
      @game_ids, @reversed_game_ids = [2, 3], [1]
    end

    it_should_behave_like 'ゲーム毎のテスト'
  end

  describe 'Bass' do
    before do
      @inst = Inst.from_game('Guitar')
      @sym = :guitar
      @games, @reversed_games = ['Guitar', 'Bass'], ['Drum']
      @game_ids, @reversed_game_ids = [2, 3], [1]
    end

    it_should_behave_like 'ゲーム毎のテスト'
  end
end

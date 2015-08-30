# coding: utf-8
require 'rails_helper'

RSpec.describe Percentage, type: :value_object do
  shared_examples '代入する値ごとのテスト' do
    it '少数を取得できる' do
      expect(@percentage.to_f).to eq @f
    end

    it '文字列を取得できる' do
      expect(@percentage.to_s).to eq @s
    end

    it '少数第3位以降を切り捨て、パーセント記号を付けた表示用文字列を取得できる' do
      expect(@percentage.format).to eq @formatted
    end
  end


  describe 'nil で初期化したとき' do
    before do
      @percentage = Percentage.new(nil)
      @f = 0
      @s = ''
      @formatted = ''
    end

    it_should_behave_like '代入する値ごとのテスト'
  end

  describe 'Float で初期化したとき' do
    before do
      @percentage = Percentage.new(12.34)
      @f = 12.34
      @s = '12.34'
      @formatted = '12.34 %'
    end

    it_should_behave_like '代入する値ごとのテスト'


    it 'オブジェクト同士の比較ができる' do
      min = Percentage.new(12.33)
      expect(@percentage).to be >= min
    end

    context '加算ができる:' do
      it '引数が Float' do
        res = @percentage + 0.1
        expect(res).to be_a_kind_of(Percentage)
        expect(res.to_f).to eq 12.44
      end

      it '引数が Percentage' do
        p = Percentage.new(0.1)
        res = @percentage + p
        expect(res).to be_a_kind_of(Percentage)
        expect(res.to_f).to eq 12.44
      end
    end

    context '減算ができる:' do
      it '引数が Float' do
        res = @percentage - 0.1
        expect(res).to be_a_kind_of(Percentage)
        expect(res.to_f).to eq 12.24
      end

      it '引数が Point' do
        p = Percentage.new(0.1)
        res = @percentage - p
        expect(res).to be_a_kind_of(Percentage)
        expect(res.to_f).to eq 12.24
      end
    end

    it '+percentage を取得できる' do
      expect(+@percentage.to_f).to eq 12.34
    end

    it '-percentage を取得できる' do
      expect(-@percentage.to_f).to eq (-12.34)
    end
  end
end

# coding: utf-8
require 'rails_helper'

RSpec.describe Point, type: :value_object do
  # Lv 9.99 を達成率 99.99 時にスキルは 199.78002
  let(:point) { Point.calc(9.99, 99.99) }

  it 'スキルポイントを少数で取得できる' do
    expect(point.to_f).to eq 199.78002
  end

  it 'スキルポイントを文字列で取得できる' do
    expect(point.to_s).to eq '199.78002'
  end

  it '少数第3位以降を切り捨てたスキルポイントの文字列を取得できる' do
    expect(point.format).to eq '199.78'
  end

  it 'オブジェクト同士の比較ができる' do
    min = Point.calc(9.99, 99.98)
    expect(point).to be >= min
  end

  context '加算ができる:' do
    it '引数が Float' do
      res = point + 0.1
      expect(res).to be_a_kind_of(Point)
      expect(res.to_f).to eq 199.88002
    end

    it '引数が Point' do
      p = Point.new(0.1)
      res = point + p
      expect(res).to be_a_kind_of(Point)
      expect(res.to_f).to eq 199.88002
    end
  end

  context '減算ができる:' do
    it '引数が Float' do
      res = point - 0.1
      expect(res).to be_a_kind_of(Point)
      expect(res.to_f).to eq 199.68002
    end

    it '引数が Point' do
      p = Point.new(0.1)
      res = point - p
      expect(res).to be_a_kind_of(Point)
      expect(res.to_f).to eq 199.68002
    end
  end

  it '+point を取得できる' do
    expect(+point.to_f).to eq 199.78002
  end

  it '-point を取得できる' do
    expect(-point.to_f).to eq (-199.78002)
  end
end

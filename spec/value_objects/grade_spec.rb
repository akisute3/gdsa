# coding: utf-8
require 'rails_helper'

RSpec.describe Grade, type: :value_object do
  it '達成率 0 は評価無し' do
    expect(Grade.from_achievement(0).to_s).to eq '-'
  end

  it '達成率 0 以上 63 未満は評価 C' do
    expect(Grade.from_achievement(0.01).to_s).to eq 'C'
    expect(Grade.from_achievement(62.99).to_s).to eq 'C'
  end

  it '達成率 63 以上 73 未満は評価 B' do
    expect(Grade.from_achievement(63.00).to_s).to eq 'B'
    expect(Grade.from_achievement(72.99).to_s).to eq 'B'
  end

  it '達成率 73 以上 80 未満は評価 A' do
    expect(Grade.from_achievement(73.00).to_s).to eq 'A'
    expect(Grade.from_achievement(79.99).to_s).to eq 'A'
  end

  it '達成率 80 以上 95 未満は評価 S' do
    expect(Grade.from_achievement(80.00).to_s).to eq 'S'
    expect(Grade.from_achievement(94.99).to_s).to eq 'S'
  end

  it '達成率 95 以上は評価 SS' do
    expect(Grade.from_achievement(95.00).to_s).to eq 'SS'
    expect(Grade.from_achievement(100.00).to_s).to eq 'SS'
  end
end

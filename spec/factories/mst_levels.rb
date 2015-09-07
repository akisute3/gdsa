# coding: utf-8
FactoryGirl.define do
  factory :drum_level, class: MstLevel do
    id 15
    mst_game_id 1
    mst_difficulty_id 3
    mst_music_id 2
    level 8.35
  end

  factory :invalid_drum_level, class: MstLevel do
    id 16
    mst_game_id 1
    mst_difficulty_id 4
    mst_music_id 2
    level 9.99
  end

  factory :guitar_level, class: MstLevel do
    id 19
    mst_game_id 2
    mst_difficulty_id 3
    mst_music_id 2
    level 6.70
  end

  factory :invalid_guitar_level, class: MstLevel do
    id 20
    mst_game_id 2
    mst_difficulty_id 4
    mst_music_id 2
    level 9.99
  end
end

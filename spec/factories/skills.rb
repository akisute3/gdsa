# coding: utf-8
FactoryGirl.define do
  factory :drum_skill, class: Skill do
    user_id 1
    mst_level_id 15
    achievement 85.0
    full_combo false
    comment "フルコン目指す"
    goal 98.0

    factory :duplicate_drum_skill do
      mst_level_id 13
    end

    factory :invalid_drum_skill do
      mst_level_id 16
    end
  end

  factory :guitar_skill, class: Skill do
    user_id 1
    mst_level_id 19
    achievement 85.0
    full_combo false
    comment "フルコン目指す"
    goal 98.0

    factory :duplicate_guitar_skill do
      mst_level_id 21
    end

    factory :invalid_guitar_skill do
      mst_level_id 20
    end

    factory :duplicate_other_user_skill do
      user_id 2
      mst_level_id 21
    end

    factory :other_user_skill do
      user_id 2
    end
  end
end

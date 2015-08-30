# coding: utf-8
FactoryGirl.define do
  factory :skill do
    user_id 1
    achievement 85.0
    full_combo false
    comment "フルコン目指す"
    goal 98.0

    factory :valid_difficulty do
      mst_level_id 19
    end

    factory :duplication_difficulty do
      mst_level_id 21
    end

    factory :invalid_difficulty do
      mst_level_id 20
    end
  end
end

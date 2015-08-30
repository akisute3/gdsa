# coding: utf-8
class UniqueMusicValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.kind_of?(MstLevel)

    same_music_level_ids = value.extract_same_group_ids.pluck(:id)
    same_music_skills = Skill.where(user_id: record.user_id)
                        .where(mst_level_id: same_music_level_ids)
    record.errors[attribute] << "が同じグループに属するスキルは既に登録されています。" unless same_music_skills.empty?
  end
end

# coding: utf-8
class UniqueMusicValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.kind_of?(MstLevel)

    unless SameMusicSkillQuery.new.find(record.user_id, value).empty?
      record.errors[attribute] << "が同じグループに属するスキルは既に登録されています。"
    end
  end
end

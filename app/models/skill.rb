# coding: utf-8
class Skill < ActiveRecord::Base
  belongs_to :mst_level

  validates :achievement,
    numericality: {more_than_or_equal_to: 0, less_than_or_equal_to: 100}
  validates :goal,
    allow_blank: true,
    numericality: {more_than_or_equal_to: 0, less_than_or_equal_to: 100}


  def check_and_save
    # mst_level が存在しなければ nil を返す
    return nil unless self.mst_level

    # 重複する Skill を削除してから save
    delete_existing_target
    save
  end


  def check_and_update(skill_params, level_params)
    # mst_level_id が存在しなければ nil を返す
    l = MstLevel.find_by(level_params)
    l ? update(skill_params.merge(mst_level_id: l.id)) : nil
  end


  private
    def delete_existing_target
      same_group_ids = self.mst_level.extract_same_group_ids
      self.class.delete_all(user_id: self.user_id, mst_level_id: same_group_ids)
    end
end

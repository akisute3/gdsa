class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.integer :user_id
      t.integer :mst_level_id
      t.float :achievement
      t.boolean :full_combo
      t.text :comment
      t.float :goal

      t.timestamps null: false
    end
  end
end

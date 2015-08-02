class CreateMstLevels < ActiveRecord::Migration
  def change
    create_table :mst_levels do |t|
      t.integer :mst_game_id
      t.integer :mst_difficulty_id
      t.integer :mst_music_id
      t.float :level

      t.timestamps null: false
    end
  end
end

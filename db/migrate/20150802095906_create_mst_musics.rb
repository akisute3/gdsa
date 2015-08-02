class CreateMstMusics < ActiveRecord::Migration
  def change
    create_table :mst_musics do |t|
      t.boolean :hot
      t.string :name
      t.integer :bpm
      t.integer :max_bpm

      t.timestamps null: false
    end
  end
end

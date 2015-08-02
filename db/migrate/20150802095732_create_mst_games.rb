class CreateMstGames < ActiveRecord::Migration
  def change
    create_table :mst_games do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end

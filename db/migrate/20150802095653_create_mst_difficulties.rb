class CreateMstDifficulties < ActiveRecord::Migration
  def change
    create_table :mst_difficulties do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end

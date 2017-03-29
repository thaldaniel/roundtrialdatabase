class CreateProceedings < ActiveRecord::Migration
  def change
    create_table :proceedings do |t|
      t.integer :roundtrial_id, index: true
      t.string :name

      t.timestamps null: false
    end
  end
end

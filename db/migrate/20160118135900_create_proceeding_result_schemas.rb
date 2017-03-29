class CreateProceedingResultSchemas < ActiveRecord::Migration
  def change
    create_table :proceeding_result_schemas do |t|
      t.integer :proceeding_id, index: true
      t.text :result_schema
      t.text :metadata_schema

      t.timestamps null: false
    end
  end
end

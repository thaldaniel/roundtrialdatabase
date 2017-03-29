class AddLastCheckToProceedings < ActiveRecord::Migration
  def change
    add_column :proceedings, :last_import, :datetime
  end
end

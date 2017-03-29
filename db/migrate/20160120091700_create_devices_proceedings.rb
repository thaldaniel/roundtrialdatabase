class CreateDevicesProceedings < ActiveRecord::Migration
  def change
    create_table :devices_proceedings, id:false do |t|
      t.belongs_to :device, index: true
      t.belongs_to :proceeding, index: true
    end
  end
end

class CreateShops < ActiveRecord::Migration[7.0]
  def change
    create_table :shops do |t|

      t.timestamps
      t.string :name
      t.float :latitude
      t.float :longitude
      t.float :evaluation
    end
  end
end

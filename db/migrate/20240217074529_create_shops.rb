class CreateShops < ActiveRecord::Migration[7.0]
  def change
    create_table :shops do |t|

      t.timestamps
      t.integer :user_id
      t.string :name, null: false
      t.string :address, null: false
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.float :evaluation, null: false
      t.boolean :is_favorite, default: false

      t.string :phone_number
      t.string :monday
      t.string :tuesday
      t.string :wednesday
      t.string :thursday
      t.string :friday
      t.string :saturday
      t.string :sunday
    end
  end
end

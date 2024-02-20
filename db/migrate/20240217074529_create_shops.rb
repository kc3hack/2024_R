class CreateShops < ActiveRecord::Migration[7.0]
  def change
    create_table :shops do |t|

      t.timestamps
      t.integer :user_id
      t.string :name, null: false
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.float :evaluation, null: false
      t.boolean :is_favorite, default: false
    end
  end
end

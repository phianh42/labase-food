class CreateMealGuests < ActiveRecord::Migration[8.0]
  def change
    create_table :meal_guests do |t|
      t.references :meal, null: false, foreign_key: true
      t.references :guest, null: false, foreign_key: true
      t.timestamps
    end
    
    add_index :meal_guests, [:meal_id, :guest_id], unique: true
  end
end

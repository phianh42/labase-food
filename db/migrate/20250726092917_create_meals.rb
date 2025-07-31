class CreateMeals < ActiveRecord::Migration[8.0]
  def change
    create_table :meals do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date, null: false
      t.string :meal_type, null: false
      t.text :notes
      t.timestamps
    end
    
    add_index :meals, :date
    add_index :meals, :meal_type
  end
end

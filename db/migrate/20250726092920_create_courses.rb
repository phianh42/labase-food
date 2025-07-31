class CreateCourses < ActiveRecord::Migration[8.0]
  def change
    create_table :courses do |t|
      t.references :meal, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :order_number, null: false
      t.timestamps
    end
    
    add_index :courses, :order_number
  end
end

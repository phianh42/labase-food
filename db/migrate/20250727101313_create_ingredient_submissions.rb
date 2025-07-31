class CreateIngredientSubmissions < ActiveRecord::Migration[8.0]
  def change
    create_table :ingredient_submissions do |t|
      t.references :user, foreign_key: true
      t.references :recipe, foreign_key: true
      t.string :ingredient_name, null: false
      t.string :detected_unit
      t.string :detected_quantity
      t.string :context
      t.string :status, default: 'pending'
      t.timestamps
    end
    
    add_index :ingredient_submissions, :ingredient_name
    add_index :ingredient_submissions, :status
  end
end

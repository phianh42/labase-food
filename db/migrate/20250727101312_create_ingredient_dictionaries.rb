class CreateIngredientDictionaries < ActiveRecord::Migration[8.0]
  def change
    create_table :ingredient_dictionaries do |t|
      t.string :name, null: false
      t.string :plural_form
      t.string :category
      t.boolean :approved, default: true
      t.integer :submitted_by
      t.string :gender # m/f for French
      t.text :aliases # JSON array
      t.timestamps
    end
    
    add_index :ingredient_dictionaries, :name, unique: true
    add_index :ingredient_dictionaries, :approved
    add_index :ingredient_dictionaries, :category
    add_index :ingredient_dictionaries, :plural_form
  end
end

class CreateIngredientParsingLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :ingredient_parsing_logs do |t|
      t.references :recipe, foreign_key: true
      t.references :user, foreign_key: true
      t.text :original_text
      t.json :results
      t.integer :ingredients_found
      t.integer :ingredients_added
      t.float :confidence_score
      t.timestamps
    end
    
    add_index :ingredient_parsing_logs, :created_at
  end
end

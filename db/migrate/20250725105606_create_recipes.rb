class CreateRecipes < ActiveRecord::Migration[8.0]
  def change
    create_table :recipes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.integer :preparation_time
      t.integer :cooking_time
      t.integer :servings
      t.string :difficulty
      t.boolean :is_public, default: true
      t.string :slug

      t.timestamps
    end
    
    add_index :recipes, :slug, unique: true
    add_index :recipes, :is_public
  end
end

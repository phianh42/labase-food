class AddParsedIngredientsToRecipes < ActiveRecord::Migration[8.0]
  def change
    add_column :recipes, :parsed_ingredients, :json
    add_column :recipes, :ingredients_parsed_at, :datetime
    add_column :recipes, :parsing_version, :string
  end
end

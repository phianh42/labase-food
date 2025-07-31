class CreateCourseRecipes < ActiveRecord::Migration[8.0]
  def change
    create_table :course_recipes do |t|
      t.references :course, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true
      t.text :comments
      t.timestamps
    end
    
    add_index :course_recipes, [:course_id, :recipe_id], unique: true
  end
end

module RecipesHelper

  def search_active?
    params[:q].present? && params[:q][:title_or_description_or_recipe_steps_instruction_or_ingredients_name_or_user_username_cont].present?
  end

  def difficulty_color_class(difficulty)
    case difficulty
    when 'easy' then 'text-green-600'
    when 'medium' then 'text-yellow-600'  
    when 'hard' then 'text-red-600'
    else 'text-gray-600'
    end
  end
  
end

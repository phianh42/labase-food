# app/services/ingredient_parser.rb
class IngredientParser
  VERSION = '1.1.0'
  
  # Enhanced French quantity patterns
  QUANTITY_PATTERNS = {
    # Numbers: 1, 2.5, 1,5, etc.
    numbers: /(\d+(?:[,\.]\d+)?)/,
    
    # Fractions
    fractions: /(½|⅓|¼|¾|⅔|1\/2|1\/3|1\/4|3\/4|2\/3)/,
    
    # French number words
    words: /(un|une|deux|trois|quatre|cinq|six|sept|huit|neuf|dix|
            onze|douze|treize|quatorze|quinze|seize|vingt|trente|
            quarante|cinquante|cent|quelques|plusieurs)/x,
    
    # Approximate quantities
    approx: /(environ|approximativement|à peu près|plus ou moins)/
  }
  
  # French units with variations
  UNITS = {
    # Weight
    'g' => ['g', 'gr', 'gramme', 'grammes'],
    'kg' => ['kg', 'kilo', 'kilos', 'kilogramme', 'kilogrammes'],
    'mg' => ['mg', 'milligramme', 'milligrammes'],
    
    # Volume
    'ml' => ['ml', 'millilitre', 'millilitres'],
    'cl' => ['cl', 'centilitre', 'centilitres'],
    'dl' => ['dl', 'décilitre', 'décilitres'],
    'l' => ['l', 'litre', 'litres'],
    
    # Cooking measures
    'cuillère à soupe' => ['cuillère à soupe', 'cuillères à soupe', 'c.à.s', 'c.a.s', 'càs', 'cas'],
    'cuillère à café' => ['cuillère à café', 'cuillères à café', 'c.à.c', 'c.a.c', 'càc', 'cac'],
    'tasse' => ['tasse', 'tasses'],
    'verre' => ['verre', 'verres'],
    'pincée' => ['pincée', 'pincées'],
    'poignée' => ['poignée', 'poignées'],
    
    # Food-specific
    'gousse' => ['gousse', 'gousses'],
    'branche' => ['branche', 'branches'],
    'feuille' => ['feuille', 'feuilles'],
    'brin' => ['brin', 'brins'],
    'bouquet' => ['bouquet', 'bouquets'],
    'tranche' => ['tranche', 'tranches'],
    'morceau' => ['morceau', 'morceaux'],
    'paquet' => ['paquet', 'paquets'],
    'boîte' => ['boîte', 'boîtes', 'boite', 'boites'],
    'sachet' => ['sachet', 'sachets'],
    'pot' => ['pot', 'pots'],
    'bouteille' => ['bouteille', 'bouteilles']
  }
  
  # Prepositions to handle
  PREPOSITIONS = ['de', 'd\'', 'du', 'des', 'à', 'au', 'aux']
  
  attr_reader :recipe, :confidence_scores
  
  def initialize(recipe)
    @recipe = recipe
    @confidence_scores = []
  end
  
  def parse
    ingredients = []
    text = combine_recipe_text
    
    # Load dictionary
    dictionary = IngredientDictionary.approved
    
    # For each ingredient in dictionary, search in text
    dictionary.each do |dict_ingredient|
      dict_ingredient.all_forms.each do |form|
        results = find_ingredient_in_text(text, form, dict_ingredient)
        ingredients.concat(results)
      end
    end
    
    # Remove duplicates and sort by position in text
    ingredients = ingredients.uniq { |i| i[:name] }
                           .sort_by { |i| i[:position] }
    
    # Add unique IDs
    ingredients.each_with_index { |ing, idx| ing[:id] = idx + 1 }
    
    {
      ingredients: ingredients,
      confidence: calculate_overall_confidence,
      version: VERSION,
      parsed_at: Time.current
    }
  end
  
  private
  
  def combine_recipe_text
    steps_text = recipe.recipe_steps.map(&:instruction).join(' ')
    title_text = recipe.title || ''
    description_text = recipe.description || ''
    
    "#{title_text} #{description_text} #{steps_text}".downcase
  end
  
  def find_ingredient_in_text(text, search_term, dict_ingredient)
    results = []
    search_term_lower = search_term.downcase
    
    # Enhanced pattern to capture more context for French patterns
    # Look for the ingredient with extended context before and after
    text.scan(/(.{0,100})#{Regexp.escape(search_term_lower)}(.{0,50})/i) do
      before_context = $1
      after_context = $2
      position = $~.offset(0)[0]
      
      # Extract quantity and unit with improved French handling
      quantity_info = extract_quantity_and_unit_french(before_context, search_term_lower)
      
      # Calculate confidence
      confidence = calculate_confidence(before_context, after_context, quantity_info)
      
      if confidence > 0.3 # Threshold
        @confidence_scores << confidence
        
        results << {
          name: dict_ingredient.name,
          display_name: search_term,
          quantity: quantity_info[:quantity],
          unit: quantity_info[:unit],
          raw_text: "#{before_context.last(30)}#{search_term}#{after_context.first(30)}".strip,
          position: position,
          confidence: confidence,
          category: dict_ingredient.category
        }
      end
    end
    
    results
  end
  
  def extract_quantity_and_unit_french(before_text, ingredient_name)
    return { quantity: nil, unit: nil } if before_text.blank?
    
    # Clean the text
    text = before_text.strip.downcase
    
    # French patterns to look for:
    # "80 g de beurre" -> before_text = "80 g de", ingredient = "beurre"
    # "4 œufs" -> before_text = "4 ", ingredient = "œufs"
    # "150g de fromage" -> before_text = "150g de", ingredient = "fromage"
    
    quantity = nil
    unit = nil
    unit_found = nil
    
    # Pattern 1: Look for "quantity + unit + preposition" at the end
    # Example: "faire fondre 80 g de" -> should match "80 g de"
    french_pattern = /(\d+(?:[,\.]\d+)?)\s*([a-zA-Zàâäéèêëïîôùûüÿ\.]+)?\s*(?:de|d'|du|des)?\s*$/
    
    if match = text.match(french_pattern)
      quantity = normalize_quantity(match[1], :numbers)
      potential_unit = match[2]&.strip
      
      # Check if the potential unit is a real unit (as whole word)
      if potential_unit.present?
        UNITS.each do |normalized_unit, variations|
          variations.each do |variation|
            # Exact match for units to avoid false positives
            if potential_unit == variation
              unit = normalized_unit
              unit_found = potential_unit
              break
            end
          end
          break if unit
        end
      end
    end
    
    # Pattern 2: Look for just "quantity + preposition" (no unit)
    # Example: "ajouter 4 " -> should match "4"
    if quantity.nil?
      simple_pattern = /(\d+(?:[,\.]\d+)?)\s*(?:de|d'|du|des)?\s*$/
      if match = text.match(simple_pattern)
        quantity = normalize_quantity(match[1], :numbers)
      end
    end
    
    # Pattern 3: Look for quantity anywhere in the last part of before_text
    # This catches cases where there might be more words between quantity and ingredient
    if quantity.nil?
      # Look for the last number in the text
      numbers = text.scan(/(\d+(?:[,\.]\d+)?)/)
      if numbers.any?
        quantity = normalize_quantity(numbers.last[0], :numbers)
      end
    end
    
    # If we found a quantity but no unit, look for unit nearby
    if quantity.present? && unit.nil?
      UNITS.each do |normalized_unit, variations|
        variations.each do |variation|
          # Look for unit as a whole word or immediately after numbers
          # This prevents "l" from matching inside words like "ajouter"
          unit_pattern = if variation.length == 1
            # For single-letter units like "g", "l", require word boundary or number adjacency
            /\b#{Regexp.escape(variation)}\b|\d\s*#{Regexp.escape(variation)}/
          else
            # For multi-letter units, use word boundaries
            /\b#{Regexp.escape(variation)}\b/
          end
          
          if text.match(unit_pattern)
            unit = normalized_unit
            unit_found = variation
            break
          end
        end
        break if unit
      end
    end
    
    # Look for fraction patterns
    if quantity.nil?
      QUANTITY_PATTERNS.each do |type, pattern|
        if match = text.match(/#{pattern}\s*(?:de|d'|du|des)?\s*$/)
          quantity = normalize_quantity(match[1], type)
          break
        end
      end
    end
    
    { 
      quantity: quantity, 
      unit: unit, 
      unit_text: unit_found,
      debug_info: {
        text: text.last(50),
        found_quantity: quantity,
        found_unit: unit_found,
        patterns_tried: french_pattern.inspect
      }
    }
  end
  
  def normalize_quantity(value, type)
    case type
    when :numbers
      value.gsub(',', '.')
    when :fractions
      case value
      when '½', '1/2' then '0.5'
      when '⅓', '1/3' then '0.33'
      when '¼', '1/4' then '0.25'
      when '¾', '3/4' then '0.75'
      when '⅔', '2/3' then '0.67'
      else value
      end
    when :words
      word_to_number(value)
    else
      value
    end
  end
  
  def word_to_number(word)
    numbers = {
      'un' => '1', 'une' => '1', 'deux' => '2', 'trois' => '3',
      'quatre' => '4', 'cinq' => '5', 'six' => '6', 'sept' => '7',
      'huit' => '8', 'neuf' => '9', 'dix' => '10', 'onze' => '11',
      'douze' => '12', 'quinze' => '15', 'vingt' => '20',
      'trente' => '30', 'quarante' => '40', 'cinquante' => '50',
      'cent' => '100', 'quelques' => '3-4', 'plusieurs' => '3+'
    }
    numbers[word] || word
  end
  
  def calculate_confidence(before, after, quantity_info)
    score = 0.5 # Base score
    
    # Boost if quantity found
    score += 0.3 if quantity_info[:quantity].present?
    
    # Boost if unit found
    score += 0.2 if quantity_info[:unit].present?
    
    # Boost for common French cooking patterns
    score += 0.1 if before =~ /ajoute[rz]?|mettre|verse[rz]?|incorpore[rz]?|faire fondre/
    score += 0.1 if before =~ /avec|de|d'|du|des/
    
    # Reduce for unlikely contexts
    score -= 0.3 if after =~ /ne pas|sans|retirer|enlever/
    
    # Boost if we found both quantity and unit in a good pattern
    score += 0.1 if quantity_info[:quantity].present? && quantity_info[:unit].present?
    
    # Penalize unlikely unit/ingredient combinations
    if quantity_info[:unit].present?
      score -= 0.4 if unlikely_unit_combination?(quantity_info[:unit], before + after)
    end
    
    score.clamp(0, 1)
  end
  
  def unlikely_unit_combination?(unit, context)
    # Check for unlikely combinations like "liters of eggs"
    case unit
    when 'l', 'ml', 'cl', 'dl' # Liquid units
      # Unlikely for solid foods that are typically counted or measured by weight
      context.match?(/œufs?|oeufs?|pommes?|oranges?|citrons?|tomates?/i)
    when 'g', 'kg' # Weight units  
      # Generally fine for most ingredients
      false
    else
      false
    end
  end
  
  def calculate_overall_confidence
    return 0 if @confidence_scores.empty?
    
    @confidence_scores.sum / @confidence_scores.size
  end
end
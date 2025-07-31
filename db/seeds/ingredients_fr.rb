# db/seeds/ingredients_fr.rb
puts "Seeding French ingredients..."

FRENCH_INGREDIENTS = {
  légumes: [
    { name: 'tomate', plural: 'tomates', gender: 'f' },
    { name: 'oignon', plural: 'oignons', gender: 'm' },
    { name: 'ail', plural: 'ails', gender: 'm', aliases: ['gousse d\'ail', 'gousses d\'ail'] },
    { name: 'carotte', plural: 'carottes', gender: 'f' },
    { name: 'pomme de terre', plural: 'pommes de terre', gender: 'f', aliases: ['patate', 'patates'] },
    { name: 'courgette', plural: 'courgettes', gender: 'f' },
    { name: 'aubergine', plural: 'aubergines', gender: 'f' },
    { name: 'poivron', plural: 'poivrons', gender: 'm' },
    { name: 'champignon', plural: 'champignons', gender: 'm' },
    { name: 'brocoli', plural: 'brocolis', gender: 'm' },
    { name: 'épinard', plural: 'épinards', gender: 'm' },
    { name: 'haricot vert', plural: 'haricots verts', gender: 'm' },
    { name: 'petit pois', plural: 'petits pois', gender: 'm' },
    { name: 'maïs', plural: 'maïs', gender: 'm' },
    { name: 'céleri', plural: 'céleris', gender: 'm' },
    { name: 'poireau', plural: 'poireaux', gender: 'm' },
    { name: 'navet', plural: 'navets', gender: 'm' },
    { name: 'chou', plural: 'choux', gender: 'm' },
    { name: 'concombre', plural: 'concombres', gender: 'm' },
    { name: 'radis', plural: 'radis', gender: 'm' },
    { name: 'betterave', plural: 'betteraves', gender: 'f' },
    { name: 'patate douce', plural: 'patates douces', gender: 'f' },
    { name: 'courge', plural: 'courges', gender: 'f' },
    { name: 'potiron', plural: 'potirons', gender: 'm' },
    { name: 'citrouille', plural: 'citrouilles', gender: 'f' }
  ],
  
  fruits: [
    { name: 'pomme', plural: 'pommes', gender: 'f' },
    { name: 'poire', plural: 'poires', gender: 'f' },
    { name: 'banane', plural: 'bananes', gender: 'f' },
    { name: 'orange', plural: 'oranges', gender: 'f' },
    { name: 'citron', plural: 'citrons', gender: 'm' },
    { name: 'fraise', plural: 'fraises', gender: 'f' },
    { name: 'cerise', plural: 'cerises', gender: 'f' },
    { name: 'pêche', plural: 'pêches', gender: 'f' },
    { name: 'abricot', plural: 'abricots', gender: 'm' },
    { name: 'prune', plural: 'prunes', gender: 'f' },
    { name: 'raisin', plural: 'raisins', gender: 'm' },
    { name: 'kiwi', plural: 'kiwis', gender: 'm' },
    { name: 'mangue', plural: 'mangues', gender: 'f' },
    { name: 'ananas', plural: 'ananas', gender: 'm' },
    { name: 'avocat', plural: 'avocats', gender: 'm' },
    { name: 'melon', plural: 'melons', gender: 'm' },
    { name: 'pastèque', plural: 'pastèques', gender: 'f' },
    { name: 'framboise', plural: 'framboises', gender: 'f' },
    { name: 'myrtille', plural: 'myrtilles', gender: 'f' },
    { name: 'mûre', plural: 'mûres', gender: 'f' }
  ],
  
  viandes: [
    { name: 'bœuf', plural: 'bœufs', gender: 'm', aliases: ['boeuf'] },
    { name: 'veau', plural: 'veaux', gender: 'm' },
    { name: 'porc', plural: 'porcs', gender: 'm' },
    { name: 'poulet', plural: 'poulets', gender: 'm' },
    { name: 'dinde', plural: 'dindes', gender: 'f' },
    { name: 'canard', plural: 'canards', gender: 'm' },
    { name: 'agneau', plural: 'agneaux', gender: 'm' },
    { name: 'lapin', plural: 'lapins', gender: 'm' },
    { name: 'saucisse', plural: 'saucisses', gender: 'f' },
    { name: 'jambon', plural: 'jambons', gender: 'm' },
    { name: 'lard', plural: 'lards', gender: 'm' },
    { name: 'bacon', plural: 'bacons', gender: 'm' },
    { name: 'pancetta', plural: 'pancettas', gender: 'f' },
    { name: 'chorizo', plural: 'chorizos', gender: 'm' },
    { name: 'steak', plural: 'steaks', gender: 'm' },
    { name: 'escalope', plural: 'escalopes', gender: 'f' },
    { name: 'côtelette', plural: 'côtelettes', gender: 'f' },
    { name: 'filet', plural: 'filets', gender: 'm' },
    { name: 'cuisse', plural: 'cuisses', gender: 'f' },
    { name: 'blanc', plural: 'blancs', gender: 'm', aliases: ['blanc de poulet', 'blancs de poulet'] },
    { name: 'magret', plural: 'magrets', gender: 'm' }
  ],
  
  poissons: [
    { name: 'saumon', plural: 'saumons', gender: 'm' },
    { name: 'thon', plural: 'thons', gender: 'm' },
    { name: 'cabillaud', plural: 'cabillauds', gender: 'm' },
    { name: 'bar', plural: 'bars', gender: 'm' },
    { name: 'dorade', plural: 'dorades', gender: 'f' },
    { name: 'merlu', plural: 'merlus', gender: 'm' },
    { name: 'sole', plural: 'soles', gender: 'f' },
    { name: 'truite', plural: 'truites', gender: 'f' },
    { name: 'sardine', plural: 'sardines', gender: 'f' },
    { name: 'anchois', plural: 'anchois', gender: 'm' },
    { name: 'maquereau', plural: 'maquereaux', gender: 'm' },
    { name: 'crevette', plural: 'crevettes', gender: 'f' },
    { name: 'moule', plural: 'moules', gender: 'f' },
    { name: 'huître', plural: 'huîtres', gender: 'f' },
    { name: 'coquille saint-jacques', plural: 'coquilles saint-jacques', gender: 'f' },
    { name: 'crabe', plural: 'crabes', gender: 'm' },
    { name: 'homard', plural: 'homards', gender: 'm' },
    { name: 'langouste', plural: 'langoustes', gender: 'f' },
    { name: 'calamar', plural: 'calamars', gender: 'm' },
    { name: 'poulpe', plural: 'poulpes', gender: 'm' }
  ],
  
  épices: [
    { name: 'sel', plural: 'sels', gender: 'm' },
    { name: 'poivre', plural: 'poivres', gender: 'm' },
    { name: 'paprika', plural: 'paprikas', gender: 'm' },
    { name: 'cumin', plural: 'cumins', gender: 'm' },
    { name: 'curry', plural: 'currys', gender: 'm' },
    { name: 'cannelle', plural: 'cannelles', gender: 'f' },
    { name: 'muscade', plural: 'muscades', gender: 'f', aliases: ['noix de muscade'] },
    { name: 'gingembre', plural: 'gingembres', gender: 'm' },
    { name: 'curcuma', plural: 'curcumas', gender: 'm' },
    { name: 'safran', plural: 'safrans', gender: 'm' },
    { name: 'piment', plural: 'piments', gender: 'm' },
    { name: 'cayenne', plural: 'cayennes', gender: 'f' },
    { name: 'coriandre', plural: 'coriandres', gender: 'f' },
    { name: 'cardamome', plural: 'cardamomes', gender: 'f' },
    { name: 'clou de girofle', plural: 'clous de girofle', gender: 'm' },
    { name: 'anis étoilé', plural: 'anis étoilés', gender: 'm' },
    { name: 'vanille', plural: 'vanilles', gender: 'f' }
  ],
  
  herbes_aromatiques: [
    { name: 'persil', plural: 'persils', gender: 'm' },
    { name: 'basilic', plural: 'basilics', gender: 'm' },
    { name: 'thym', plural: 'thyms', gender: 'm' },
    { name: 'romarin', plural: 'romarins', gender: 'm' },
    { name: 'origan', plural: 'origans', gender: 'm' },
    { name: 'menthe', plural: 'menthes', gender: 'f' },
    { name: 'coriandre fraîche', plural: 'coriandres fraîches', gender: 'f' },
    { name: 'ciboulette', plural: 'ciboulettes', gender: 'f' },
    { name: 'estragon', plural: 'estragons', gender: 'm' },
    { name: 'aneth', plural: 'aneths', gender: 'm' },
    { name: 'sauge', plural: 'sauges', gender: 'f' },
    { name: 'laurier', plural: 'lauriers', gender: 'm', aliases: ['feuille de laurier', 'feuilles de laurier'] },
    { name: 'marjolaine', plural: 'marjolaines', gender: 'f' }
  ],
  
  produits_laitiers: [
    { name: 'lait', plural: 'laits', gender: 'm' },
    { name: 'crème', plural: 'crèmes', gender: 'f', aliases: ['crème liquide'] },
    { name: 'beurre', plural: 'beurres', gender: 'm' },
    { name: 'fromage', plural: 'fromages', gender: 'm' },
    { name: 'yaourt', plural: 'yaourts', gender: 'm', aliases: ['yogourt', 'yogourt'] },
    { name: 'fromage blanc', plural: 'fromages blancs', gender: 'm' },
    { name: 'mozzarella', plural: 'mozzarellas', gender: 'f' },
    { name: 'parmesan', plural: 'parmesans', gender: 'm' },
    { name: 'gruyère', plural: 'gruyères', gender: 'm' },
    { name: 'emmental', plural: 'emmentals', gender: 'm' },
    { name: 'roquefort', plural: 'roqueforts', gender: 'm' },
    { name: 'chèvre', plural: 'chèvres', gender: 'm', aliases: ['fromage de chèvre'] },
    { name: 'ricotta', plural: 'ricottas', gender: 'f' },
    { name: 'mascarpone', plural: 'mascarpones', gender: 'm' },
    { name: 'crème fraîche', plural: 'crèmes fraîches', gender: 'f' }
  ],
  
  autres: [
    { name: 'eau', plural: 'eaux', gender: 'f' },
    { name: 'sucre', plural: 'sucres', gender: 'm' },
    { name: 'farine', plural: 'farines', gender: 'f' },
    { name: 'œuf', plural: 'œufs', gender: 'm', aliases: ['oeuf', 'oeufs'] },
    { name: 'huile', plural: 'huiles', gender: 'f', aliases: ['huile d\'olive', 'huile de tournesol'] },
    { name: 'vinaigre', plural: 'vinaigres', gender: 'm' },
    { name: 'miel', plural: 'miels', gender: 'm' },
    { name: 'levure', plural: 'levures', gender: 'f', aliases: ['levure chimique', 'levure de boulanger'] },
    { name: 'pâte feuilletée', plural: 'pâtes feuilletées', gender: 'f' },
    { name: 'pâte brisée', plural: 'pâtes brisées', gender: 'f' },
    { name: 'pain', plural: 'pains', gender: 'm' },
    { name: 'chapelure', plural: 'chapelures', gender: 'f' },
    { name: 'riz', plural: 'riz', gender: 'm' },
    { name: 'pâtes', plural: 'pâtes', gender: 'f' },
    { name: 'semoule', plural: 'semoules', gender: 'f' },
    { name: 'quinoa', plural: 'quinoas', gender: 'm' },
    { name: 'boulgour', plural: 'boulgours', gender: 'm' },
    { name: 'lentille', plural: 'lentilles', gender: 'f' },
    { name: 'haricot blanc', plural: 'haricots blancs', gender: 'm' },
    { name: 'haricot rouge', plural: 'haricots rouges', gender: 'm' },
    { name: 'pois chiche', plural: 'pois chiches', gender: 'm' }
  ]
}

# Create ingredients
ingredient_count = 0

FRENCH_INGREDIENTS.each do |category, ingredients|
  ingredients.each do |ingredient_data|
    ing = IngredientDictionary.find_or_create_by(name: ingredient_data[:name]) do |ingredient|
      ingredient.plural_form = ingredient_data[:plural]
      ingredient.category = category.to_s
      ingredient.gender = ingredient_data[:gender]
      ingredient.aliases = ingredient_data[:aliases] || []
      ingredient.approved = true
      ingredient_count += 1
    end
    
    # Update if already exists
    if ing.persisted? && ing.plural_form.blank?
      ing.update(
        plural_form: ingredient_data[:plural],
        gender: ingredient_data[:gender],
        aliases: ingredient_data[:aliases] || []
      )
    end
  end
end

puts "Created/updated #{ingredient_count} French ingredients in dictionary"
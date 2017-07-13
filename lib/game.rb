# Contains game logic

# Pokedex selection
# Option to just fill roster of 6

# Pokemon from pokedex will be given standard move set and random special



####Game logic###
# Game explained with puts
# Player starts with empty roster 
# Until Player has 6 pokemon in roster:
#   Player selects a pokedexPokemon, which are cloned into Player's roster
Game starts with introduction to enemy team (standard)



def Game
  attr_accessor :playerRoster, :enemyRoster

  @enemyRoster = []

  def initialize
  end

  def start
    intro
  end
  
  def intro
    puts 'Welcome to Poorly Designed Pokemon Remake (PDPR)!'
    puts 'I\'ve scraped Pokemon and their stats from a website and created a pokedex.'
    puts 'You\'ll battle \'Poorly Designed Boss\', who has the 6 best pokemon with perfect stats!'
    puts 'To battle him, you\'ll select 6 pokemon from the pokedex to add to your roster'
    puts 'Then you\'ll take turns attacking his pokemon with yours.'
    puts 'Unfortunately, \'Poorly Designed Boss\' has sabatoged your pokemon by giving them random attacks and imperfect stats!'
    puts 'Can you still defeat him, despite being at a disadvantage!?'
    puts 'Good luck, and have fun!'
  end
  
end

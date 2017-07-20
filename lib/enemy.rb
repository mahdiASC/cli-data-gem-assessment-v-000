require './basePlayer.rb'
class Enemy < BasePlayer
    def initialize(pokeGroup)
        @roster = pokeGroup
        @currentPokemon = @roster[0]
    end

    def switch
        #switches current pokemon (should be dead) for another valid pokemon
        @currentPokemon = @roster.select{|pokemon|pokemon.alive?}.sample
    end

    def attacks(oppPokemon, diff, move=nil)
        #determines how enemy AI attacks depending on difficulty
        if move
            dmg = @currentPokemon.attacks(oppPokemon, move)
        else
            if diff == "easy"
                move = @currentPokemon.usableMoves.sample
                dmg = @currentPokemon.attacks(oppPokemon, move)
            elsif diff == "hard"
                move = @currentPokemon.usableMoves.sort{|moveA,moveB| moveA.dmg<=>moveB.dmg}.last
                dmg = @currentPokemon.attacks(oppPokemon, move)
            end
        end
        [dmg, move]
    end
end

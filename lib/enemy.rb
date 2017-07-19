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
            @currentPokemon.attacks(oppPokemon, move)
        else
            if diff == "easy"
                @currentPokemon.attacks(oppPokemon, @currentPokemon.usableMoves.sample)
            elsif diff == "hard"
                @currentPokemon.attacks(oppPokemon, @currentPokemon.usableMoves.sort{|moveA,moveB| moveA.dmg<=>moveB.dmg}.last)
            end
        end
    end
end

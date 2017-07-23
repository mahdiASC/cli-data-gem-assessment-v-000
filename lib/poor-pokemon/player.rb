require './basePlayer.rb'
class Player < BasePlayer
    def initialize
        @roster = []
    end

    def add(pokemon)
        @roster.push(pokemon)
    end

    def valids
        #returns array of living pokemon
        @roster.select{|pokemon|pokemon.alive?}
    end
end

require './move.rb'

class Moveset    
    def initialize(player)
        player.is_a?(Player) ? addPlayerMoveset(player) : addEnemyMoveset(player)
    end

    #Creates a hash of all 4 moves for a Pokemon Object
    def addPlayerMoveset(player)
        player.moves.push(Move.new("Normal Attack",randAtt(45),"Normal",30))
        player.moves.push(Move.new("Big Normal Attack",randAtt(110),"Normal",10))
        player.moves.push(Move.new("Special Attack",randAtt(70),randType,20))
        player.moves.push(Move.new("Big Special Attack",randAtt(100),randType,5))
    end

    def addEnemyMoveset(enemy)
        enemy.moves.push(Move.new("Normal Attack",40,"Normal",30))
        enemy.moves.push(Move.new("Big Normal Attack",100,"Normal",10))
        enemy.moves.push(Move.new("Special Attack",65,enemy.type1,20))
        enemy.moves.push(Move.new("Big Special Attack",90,enemy.type1,5))
    end

    def randType
        ["Bug","Dragon","Ice","Fighting","Fire","Flying","Grass","Ghost","Ground","Electric","Normal","Poison","Psychic","Rock","Water"].sample
    end

    def randAtt(num)
        var = (num * 0.1).round
        rand(var)+num-var
    end
end

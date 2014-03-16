require File.dirname(__FILE__) + "/Walls/const_wall.rb"
require File.dirname(__FILE__) + "/Walls/wall.rb"
require File.dirname(__FILE__) + "/Bonus/bonus_power.rb"
require File.dirname(__FILE__) + "/Bonus/bonus_bomb.rb"
require File.dirname(__FILE__) + "/pair.rb"
require File.dirname(__FILE__) + "/Bomb/bomb_explosion.rb"
require File.dirname(__FILE__) + "/../level.rb"

class GameLevel < Level
  def initialize()
    super()

    @boardExplosion = Array.new(@Width)

    for x in 0 .. @Width - 1
      @boardExplosion[x] = Array.new(@Height)

      for y in 0 .. @Height - 1
        @boardExplosion[x][y] = Array.new
      end
    end

    @bombs = Array.new

    @players = Hash.new
  end

  def addBomb(x,y, obj)
    @bombs.push(obj)
    @board[x][y] = obj
  end

  def getBombs
    return @bombs
  end

  def addPlayer(id, player)
    return false if @players.length == @MaxPlayer

    @players.merge! id => player
    return true
  end

  def getPlayer(id)
    return @players[id]
  end

  def getAllPlayers
    return @players
  end

  def killPlayerID(id)
    @players[id] = nil
  end

  def killPlayer(x, y)
    @players.each_value{ |p|
      if p != nil
        if p.getX == x && p.getY == y
          @players[p.getID] = nil
        end
      end
    }
  end

  def gameEnd?
    i = 0

    @players.each_value{ |p|
      if p != nil
        i+=1
      end
    }

    return i <= 1 ? true : false

  end

  def destroyField(x, y)
    if @board[x][y].class != ConstWall
      if @board[x][y].class == Wall
        if (val = rand(100)) < 75
          if val % 2 == 0
            @board[x][y] = BonusPower.new
          else
            @board[x][y] = BonusBomb.new
          end
        else
          @board[x][y] = nil
        end

        return true
      else
        @board[x][y] = nil
      end
    end


    return @board[x][y] == nil
  end


  def setExplosion(val, x, y, up, down, left, right)
    @boardExplosion[x][y].push( BombExplosion.new(val,0,5,false) )

    for i in 1 .. up
      if y - i >= 0
        @boardExplosion[x][y-i].push( BombExplosion.new(val,i,8,i == up) )
      end
    end

    for i in 1 .. down
      if y + i < getHeight
        @boardExplosion[x][y+i].push( BombExplosion.new(val,i,2, i == down) )
      end
    end

    for i in 1 .. left
      if x - i >= 0
        @boardExplosion[x-i][y].push( BombExplosion.new(val,i,4, i == left) )
      end
    end

    for i in 1 .. right
      if x + i < getWidth
        @boardExplosion[x+i][y].push( BombExplosion.new(val,i,6, i == right) )
      end
    end
  end

  def clearExplosion(val, x,y, up, down, left, right)
    @boardExplosion[x][y].delete_if{|el| el.getID == val}

    for i in 1 .. up
      if y - i >= 0
        @boardExplosion[x][y-i].delete_if{|el| el.getID == val}
      end
    end

    for i in 1 .. down
      if y + i < getHeight
        @boardExplosion[x][y+i].delete_if{|el| el.getID == val}
      end
    end

    for i in 1 .. left
      if x - i >= 0
        @boardExplosion[x-i][y].delete_if{|el| el.getID == val}
      end
    end

    for i in 1 .. right
      if x + i < getWidth
        @boardExplosion[x+i][y].delete_if{|el| el.getID == val}
      end
    end
  end

  def getExplosion(x,y)
    return @boardExplosion[x][y]
  end


  def isAnyExplosion?
    for x in 0 .. @Width - 1
      for y in 0 .. @Height - 1
        return true if @boardExplosion[x][y].length != 0
      end
    end

    return false
  end
end
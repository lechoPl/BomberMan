require File.dirname(__FILE__) + "/../../Model/Game/pair"

class User
    def initialize(x,y, board)
      @Board = board

      @x = x < @Board.getWidth ? x : @Board.getWidth - 1
      @y = y < @Board.getHeight ? y : @Board.getHeight - 1
    end

    def getX
      @x
    end

    def getY
      @y
    end

    def move?(x,y)
      @Board.getPositionAll.each { |pair|
        return false if (pair.getX == x && pair.getY == y)
        return false if (pair.getX - 1 == x && pair.getY == y)
        return false if (pair.getX == x && pair.getY - 1 == y)
        return false if (pair.getX + 1 == x && pair.getY == y)
        return false if (pair.getX == x && pair.getY + 1 == y)
      }

      return true
    end

    # poruszanie graczem
    def move_UP
      if @y != 0
        @y -= 1
        @y += 1 if !self.move?(@x,@y)
      end
    end

    def move_Down
      if @y != @Board.getHeight - 1
        @y += 1
        @y -= 1 if !self.move?(@x,@y)
      end
    end

    def move_Right
      if @x != @Board.getWidth - 1
        @x += 1
        @x -= 1 if !self.move?(@x,@y)
      end
    end

    def move_Left
      if @x != 0
        @x -= 1
        @x += 1 if !self.move?(@x,@y)
      end
    end
end
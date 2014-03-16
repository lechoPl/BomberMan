class Level
  def initialize
    @Width = 15
    @Height = 12

    @board = Array.new(@Width)

    for x in 0 .. @Width - 1
      @board[x] = Array.new(@Height)

      for y in 0 .. @Height - 1
        @board[x][y] = nil
      end
    end

    @MaxPlayer = 4
    @playerPosition = Array.new(@MaxPlayer)
    @playerPosition[0] = Pair.new(0,0)
    @playerPosition[1] = Pair.new(@Width-1, @Height-1)
    @playerPosition[2] = Pair.new(@Width-1,0)
    @playerPosition[3] = Pair.new(0, @Height-1)

  end

  def getWidth
    @Width
  end

  def getHeight
    @Height
  end

  def getField(x,y)
    return @board[x][y]
  end

  def setField(x, y, obj)
    @board[x][y] = obj
  end

  def getPosition(i)
    return @playerPosition[i]
  end

  def getPositionAll
    return @playerPosition
  end

  def save
    return Marshal.dump(@board)
  end

  def load(marshal_dump)
    @board = Marshal.load(marshal_dump)
  end
end
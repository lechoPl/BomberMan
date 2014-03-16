require File.dirname(__FILE__) + "/Bomb/bomb.rb"

class Player
  def initialize(x,y, id, board, skinID)
    @name = id

    @ID = id
    @Board = board

    @x = x < @Board.getWidth ? x : @Board.getWidth - 1
    @y = y < @Board.getHeight ? y : @Board.getHeight - 1

    @power = 1
    @numberOfBombs = 1

    @direction = 3

    @current_frame = -1

    @skinID = skinID
  end

  def setName(val)
    @name = val
  end

  def getName
    return @name
  end

  def getSkinID
    return @skinID
  end

  def setSkinID(val)
    @skinID = val
  end

  def getFrame
    return @current_frame
  end

  def setFrame(val)
    @current_frame = val
  end

  def getX
    @x
  end

  def getY
    @y
  end

  def getID
    @ID
  end

  def getDirection
    return @direction
  end

  def move?(x,y)
    returnVal = false

    if @Board.getField(x, y) == nil || @Board.getField(x, y).kind_of?(Bonus)
      returnVal = true;
    end

    return returnVal
  end

  def getBonus(x,y)
    if @Board.getField(x, y).class == BonusPower
        self.addPower(@Board.getField(x, y).getVal)
        @Board.setField(x,y, nil)
    elsif @Board.getField(x, y).class == BonusBomb
        self.addBomb(@Board.getField(x, y).getVal)
        @Board.setField(x,y, nil)
    end
  end

  # poruszanie graczem
  def move_UP
    if @y != 0
      @y -= 1
      @y += 1 if !self.move?(@x,@y)
    end

    self.getBonus(@x,@y)

    @direction = 2
  end

  def move_Down
    if @y != @Board.getHeight - 1
      @y += 1
      @y -= 1 if !self.move?(@x,@y)
    end

    self.getBonus(@x,@y)

    @direction = 1
  end

  def move_Right
    if @x != @Board.getWidth - 1
      @x += 1
      @x -= 1 if !self.move?(@x,@y)
    end

    self.getBonus(@x,@y)

    @direction = 3
  end

  def move_Left
    if @x != 0
      @x -= 1
      @x += 1 if !self.move?(@x,@y)
    end

    self.getBonus(@x,@y)

    @direction = 0
  end

  def addPower(add_val)
    @power += add_val
  end

  def setBomb
    if @Board.getField(@x,@y) == nil && @numberOfBombs > 0
      @numberOfBombs -= 1
      @Board.addBomb(@x, @y, Bomb.new(@x,@y, @power,@Board, self))
    end
  end

  def addBomb(val)
    @numberOfBombs += val
  end
end
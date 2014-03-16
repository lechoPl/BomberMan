class PlayerControler
  def initialize(level, id)
    @Level = level
    @ID = id

    @lock = Mutex.new
    @isLive = true

    @move = false
    @pressTime = Time.new()

    @p = @Level.getPlayer(@ID)
  end

  def isLive?
    return @Level.getPlayer(@ID) != nil
  end

  def getX
    return @p.getX
  end

  def getY
    return @p.getY
  end

  def getPlayer
    return @p
  end
end
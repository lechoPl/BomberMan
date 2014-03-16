class BombExplosion
  def initialize(id, p, dir, last)
    @ID = id


    @val = p
    @top = false
    @top = true if @val == 0

    @Dir =  dir

    @Last = last
  end

  def getID
    return @ID
  end

  def getVal
    return @val
  end

  def setVal(val)
    @val = val

    @top = true if val == 0
  end

  def setTop(val)
    @top = false
  end

  def getTop
    return @top
  end

  def getLast
    return @Last
  end

  def getDir
    return @Dir
  end

end
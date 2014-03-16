class EditorUser
  def initialize(level, user)
    @Level = level
    @user = user
  end

  def move
    SDL::Key.scan

    if SDL::Key.press?(SDL::Key::LEFT)
      @user.move_Left
    elsif SDL::Key.press?(SDL::Key::RIGHT)
      @user.move_Right
    elsif SDL::Key.press?(SDL::Key::DOWN)
      @user.move_Down
    elsif SDL::Key.press?(SDL::Key::UP)
      @user.move_UP
    end
  end

  def setField
    SDL::Key.scan

    if SDL::Key.press?(SDL::Key::A)
      @Level.setField(@user.getX, @user.getY, ConstWall.new)
    elsif SDL::Key.press?(SDL::Key::S)
      @Level.setField(@user.getX, @user.getY, Wall.new)
    elsif SDL::Key.press?(SDL::Key::D)
      @Level.setField(@user.getX, @user.getY, nil)
    end
  end

  def getX
    return @user.getX
  end

  def getY
    return @user.getY
  end
end
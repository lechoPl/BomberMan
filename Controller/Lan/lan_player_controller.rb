class LanPlayerController
  def initialize(server_client, id)
    @Level = server_client.getLevel
    @ID = id

    @server = server_client

    @lock = Mutex.new
    @isLive = true

    @move = false
    @pressTime = Time.new()

    @p = @Level.getPlayer(@ID)
  end

  def setBomb
    @lock.synchronize{
      SDL::Key.scan

      @server.set_Bomb(@ID) if SDL::Key.press?(SDL::Key::SPACE)
    }
  end

  def move
    @lock.synchronize{
      retrunVal = 0

      SDL::Key.scan

      currentTime = Time.new

      if currentTime - @pressTime >= 0.5
        @pressTime = Time.new(0)
        @move = false
      end

      if(@move == false)
        if SDL::Key.press?(SDL::Key::LEFT)
          @server.move_LEFT(@ID)

          @move = true
          retrunVal = 4
        elsif SDL::Key.press?(SDL::Key::RIGHT)
          @server.move_RIGTH(@ID)

          @move = true
          retrunVal = 6
        elsif SDL::Key.press?(SDL::Key::DOWN)
          @server.move_DOWN(@ID)

          @move = true
          retrunVal = 2
        elsif SDL::Key.press?(SDL::Key::UP)
          @server.move_UP(@ID)

          @move = true
          retrunVal = 8
        end

        @pressTime = Time.new if @move == true
      end

      return retrunVal
    }
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
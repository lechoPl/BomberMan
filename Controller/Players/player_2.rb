require File.dirname(__FILE__) + "/player_controler.rb"

class Player_2 < PlayerControler
  def initialize(level, id)
    super(level, id)

    @skin = 2
  end

  def setBomb
    @lock.synchronize{
      @p = @Level.getPlayer(@ID)

      return if @p == nil

      SDL::Key.scan

      @p.setBomb if SDL::Key.press?(9)
    }
  end

  def move
    @lock.synchronize{
      retrunVal = 0

      SDL::Key.scan

      @p = @Level.getPlayer(@ID)

      return if @p == nil

      currentTime = Time.new

      if currentTime - @pressTime >= 0.5

        @pressTime = Time.new(0)
        @move = false
      end


      if(@move == false)

        if SDL::Key.press?(SDL::Key::A)
          @p.move_Left
          @move = true
          retrunVal = 4
        elsif SDL::Key.press?(SDL::Key::D)
          @p.move_Right
          @move = true
          retrunVal = 6
        elsif SDL::Key.press?(SDL::Key::S)
          @p.move_Down
          @move = true
          retrunVal = 2
        elsif SDL::Key.press?(SDL::Key::W)
          @p.move_UP
          @move = true
          retrunVal = 8
        end

        @pressTime = Time.new if @move == true
      end

      return retrunVal
    }
  end
end
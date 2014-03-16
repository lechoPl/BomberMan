require "sdl"
require File.dirname(__FILE__) + "/player_controler.rb"

class Player_1 < PlayerControler
  def initialize(level, id)
    super(level, id)

    @skin = 1
  end

  def setBomb
    @lock.synchronize{
      SDL::Key.scan

      @p.setBomb if SDL::Key.press?(305)#R ctrl
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
          @p.move_Left
          @move = true
          retrunVal = 4
        elsif SDL::Key.press?(SDL::Key::RIGHT)
          @p.move_Right
          @move = true
          retrunVal = 6
        elsif SDL::Key.press?(SDL::Key::DOWN)
          @p.move_Down
          @move = true
          retrunVal = 2
        elsif SDL::Key.press?(SDL::Key::UP)
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
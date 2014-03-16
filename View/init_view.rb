require "sdl"

class InitView
  def initialize
    @@FieldSize = 40

    @@Width = 800
    @@Height = 600

    SDL.init( SDL::INIT_VIDEO )
    @screen = SDL::Screen.open(800,600,16,SDL::SWSURFACE)


  end

  def getScreen
    return @screen
  end


  def showMenu
  end
end

#InitView.new
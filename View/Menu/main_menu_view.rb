require "sdl"

class MainMenuView
  def initialize(screen_)
    @screen = screen_
    #temp
    #SDL.init( SDL::INIT_VIDEO )
    #@screen = SDL::Screen.open(800,600,16,SDL::SWSURFACE)
    ###############################################

    $IndifferentColor = [0,255,0]

    @@Width = 800
    @@Height = 600

    @font = SDL::BMFont.open(File.dirname(__FILE__) + "./font/font.bmp",SDL::BMFont::TRANSPARENT)

    marker_img = SDL::Surface.load(File.dirname(__FILE__) + "./img/marker.png")
    marker_img.set_color_key( SDL::SRCCOLORKEY ,$IndifferentColor)
    @image_marker = marker_img.display_format

    @posiotionX = 500
    @posiotionY = 350
    @markerSize = 12

    @curretnrOptions = 0
    @Max = 3

    @menuElementsPosition = Array.new()
    @menuElementsPosition[0] = 0
    @menuElementsPosition[1] = 20
    @menuElementsPosition[2] = 40
    @menuElementsPosition[3] = 80

  end

  def setScreen(screen)
    @screen = screen
  end

  def drawMenu
    xPlus = @posiotionX + @markerSize + 1
    yPlus = @posiotionY


    @font.textout(@screen,"NEW GAME",xPlus, yPlus + @menuElementsPosition[0])
    @font.textout(@screen,"LAN",xPlus, yPlus + @menuElementsPosition[1])
    @font.textout(@screen,"LEVEL EDITOR",xPlus, yPlus + @menuElementsPosition[2])
    @font.textout(@screen,"EXIT",xPlus, yPlus + @menuElementsPosition[3])

    SDL::Surface.blit(@image_marker, 0, 0, 12, 12,@screen, @posiotionX, @posiotionY + @menuElementsPosition[@curretnrOptions])
  end

  def setCurretnrOptions(val)
    @curretnrOptions = val if val >= 0 && val <= @Max
  end

  def setPositionX(val)
    @posiotionX = val
  end

  def setPositionY(val)
    @posiotionY = val
  end

  def getNumberOfElements
    return @Max
  end
end
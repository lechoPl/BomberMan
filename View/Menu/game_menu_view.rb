require "sdl"

class GameMenuView
  def initialize(screen_)
    @screen = screen_

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
    @Max = 2

    @menuElementsPosition = Array.new()
    @menuElementsPosition[0] = 0
    @menuElementsPosition[1] = 20

  end

  def setScreen(screen)
    @screen = screen
  end

  def drawMenu
    @screen.fill_rect(@posiotionX-10, @posiotionY-10, 100, 60,[0,0,0])

    xPlus = @posiotionX + @markerSize + 1
    yPlus = @posiotionY


    @font.textout(@screen,"Continue",xPlus, yPlus + @menuElementsPosition[0])
    @font.textout(@screen,"Exit",xPlus, yPlus + @menuElementsPosition[1])

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
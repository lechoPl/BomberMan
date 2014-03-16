require "sdl"

class GetPalyerNameView
  def initialize(screen_)
    @screen = screen_

    @@Width = 800
    @@Height = 600

    @font = SDL::BMFont.open(File.dirname(__FILE__) + "/../Menu/font/font.bmp",SDL::BMFont::TRANSPARENT)

    @posiotionX = 300
    @posiotionY = 200

    @border = 10
  end

  def setScreen(screen)
    @screen = screen
  end

  def draw
    @screen.fill_rect(0, 0, @@Width, @@Height,[0,0,0])

    @font.textout(@screen,"Enter player name:",@posiotionX + @border, @posiotionY + @border)

    @font.textout(@screen,"Enter - OK, Esc - Cancel",@posiotionX + @border, @posiotionY + @border + 50)
  end

  def drwaPlayerName(str)
    @font.textout(@screen,str ,@posiotionX + @border, @posiotionY + @border + 20)
  end

  def setPositionX(val)
    @posiotionX = val
  end

  def setPositionY(val)
    @posiotionY = val
  end
end

class SelectTypeGameView
  def initialize(screen)
    @screen = screen

    $IndifferentColor = [0,255,0]

    @@Width = 800
    @@Height = 600

    @font = SDL::BMFont.open(File.dirname(__FILE__) + "/../Menu/font/font.bmp",SDL::BMFont::TRANSPARENT)

    marker_img = SDL::Surface.load(File.dirname(__FILE__) + "/../Menu/img/marker.png")
    marker_img.set_color_key( SDL::SRCCOLORKEY ,$IndifferentColor)
    @image_marker = marker_img.display_format

    @posiotionX = 300
    @posiotionY = 200
    @markerSize = 12

    @curretnrOptions = 0
    @Max = 2

    @menuElementsPosition = Array.new()
    @menuElementsPosition[0] = 0
    @menuElementsPosition[1] = 20
    @menuElementsPosition[2] = 60
  end

  def draw

    @screen.fill_rect(0, 0, @@Width, @@Height,[0,0,0])

    xPlus = @posiotionX + @markerSize + 1
    yPlus = @posiotionY


    @font.textout(@screen,"Host Game",xPlus, yPlus + @menuElementsPosition[0])
    @font.textout(@screen,"Connect",xPlus, yPlus + @menuElementsPosition[1])
    @font.textout(@screen,"Exit",xPlus, yPlus + @menuElementsPosition[2])

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
end

class GetIpView
  def initialize(screen)
    @screen = screen

    @@Width = 800
    @@Height = 600

    @font = SDL::BMFont.open(File.dirname(__FILE__) + "/../Menu/font/font.bmp",SDL::BMFont::TRANSPARENT)

    @posiotionX = 300
    @posiotionY = 200

    @border = 10
  end

  def draw
    @screen.fill_rect(0, 0, @@Width, @@Height,[0,0,0])

    @font.textout(@screen,"Enter IP:",@posiotionX + @border, @posiotionY + @border)

    @font.textout(@screen,"Enter - OK, Esc - Cancel",@posiotionX + @border, @posiotionY + @border + 50)
  end

  def drwaIP(str)
    @font.textout(@screen,str ,@posiotionX + @border, @posiotionY + @border + 20)
  end

  def setPositionX(val)
    @posiotionX = val
  end

  def setPositionY(val)
    @posiotionY = val
  end
end
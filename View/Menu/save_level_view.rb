require "sdl"

class SaveLevelView
  def initialize(screen_)
    @screen = screen_

    @@Width = 800
    @@Height = 600

    @font = SDL::BMFont.open(File.dirname(__FILE__) + "./font/font.bmp",SDL::BMFont::TRANSPARENT)

    @posiotionX = 400
    @posiotionY = 300

    @border = 10
  end

  def setScreen(screen)
    @screen = screen
  end

  def draw
    @screen.fill_rect(@posiotionX, @posiotionY, 200, 90,[0,0,0])

    @font.textout(@screen,"Enter name:",@posiotionX + @border, @posiotionY + @border)

    @font.textout(@screen,"Enter - Save, Esc - Cancel",@posiotionX + @border, @posiotionY + @border + 50)
  end

  def drwaFileName(str)
    @font.textout(@screen,str ,@posiotionX + @border, @posiotionY + @border + 20)
  end

  def setPositionX(val)
    @posiotionX = val
  end

  def setPositionY(val)
    @posiotionY = val
  end
end
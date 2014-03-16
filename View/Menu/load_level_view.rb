require "sdl"

class LoadLevelView
  def initialize(screen_)
    @screen = screen_

    @@Width = 800
    @@Height = 600

    @font = SDL::BMFont.open(File.dirname(__FILE__) + "./font/font.bmp",SDL::BMFont::TRANSPARENT)

    @posiotionX = 300
    @posiotionY = 200

    @border = 10

    @current = 0
  end

  def setScreen(screen)
    @screen = screen
  end

  def draw
    @screen.fill_rect(@posiotionX, @posiotionY, 200, 285,[0,0,0])

    @font.textout(@screen,"Select File:",@posiotionX + @border, @posiotionY + @border)

    @screen.fill_rect(@posiotionX + @border + 5, @posiotionY + @border + 20*(@current+1), 180, 15, [163,73,164])

    @font.textout(@screen,"Enter - Load, Esc - Cancel",@posiotionX + @border, @posiotionY + @border + 250)
  end

  def drwaFileNams(strArray, current, numberOfLevels)
    if current < 10
      @current = current

      for i in 0..10
        if i < numberOfLevels
          @font.textout(@screen, strArray[i] ,@posiotionX + @border+10, @posiotionY + @border + 20*(i+1))
        end
      end
    else
      @current = 9
      for i in (current - 9) .. (current+1)
        if i < numberOfLevels
          @font.textout(@screen, strArray[i] ,@posiotionX + @border+10, @posiotionY + @border + 20*(i- (current - 9)+1))
        end
      end
    end
  end

  def setPositionX(val)
    @posiotionX = val
  end

  def setPositionY(val)
    @posiotionY = val
  end
end
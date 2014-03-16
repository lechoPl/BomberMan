require "sdl"
require File.dirname(__FILE__) + "/../../../Model/level.rb"
require File.dirname(__FILE__) + "/../../../Model/Game/Walls/const_wall.rb"
require File.dirname(__FILE__) + "/../../../Model/Game/Walls/wall.rb"

class NOFPMenuView
  def initialize(screen)
    @screen = screen

    @@Width = 800
    @@Height = 600

    @font = SDL::BMFont.open(File.dirname(__FILE__) + "/../font/font.bmp",SDL::BMFont::TRANSPARENT)

    @posiotionX = 50
    @posiotionY = 50

    @border = 10

    @current = 0
  end

  def draw
    @screen.fill_rect(0, 0, @@Width, @@Height,[0,0,0])

    @font.textout(@screen,"Select number of players:",@posiotionX + @border, @posiotionY + @border)
  end

  def drawNumbers
    @screen.fill_rect(@posiotionX + @border +  (@current+1)*20, @posiotionY + @border+18,15,18,[163,73,164])

    for i in 1..3
      @font.textout(@screen,(i+1).to_s,@posiotionX + @border + 5 + i*20, @posiotionY + @border+20)
    end
  end

  def setCurrent(val)
    @current = val
  end
end

class PlayerSetingView
  def initialize(screen, numberOfPlayers, playersSkins)
    @screen = screen
    @playersSkins = playersSkins

    @@Width = 800
    @@Height = 600

    @font = SDL::BMFont.open(File.dirname(__FILE__) + "/../font/font.bmp",SDL::BMFont::TRANSPARENT)

    @posiotionX = 50
    @posiotionY = 120

    @border = 10

    @numberOfPlayers = numberOfPlayers
    @currentPlayer = 0
    @currentOption = 0

    $IndifferentColor = [255,0,255]

    skin = SDL::Surface.load(File.dirname(__FILE__) + "/../../Game/img/skin1.png")
    skin.set_color_key( SDL::SRCCOLORKEY ,$IndifferentColor)
    @skin1 = skin.display_format

    skin = SDL::Surface.load(File.dirname(__FILE__) + "/../../Game/img/skin2.png")
    skin.set_color_key( SDL::SRCCOLORKEY ,$IndifferentColor)
    @skin2 = skin.display_format

    skin = SDL::Surface.load(File.dirname(__FILE__) + "/../../Game/img/skin3.png")
    skin.set_color_key( SDL::SRCCOLORKEY ,$IndifferentColor)
    @skin3 = skin.display_format

    skin = SDL::Surface.load(File.dirname(__FILE__) + "/../../Game/img/skin4.png")
    skin.set_color_key( SDL::SRCCOLORKEY ,$IndifferentColor)
    @skin4 = skin.display_format
  end

  def setCurrentPlayer(val)
    @currentPlayer = val
  end

  def setCurretnOption(val)
    @currentOption = val
  end

  def draw
    for i in 0 .. @numberOfPlayers -1
      @font.textout(@screen,"Player " + (i+1).to_s ,@posiotionX + @border + 120*i, @posiotionY + @border)
      case @playersSkins[i]
        when 1
          SDL::Surface.blit(@skin1,40,0,40,40,@screen,@posiotionX + @border + 120*i,@posiotionY + @border + 25)
        when 2
          SDL::Surface.blit(@skin2,40,0,40,40,@screen,@posiotionX + @border + 120*i,@posiotionY + @border + 25)
        when 3
          SDL::Surface.blit(@skin3,40,0,40,40,@screen,@posiotionX + @border + 120*i,@posiotionY + @border + 25)
        when 4
          SDL::Surface.blit(@skin4,40,0,40,40,@screen,@posiotionX + @border + 120*i,@posiotionY + @border + 25)
      end
      @font.textout(@screen,"Change skin",@posiotionX + @border + 120*i, @posiotionY + @border + 80)
    end


  end

  def drawNext
    @font.textout(@screen,"Next",@posiotionX + @border, @posiotionY + @border  + 110)
  end

  def drawCurrentOption
    @screen.fill_rect(@posiotionX, @posiotionY,500,200,[0,0,0])

    if @currentOption == 0
      @screen.fill_rect(@posiotionX + @border +  @currentPlayer*120 - 5, @posiotionY + @border + 78, 80, 18,[163,73,164])
    else
      @screen.fill_rect(@posiotionX + @border - 5, @posiotionY + @border + 108, 40, 18,[163,73,164])
    end
  end
end

class SelectSkinView
  def initialize(screen)
    @screen = screen

    @@Width = 800
    @@Height = 600

    @font = SDL::BMFont.open(File.dirname(__FILE__) + "/../font/font.bmp",SDL::BMFont::TRANSPARENT)

    @posiotionX = 350
    @posiotionY = 230

    @border = 10

    @currentX = 0
    @currentY = 0

    $IndifferentColor = [255,0,255]

    skin = SDL::Surface.load(File.dirname(__FILE__) + "/../../Game/img/skin1.png")
    skin.set_color_key( SDL::SRCCOLORKEY ,$IndifferentColor)
    @skin1 = skin.display_format

    skin = SDL::Surface.load(File.dirname(__FILE__) + "/../../Game/img/skin2.png")
    skin.set_color_key( SDL::SRCCOLORKEY ,$IndifferentColor)
    @skin2 = skin.display_format

    skin = SDL::Surface.load(File.dirname(__FILE__) + "/../../Game/img/skin3.png")
    skin.set_color_key( SDL::SRCCOLORKEY ,$IndifferentColor)
    @skin3 = skin.display_format

    skin = SDL::Surface.load(File.dirname(__FILE__) + "/../../Game/img/skin4.png")
    skin.set_color_key( SDL::SRCCOLORKEY ,$IndifferentColor)
    @skin4 = skin.display_format
  end

  def setCurrentX(val)
    @currentX = val
  end

  def setCurretnY(val)
    @currentY = val
  end

  def draw
    SDL::Surface.blit(@skin1,40,0,40,40,@screen,@posiotionX + @border -1,@posiotionY + @border -1)
    SDL::Surface.blit(@skin2,40,0,40,40,@screen,@posiotionX + @border +1 + 40,@posiotionY + @border -1)
    SDL::Surface.blit(@skin3,40,0,40,40,@screen,@posiotionX + @border -1,@posiotionY + @border + 40 +1)
    SDL::Surface.blit(@skin4,40,0,40,40,@screen,@posiotionX + @border + 40 + 1,@posiotionY + @border + 40 + 1)
  end

  def drawCurrent
    @screen.fill_rect(@posiotionX, @posiotionY,100,100,[30,30,30])

    @screen.fill_rect(@posiotionX + @border +  @currentX*40, @posiotionY + @border +@currentY * 40, 40, 40,[163,73,164])
  end
end

class SelectLevelView
  def initialize(screen)
    @screen = screen

    @@Width = 800
    @@Height = 600

    @font = SDL::BMFont.open(File.dirname(__FILE__) + "/../font/font.bmp",SDL::BMFont::TRANSPARENT)

    @posiotionX = 50
    @posiotionY = 300

    @border = 10

    @current = 0

    @selectColor = [163,73,164]
  end

  def setCurrent(val)
    @current = val
  end

  def draw
    @screen.fill_rect(@posiotionX, @posiotionY, 200, 285,[0,0,0])

    @font.textout(@screen,"Select level:",@posiotionX + @border, @posiotionY + @border)

    if @current < 10
      @screen.fill_rect(@posiotionX + @border + 5, @posiotionY + @border + 20*(@current+1), 180, 15, @selectColor)
    else
      @screen.fill_rect(@posiotionX + @border + 5, @posiotionY + @border + 20*10, 180, 15, @selectColor)
    end

    @font.textout(@screen,"Enter - Start, Esc - Cancel",@posiotionX + @border, @posiotionY + @border + 250)
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

  def drawMiniLevel(lvlName)
    tempDump = File.read(File.dirname(__FILE__) + "/../../../Data/Levels/" + lvlName)
    tempLevel = Level.new()
    tempLevel.load(tempDump)

    eFieldColor = [140,144,140]
    cWallColor = [50,50,50]
    wallColor = [116,62,0]

    fieldSieze = 15

    pozX = 300
    pozY = 25

    @screen.fill_rect(@posiotionX + @border + pozX, @posiotionY + @border + pozY, tempLevel.getWidth*fieldSieze, tempLevel.getHeight*fieldSieze, [0,0,0])

    for y in 0 .. (tempLevel.getHeight) - 1
      for x in 0 .. (tempLevel.getWidth) - 1
        if tempLevel.getField(x,y) == nil
          @screen.fill_rect(@posiotionX + @border + pozX + fieldSieze*x + 1, @posiotionY + @border + pozY +fieldSieze*y + 1, fieldSieze - 1, fieldSieze - 1, eFieldColor)
        elsif tempLevel.getField(x,y).class == ConstWall
          @screen.fill_rect(@posiotionX + @border + pozX + fieldSieze*x + 1, @posiotionY + @border + pozY+ fieldSieze*y + 1, fieldSieze - 1, fieldSieze - 1, cWallColor)
        elsif tempLevel.getField(x,y).class == Wall
          @screen.fill_rect(@posiotionX + @border + pozX + fieldSieze*x + 1, @posiotionY + @border + pozY + fieldSieze*y + 1, fieldSieze - 1, fieldSieze - 1, wallColor)
        end
      end
    end
  end


end
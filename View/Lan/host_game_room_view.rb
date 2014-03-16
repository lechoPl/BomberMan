require "sdl"
require File.dirname(__FILE__) + "/../../Model/Game/pair.rb"
require File.dirname(__FILE__) + "/../../Model/level.rb"
require File.dirname(__FILE__) + "/../../Model/Game/Walls/const_wall.rb"
require File.dirname(__FILE__) + "/../../Model/Game/Walls/wall.rb"
require File.dirname(__FILE__) + "/../../Model/Game/player.rb"


class HostGameRoomView
  def initialize(screen, level)
    @screen = screen
    @level = level

    @@Width = 800
    @@Height = 600

    $IndifferentColor = [255,0,255]

    skin = SDL::Surface.load(File.dirname(__FILE__) + "/../Game/img/skin1.png")
    skin.set_color_key( SDL::SRCCOLORKEY ,$IndifferentColor)
    @skin1 = skin.display_format

    skin = SDL::Surface.load(File.dirname(__FILE__) + "/../Game/img/skin2.png")
    skin.set_color_key( SDL::SRCCOLORKEY ,$IndifferentColor)
    @skin2 = skin.display_format

    skin = SDL::Surface.load(File.dirname(__FILE__) + "/../Game/img/skin3.png")
    skin.set_color_key( SDL::SRCCOLORKEY ,$IndifferentColor)
    @skin3 = skin.display_format

    skin = SDL::Surface.load(File.dirname(__FILE__) + "/../Game/img/skin4.png")
    skin.set_color_key( SDL::SRCCOLORKEY ,$IndifferentColor)
    @skin4 = skin.display_format

    @font = SDL::BMFont.open(File.dirname(__FILE__) + "/../Menu/font/font.bmp",SDL::BMFont::TRANSPARENT)

    @border = 10

    @playerInfoWidth = 110
    @playerInfoHeight = 200

    @playerInfoPosition = Array.new(4)
    @playerInfoPosition[0] = Pair.new(@border, @border)
    @playerInfoPosition[1] = Pair.new(@@Width-@playerInfoWidth - @border, @@Height-@playerInfoHeight - @border)
    @playerInfoPosition[2] = Pair.new(@@Width-@playerInfoWidth - @border, @border)
    @playerInfoPosition[3] = Pair.new(@border, @@Height-@playerInfoHeight - @border)

    @levelViewPositio = Pair.new(400,200)

    @menuOptionPosition = Array.new(4)
    @menuOptionPosition[0] = 0
    @menuOptionPosition[1] = 18
    @menuOptionPosition[2] = 36
    @menuOptionPosition[3] = 60

    @currentOption = 0
    @selectedColor = [163,73,164]

    @miniLevelPozX = 250
    @miniLevelPozY = 200
  end

  def setCurrentOption(val)
    @currentOption = val
  end

  def setLevel(level)
    @level = level
  end

  def draw
    @screen.fill_rect(0, 0, @@Width, @@Height,[0,0,0])
  end

  def drawPlayerInfo
    @borderInfo = 20
    border = @borderInfo

    for i in 1 .. 4
      p = @level.getPlayer(i)

      pozX = @playerInfoPosition[i-1].getX
      pozY = @playerInfoPosition[i-1].getY

      bgColor = [20,20,20]

      @screen.fill_rect(pozX, pozY, @playerInfoWidth, @playerInfoHeight, bgColor)

      @font.textout(@screen,"Player: ",pozX + border, pozY + border)

      if( p == nil)
        @font.textout(@screen," <-- EMPTY -->",pozX + border, pozY + border + 18)
      else
        @font.textout(@screen, "\t" + p.getName.to_s ,pozX + border, pozY + border + 18)

        case p.getSkinID
          when 1
            SDL::Surface.blit(@skin1,40,0,40,40,@screen, pozX + border + 10, pozY + border + 40)
          when 2
            SDL::Surface.blit(@skin2,40,0,40,40,@screen, pozX + border + 10, pozY + border + 40)
          when 3
            SDL::Surface.blit(@skin3,40,0,40,40,@screen, pozX + border + 10, pozY + border + 40)
          when 4
            SDL::Surface.blit(@skin4,40,0,40,40,@screen, pozX + border + 10, pozY + border + 40)
        end

      end
    end
  end

  def drawMenu
    pozX = @playerInfoPosition[0].getX
    pozY = @playerInfoPosition[0].getY

    @screen.fill_rect(pozX + @borderInfo - 5, pozY + @borderInfo + 88 + @menuOptionPosition[@currentOption], 70, 18, @selectedColor)

    @font.textout(@screen, "Set skin" ,pozX + @borderInfo, pozY + @borderInfo + 90 + @menuOptionPosition[0])
    @font.textout(@screen, "Set level" ,pozX + @borderInfo, pozY + @borderInfo + 90 + @menuOptionPosition[1])
    @font.textout(@screen, "Start Game" ,pozX + @borderInfo, pozY + @borderInfo + 90 + @menuOptionPosition[2])
    @font.textout(@screen, "Exit" ,pozX + @borderInfo, pozY + @borderInfo + 90 + @menuOptionPosition[3])
  end

  def drawMiniLevel(level)
    tempLevel = level

    eFieldColor = [140,144,140]
    cWallColor = [50,50,50]
    wallColor = [116,62,0]

    fieldSieze = 15

    @screen.fill_rect(@miniLevelPozX + @border , @miniLevelPozY + @border , tempLevel.getWidth*fieldSieze, tempLevel.getHeight*fieldSieze, [0,0,0])

    for y in 0 .. (tempLevel.getHeight) - 1
      for x in 0 .. (tempLevel.getWidth) - 1
        if tempLevel.getField(x,y) == nil
          @screen.fill_rect(@miniLevelPozX + @border + fieldSieze*x + 1, @miniLevelPozY + @border +fieldSieze*y + 1, fieldSieze - 1, fieldSieze - 1, eFieldColor)
        elsif tempLevel.getField(x,y).class == ConstWall
          @screen.fill_rect(@miniLevelPozX + @border + fieldSieze*x + 1, @miniLevelPozY + @border + fieldSieze*y + 1, fieldSieze - 1, fieldSieze - 1, cWallColor)
        elsif tempLevel.getField(x,y).class == Wall
          @screen.fill_rect(@miniLevelPozX + @border + fieldSieze*x + 1, @miniLevelPozY + @border + fieldSieze*y + 1, fieldSieze - 1, fieldSieze - 1, wallColor)
        end
      end
    end
  end

  def drawIP(ip)
    @font.textout(@screen,"Server IP: " + ip.to_s ,300, 100)
  end
end


class SelectSkinView
  def initialize(screen)
    @screen = screen

    @@Width = 800
    @@Height = 600

    $IndifferentColor = [255,0,255]

    skin = SDL::Surface.load(File.dirname(__FILE__) + "/../Game/img/skin1.png")
    skin.set_color_key( SDL::SRCCOLORKEY ,$IndifferentColor)
    @skin1 = skin.display_format

    skin = SDL::Surface.load(File.dirname(__FILE__) + "/../Game/img/skin2.png")
    skin.set_color_key( SDL::SRCCOLORKEY ,$IndifferentColor)
    @skin2 = skin.display_format

    skin = SDL::Surface.load(File.dirname(__FILE__) + "/../Game/img/skin3.png")
    skin.set_color_key( SDL::SRCCOLORKEY ,$IndifferentColor)
    @skin3 = skin.display_format

    skin = SDL::Surface.load(File.dirname(__FILE__) + "/../Game/img/skin4.png")
    skin.set_color_key( SDL::SRCCOLORKEY ,$IndifferentColor)
    @skin4 = skin.display_format

    @font = SDL::BMFont.open(File.dirname(__FILE__) + "/../Menu/font/font.bmp",SDL::BMFont::TRANSPARENT)

    @posiotionX = 350
    @posiotionY = 230

    @border = 10

    @currentX = 0
    @currentY = 0
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

class SelectLevelHostView
  def initialize(screen)
    @screen = screen

    @@Width = 800
    @@Height = 600

    @font = SDL::BMFont.open(File.dirname(__FILE__) + "/../Menu/font/font.bmp",SDL::BMFont::TRANSPARENT)

    @posiotionX = 150
    @posiotionY = 150

    @border = 10

    @current = 0

    @selectColor = [163,73,164]
  end

  def setCurrent(val)
    @current = val
  end

  def draw
    @screen.fill_rect(@posiotionX, @posiotionY, 500, 285,[0,0,0])

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
    tempDump = File.read(File.dirname(__FILE__) + "/../../Data/Levels/" + lvlName)
    tempLevel = Level.new()
    tempLevel.load(tempDump)

    eFieldColor = [140,144,140]
    cWallColor = [50,50,50]
    wallColor = [116,62,0]

    fieldSieze = 15

    pozX = 200
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
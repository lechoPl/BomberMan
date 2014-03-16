require "sdl"
require File.dirname(__FILE__) + "/../../Model/Game/Bomb/bomb_explosion.rb"
require File.dirname(__FILE__) + "/../../Model/Game/Bonus/bonus.rb"
require File.dirname(__FILE__) + "/../../Model/Game/Bonus/bonus_bomb.rb"
require File.dirname(__FILE__) + "/../../Model/Game/Bonus/bonus_power.rb"


class GameView
  def initialize(screen)
    @level = nil

    @@FieldSize = 40

    @@Width = 800
    @@Height = 600

    @screen = screen

    $IndifferentColor = [255,0,255]

    @font = SDL::BMFont.open(File.dirname(__FILE__) + "/../Menu/font/font.bmp",SDL::BMFont::TRANSPARENT)

    skin_img = SDL::Surface.load(File.dirname(__FILE__) + "/img/skin1.png")
    skin_img.set_color_key( SDL::SRCCOLORKEY ,$IndifferentColor)
    @skin1 = skin_img.display_format

    skin_img = SDL::Surface.load(File.dirname(__FILE__) + "/img/skin2.png")
    skin_img.set_color_key( SDL::SRCCOLORKEY ,$IndifferentColor)
    @skin2 = skin_img.display_format

    skin_img = SDL::Surface.load(File.dirname(__FILE__) + "/img/skin3.png")
    skin_img.set_color_key( SDL::SRCCOLORKEY ,$IndifferentColor)
    @skin3 = skin_img.display_format

    skin_img = SDL::Surface.load(File.dirname(__FILE__) + "/img/skin4.png")
    skin_img.set_color_key( SDL::SRCCOLORKEY ,$IndifferentColor)
    @skin4 = skin_img.display_format

    field_img = SDL::Surface.load(File.dirname(__FILE__) + "/img/EmptyField.png")
    @image_ef = field_img.display_format

    field_CW = SDL::Surface.load(File.dirname(__FILE__) + "/img/ConstWall.png")
    @image_cw = field_CW.display_format

    field_W = SDL::Surface.load(File.dirname(__FILE__) + "/img/Wall.png")
    @image_w = field_W.display_format

    bomb_img = SDL::Surface.load( File.dirname(__FILE__) + "/img/Bomb.png")
    bomb_img.set_color_key( SDL::SRCCOLORKEY ,$IndifferentColor)
    @image_b = bomb_img.display_format

    exp_img = SDL::Surface.load( File.dirname(__FILE__) + "/img/Exp.png")
    exp_img.set_color_key( SDL::SRCCOLORKEY ,$IndifferentColor)
    @image_exp = exp_img.display_format

    bp_img = SDL::Surface.load( File.dirname(__FILE__) + "/img/BonusPower.png")
    bp_img.set_color_key( SDL::SRCCOLORKEY ,$IndifferentColor)
    @image_bp = bp_img.display_format

    bb_img = SDL::Surface.load( File.dirname(__FILE__) + "/img/BonusBomb.png")
    bb_img.set_color_key( SDL::SRCCOLORKEY ,$IndifferentColor)
    @image_bb = bb_img.display_format

    @lock = Mutex.new

    @positionX = 0
    @positionY = 0
  end

  def setLevel(level)
    @level = level

    @positionX = (@@Width - @@FieldSize * @level.getWidth)/2
    @positionY = (@@Height - @@FieldSize * @level.getHeight)/2
  end

  def drawBoard
    return if @level == nil



    (0 .. @level.getHeight-1).each do |y|
      (0 .. @level.getWidth-1).each do |x|
        if @level.getField(x,y) == nil || @level.getField(x,y).class == Player || @level.getField(x,y).kind_of?(Bonus)
          SDL::Surface.blit(@image_ef, 0, 0,@@FieldSize,@@FieldSize,@screen,@positionX + x*@@FieldSize, @positionY + y*@@FieldSize)

          if @level.getField(x, y).class == BonusPower
            SDL::Surface.blit(@image_bp, 0, 0,@@FieldSize,@@FieldSize,@screen,@positionX + x*@@FieldSize, @positionY + y*@@FieldSize)
          elsif @level.getField(x, y).class == BonusBomb
            SDL::Surface.blit(@image_bb, 0, 0,@@FieldSize,@@FieldSize,@screen,@positionX + x*@@FieldSize, @positionY + y*@@FieldSize)
          end

        elsif @level.getField(x,y).class == Bomb
          SDL::Surface.blit(@image_ef, 0, 0,@@FieldSize,@@FieldSize,@screen,@positionX + x*@@FieldSize,@positionY + y*@@FieldSize)
          SDL::Surface.blit(@image_b, 0, 0,@@FieldSize,@@FieldSize,@screen,@positionX + x*@@FieldSize,@positionY + y*@@FieldSize)
        elsif @level.getField(x,y).class == ConstWall
          SDL::Surface.blit(@image_cw, 0, 0,@@FieldSize,@@FieldSize,@screen,@positionX + x*@@FieldSize,@positionY + y*@@FieldSize)
        elsif @level.getField(x,y).class == Wall
          SDL::Surface.blit(@image_w, 0, 0,@@FieldSize,@@FieldSize,@screen,@positionX + x*@@FieldSize,@positionY + y*@@FieldSize)
        end
      end
    end
  end

  def startAnimation(player, x1, y1)
    for i in 0 .. (7)
      player.setFrame(i)
      sleep 0.05
    end

    player.setFrame(-1)
  end

  def drawPlayers
    return if @level == nil

    @level.getAllPlayers.each_value { |p|
      if p != nil
          case p.getSkinID
            when 1
              temp = @skin1
            when 2
              temp = @skin2
            when 3
              temp = @skin3
            when 4
              temp = @skin4
          end

          if p.getFrame == -1
            SDL::Surface.blit(temp,p.getDirection*40,0,40,40,@screen,@positionX + p.getX * 40,@positionY + p.getY * 40)
          else
            case p.getDirection
              when 0
                SDL::Surface.blit(temp, 0*40, p.getFrame*40, 40, 40, @screen, @positionX + (p.getX+1)*40-(6*p.getFrame), @positionY + p.getY*40)
              when 1
                SDL::Surface.blit(temp, 1*40,p.getFrame*40,40,40,@screen,@positionX +  p.getX*40, @positionY + (p.getY-1)*40 + (5*p.getFrame))
              when 2
                SDL::Surface.blit(temp, 2*40,p.getFrame*40,40,40,@screen,@positionX +  p.getX*40, @positionY + (p.getY+1)*40 - (5*p.getFrame))
              when 3
                SDL::Surface.blit(temp, 3*40,p.getFrame*40,40,40,@screen,@positionX +  (p.getX-1)*40+(6*p.getFrame),@positionY +  p.getY*40)
            end
          end
      end
    }
  end

  def flip
    @screen.flip
  end

  def drawExplosion
    return if @level == nil

    (0 .. @level.getHeight-1).each do |y|
      (0 .. @level.getWidth-1).each do |x|
        if @level.getExplosion(x,y) != nil

          @level.getExplosion(x,y).each{ |exp|
            if exp.getVal == 0
              @top = 1
              if exp.getTop
                @top = 0

                if !exp.getLast
                  exp.setTop(false)
                end
              end

              case exp.getDir
                when 5 #center
                  SDL::Surface.blit(@image_exp, 0*40,@top *40,40,40,@screen,@positionX +  x*40, @positionY + y*40)
                when 8 #up
                  SDL::Surface.blit(@image_exp, 1*40,@top *40,40,40,@screen,@positionX +  x*40, @positionY + y*40)
                when 2 #down
                  SDL::Surface.blit(@image_exp, 2*40,@top *40,40,40,@screen,@positionX +  x*40, @positionY + y*40)
                when 6 #right
                  SDL::Surface.blit(@image_exp, 3*40,@top *40,40,40,@screen,@positionX +  x*40, @positionY + y*40)
                when 4 #left
                  SDL::Surface.blit(@image_exp, 4*40,@top *40,40,40,@screen,@positionX +  x*40, @positionY + y*40)
              end

            else
              exp.setVal(exp.getVal - 1)
            end
          }
        end
      end
    end

  end

  def drawWin
    return if !@level.gameEnd?

    pozX = 350
    pozY = 250
    border = 10

    player = 0

    @level.getAllPlayers.each_value { |p|
      if p != nil
        player = p
      end
    }

    @screen.fill_rect(pozX, pozY, 190, 60,[0,0,0])
    @font.textout(@screen,"Player " + player.getName.to_s + " WIN!",pozX + border + 30, pozY + border)
    @font.textout(@screen,"Press any ENTER to continue...",pozX + border, pozY + border + 20)
  end

end



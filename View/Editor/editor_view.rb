require "sdl"
require File.dirname(__FILE__) + "/../../Model/Editor/user.rb"

class EditorView
  def initialize(screen, level, user)
    @level = level

    @user = user

    @@FieldSize = 40

    @@Width = 800
    @@Height = 600

    @screen = screen

    $IndifferentColor = [0,255,0]

    field_img = SDL::Surface.load(File.dirname(__FILE__) + "/../Game/img/EmptyField.png")
    @image_ef = field_img.display_format

    field_CW = SDL::Surface.load(File.dirname(__FILE__) + "/../Game/img/ConstWall.png")
    @image_cw = field_CW.display_format

    field_W = SDL::Surface.load(File.dirname(__FILE__) + "/../Game/img/Wall.png")
    @image_w = field_W.display_format

    user_img = SDL::Surface.load(File.dirname(__FILE__) + "/img/UserImg.png")
    user_img.set_color_key( SDL::SRCCOLORKEY ,$IndifferentColor)
    @image_user = user_img.display_format

    const_img = SDL::Surface.load(File.dirname(__FILE__) + "/img/Const.png")
    const_img.set_color_key( SDL::SRCCOLORKEY ,$IndifferentColor)
    @image_const = const_img.display_format

    @positionX = (@@Width - @@FieldSize * @level.getWidth)/2
    @positionY = (@@Height - @@FieldSize * @level.getHeight)/2
  end

  def setLevel(level)
    @level = level

    @positionX = (@@Width - @@FieldSize * @level.getWidth)/2
    @positionY = (@@Height - @@FieldSize * @level.getHeight)/2
  end

  def const?(x,y)
    @level.getPositionAll.each { |pair|
      return true if (pair.getX == x && pair.getY == y)
      return true if (pair.getX - 1 == x && pair.getY == y)
      return true if (pair.getX == x && pair.getY - 1 == y)
      return true if (pair.getX + 1 == x && pair.getY == y)
      return true if (pair.getX == x && pair.getY + 1 == y)
    }

    return false
  end

  def drawBoard
    return if @level == nil

    (0 .. @level.getHeight-1).each do |y|
      (0 .. @level.getWidth-1).each do |x|
        if @level.getField(x,y) == nil
          SDL::Surface.blit(@image_ef, 0, 0,@@FieldSize,@@FieldSize,@screen,@positionX + x*@@FieldSize, @positionY + y*@@FieldSize)

        elsif @level.getField(x,y).class == ConstWall
          SDL::Surface.blit(@image_cw, 0, 0,@@FieldSize,@@FieldSize,@screen,@positionX + x*@@FieldSize,@positionY + y*@@FieldSize)

        elsif @level.getField(x,y).class == Wall
          SDL::Surface.blit(@image_w, 0, 0,@@FieldSize,@@FieldSize,@screen,@positionX + x*@@FieldSize,@positionY + y*@@FieldSize)
        end

        if const?(x,y)
          SDL::Surface.blit(@image_const, 0, 0,@@FieldSize,@@FieldSize,@screen,@positionX + x*@@FieldSize,@positionY + y*@@FieldSize)
        end
      end
    end
  end

  def drawUser
    x = @user.getX
    y = @user.getY

    SDL::Surface.blit(@image_user, 0, 0,@@FieldSize,@@FieldSize,@screen,@positionX + x*@@FieldSize, @positionY + y*@@FieldSize)
  end

  def flip
    @screen.flip
  end
end
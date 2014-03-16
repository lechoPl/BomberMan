require File.dirname(__FILE__) + "/../../../Model/Menu/model_menu.rb"
require File.dirname(__FILE__) + "/../../../View/Menu/NewGame/new_game_menu_all_view.rb"
require File.dirname(__FILE__) + "/../../../Model/Menu/select_levels.rb"

class NOFPMenuControler
  def initialize(screen)
    @screen = screen

    @numberOfPlayer = MenuModel.new(3)
    @view = NOFPMenuView.new(@screen)

    @end = false

    while !@end
      while event = SDL::Event.poll
        case event
          when SDL::Event::Quit
            exit
          when SDL::Event::KeyDown
            if event.sym == SDL::Key::ESCAPE
              @end = true
            end

            if event.sym == SDL::Key::LEFT
              @numberOfPlayer.nextUP
              @view.setCurrent(@numberOfPlayer.getCurrent)
            end

            if event.sym == SDL::Key::RIGHT
              @numberOfPlayer.nextDown
              @view.setCurrent(@numberOfPlayer.getCurrent)
            end

            if event.sym == SDL::Key::RETURN
              @end = true

              #wywowanie wyboru skinow graczy
              PlayerSetingControler.new(@screen, self, @numberOfPlayer.getCurrent+2)

            end
        end
      end

      #wyswietlanie
      self.draw

      @screen.flip

    end
  end

  def setEnd(val)
    @end = val
  end


  def draw
    @view.draw
    @view.drawNumbers
  end

end

class PlayerSetingControler
  def initialize(screen, previousMenu, numberOfPlayer)
    @screen = screen
    @NumberOfPlayer = numberOfPlayer

    @playerSkin = Array.new

    for i in 1 .. @NumberOfPlayer
      @playerSkin << i
    end

    @curetnPlayerMenu = MenuModel.new(@NumberOfPlayer)

    @curetnOptionMenu = MenuModel.new(2)

    @view = PlayerSetingView.new(@screen, numberOfPlayer, @playerSkin)

    @end = false

    while !@end
      while event = SDL::Event.poll
        case event
          when SDL::Event::Quit
            exit
          when SDL::Event::KeyDown
            if event.sym == SDL::Key::ESCAPE
              @end = true
              previousMenu.setEnd(false)
            end

            if event.sym == SDL::Key::LEFT && @curetnOptionMenu.getCurrent == 0
              @curetnPlayerMenu.nextUP
              @view.setCurrentPlayer(@curetnPlayerMenu.getCurrent)
            end

            if event.sym == SDL::Key::RIGHT && @curetnOptionMenu.getCurrent == 0
              @curetnPlayerMenu.nextDown
              @view.setCurrentPlayer(@curetnPlayerMenu.getCurrent)
            end



            if event.sym == SDL::Key::UP
              @curetnOptionMenu.nextUP
              @view.setCurretnOption(@curetnOptionMenu.getCurrent)
            end

            if event.sym == SDL::Key::DOWN
              @curetnOptionMenu.nextDown
              @view.setCurretnOption(@curetnOptionMenu.getCurrent)
            end

            if event.sym == SDL::Key::RETURN
              if @curetnOptionMenu.getCurrent == 0
                selectSkin = SelecSkin.new(@screen, @playerSkin[@curetnPlayerMenu.getCurrent])

                @playerSkin[@curetnPlayerMenu.getCurrent] = selectSkin.getSkinID

              else
                @end = true

                SelectLevel.new(@screen,self)
                #select level
              end
            end
        end

      #wyswietlanie
      previousMenu.draw

      self.draw

      @screen.flip

      end
    end
  end

  def draw
    @view.drawCurrentOption
    @view.draw
    @view.drawNext
  end

  def setEnd(val)
    @end = val
  end

  def getPlayersSkin
    return @playerSkin
  end
end

class SelecSkin
  def initialize(screen, skinID)
    @screen = screen

    @SkinIDFirst = skinID
    @skinID = skinID

    @curetnX = MenuModel.new(2)

    @curetnY = MenuModel.new(2)

    @view = SelectSkinView.new(@screen)

    case @skinID
      when 2
        @curetnX.nextDown
      when 3
        @curetnY.nextDown
      when 4
        @curetnX.nextDown
        @curetnY.nextDown
    end

    @view.setCurrentX(@curetnX.getCurrent)
    @view.setCurretnY(@curetnY.getCurrent)

    @end = false

    while !@end
      while event = SDL::Event.poll
        case event
          when SDL::Event::Quit
            exit
          when SDL::Event::KeyDown
            if event.sym == SDL::Key::ESCAPE
              @skinID = @SkinIDFirst
              @end = true
            end

            if event.sym == SDL::Key::LEFT
              @curetnX.nextUP
              @view.setCurrentX(@curetnX.getCurrent)

              self.setSkinID
            end

            if event.sym == SDL::Key::RIGHT
              @curetnX.nextDown
              @view.setCurrentX(@curetnX.getCurrent)

              self.setSkinID
            end
            if event.sym == SDL::Key::UP
              @curetnY.nextUP
              @view.setCurretnY(@curetnY.getCurrent)

              self.setSkinID
            end

            if event.sym == SDL::Key::DOWN
              @curetnY.nextDown
              @view.setCurretnY(@curetnY.getCurrent)

              self.setSkinID
            end

            if event.sym == SDL::Key::RETURN
              @end = true
            end
        end

        self.draw

        @screen.flip

      end
    end
  end

  def setSkinID
    if @curetnY.getCurrent == 0
      @skinID = 1 + @curetnX.getCurrent
    else
      @skinID = 3 + @curetnX.getCurrent
    end
  end

  def draw
    @view.drawCurrent
    @view.draw
  end

  def getSkinID
    @skinID
  end
end

class SelectLevel
  def initialize(screen, previousMenu)
    @screen = screen

    @levels = SelectLevels.new
    @menuModel = MenuModel.new(@levels.numberOfLevles)

    @view = SelectLevelView.new(@screen)

    @end = false

    while !@end
      while event = SDL::Event.poll
        case event
          when SDL::Event::Quit
            exit
          when SDL::Event::KeyDown
            if event.sym == SDL::Key::ESCAPE
              @end = true

              previousMenu.setEnd(false)
            end

            if event.sym == SDL::Key::UP
              @menuModel.nextUP
              @view.setCurrent(@menuModel.getCurrent)
            end

            if event.sym == SDL::Key::DOWN
              @menuModel.nextDown
              @view.setCurrent(@menuModel.getCurrent)
            end

            if event.sym == SDL::Key::RETURN
              @end = true

              GameControler.new(@screen, @levels.getLevelName(@menuModel.getCurrent), previousMenu.getPlayersSkin)

              next
            end
        end
      end
      previousMenu.draw

      self.draw

      @screen.flip
      sleep 0.02
    end
  end

  def draw
    @view.draw
    @view.drwaFileNams(@levels.getLevelsNames, @menuModel.getCurrent, @levels.numberOfLevles)
    @view.drawMiniLevel(@levels.getLevelName(@menuModel.getCurrent))
  end
end
require 'socket'
require File.dirname(__FILE__) + "/../../Model/Menu/model_menu.rb"
require File.dirname(__FILE__) + "/../../View/Lan/host_game_room_view.rb"
require File.dirname(__FILE__) + "/../../Model/Lan/server.rb"
require File.dirname(__FILE__) + "/../../Model/Menu/select_levels.rb"
require File.dirname(__FILE__) + "/lan_game_controller.rb"



class HostGame
  def initialize(screen, playerName)

    @screen = screen

    @IP = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address.to_s
    @ID = 1

    @server = Server.new(@IP)

    @serverThread = Thread.new{
      @server.run
    }


    @server_connection = DRbObject.new_with_uri('druby://'+@IP.to_s+':9000')


    @view = HostGameRoomView.new(screen, nil)

    @menuModel = MenuModel.new(4)

    @end = false

    while !@end
      @level = @server_connection.getLevel
      @server_connection.setPlayerName(@ID, playerName)
      @view.setLevel(@level)

      while event = SDL::Event.poll
        case event
          when SDL::Event::Quit
            self.stopServer
            exit
          when SDL::Event::KeyDown
            if event.sym == SDL::Key::ESCAPE
              @end = true
            end

            if event.sym == SDL::Key::UP
              @menuModel.nextUP
              @view.setCurrentOption(@menuModel.getCurrent)
            end

            if event.sym == SDL::Key::DOWN
              @menuModel.nextDown
              @view.setCurrentOption(@menuModel.getCurrent)
            end

            if event.sym == SDL::Key::RETURN

              case @menuModel.getCurrent
                when 0
                  #select skin
                  temp = SelecSkinHost.new(@screen, @server_connection.getPlayerSkin(@ID), self)
                  @server_connection.setPlayerSkin(@ID, temp.getSkinID)
                when 1
                  #select level
                  temp = SelectLevelHost.new(@screen, self)
                  tempDump = File.read(File.dirname(__FILE__) + "/../../Data/Levels/" + temp.getLeveName)

                  @server_connection.loadLevel(tempDump)
                when 2
                  @end = true
                  @server_connection.start
                  #star game


                  LanGameController.new(@screen,@server_connection,@ID)



                  #sprawdzenie czy jest przynajmniej dwoch graczy
                when 3
                  @end = true
                  #exit
                  #wyjscie do menu
              end
            end
        end
      end

      #wyswietlanie
      self.draw


      @screen.flip

    end

    self.stopServer
  end

  def stopServer
    Thread.kill(@serverThread)
    @server.stop
  end

  def setEnd(val)
    @end = val
  end

  def draw
    @view.draw
    @view.drawPlayerInfo
    @view.drawMenu
    @view.drawMiniLevel(@level)
    @view.drawIP(@IP)
  end

end

class SelecSkinHost
  def initialize(screen, skinID, hostRoom)
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
            hostRoom.stopServer
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

class SelectLevelHost
  def initialize(screen, hostRoom)
    @screen = screen

    @levels = SelectLevels.new

    @menuModel = MenuModel.new(@levels.numberOfLevles)

    @view = SelectLevelHostView.new(@screen)

    @end = false

    while !@end
      while event = SDL::Event.poll
        case event
          when SDL::Event::Quit
            hostRoom.stopServer
            exit
          when SDL::Event::KeyDown
            if event.sym == SDL::Key::ESCAPE
              @end = true
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
            end
        end
      end

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

  def getLeveName
    @levels.getLevelName(@menuModel.getCurrent)
  end
end
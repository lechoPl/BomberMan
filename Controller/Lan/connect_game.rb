require 'socket'
require File.dirname(__FILE__) + "/../../Model/Menu/model_menu.rb"
require File.dirname(__FILE__) + "/../../View/Lan/connect_game_room_view.rb"
require File.dirname(__FILE__) + "/../../Model/Lan/server.rb"
require File.dirname(__FILE__) + "/../../Model/Menu/select_levels.rb"
require File.dirname(__FILE__) + "/lan_game_controller.rb"


class ConnectGame
  def initialize(screen, playerName, ip)

    @screen = screen
    @IP = ip

    @server_connection = DRbObject.new_with_uri('druby://'+@IP.to_s+':9000')

    @ID = @server_connection.connect

    if @ID == -1
      return
    end

    @view = ConnectGameRoomView.new(screen, nil, @ID)

    @menuModel = MenuModel.new(2)

    @end = false

    while !@end
      @level = @server_connection.getLevel
      @server_connection.setPlayerName(@ID, playerName)
      @view.setLevel(@level)

      if @server_connection.start?
        LanGameController.new(@screen, @server_connection, @ID)
        @end = true
        break;
      end

      while event = SDL::Event.poll
        case event
          when SDL::Event::Quit
            @server_connection.disconnect(@ID)

            exit
          when SDL::Event::KeyDown
            if event.sym == SDL::Key::ESCAPE
              @server_connection.disconnect(@ID)
              @end = true
              break
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
                  temp = SelecSkinClient.new(@screen, @server_connection.getPlayerSkin(@ID), self)
                  @server_connection.setPlayerSkin(@ID, temp.getSkinID)
                when 1
                  @end = true
                  @server_connection.disconnect(@ID)
                  next
              end
            end
        end
      end

      #wyswietlanie
      self.draw


      @screen.flip
      sleep 0.05
    end

    @server_connection.disconnect(@ID)
  end

  def setEnd(val)
    @end = val
  end

  def draw
    @view.draw
    @view.drawPlayerInfo
    @view.drawMenu
    @view.drawMiniLevel(@level)
  end

  def disconnect
    @server_connection.disconnect(@ID)
  end

end

class SelecSkinClient
  def initialize(screen, skinID, connectRoom)
    @screen = screen

    @SkinIDFirst = skinID
    @skinID = skinID

    @curetnX = MenuModel.new(2)

    @curetnY = MenuModel.new(2)

    @view = SelectSkinViewConnect.new(@screen)

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
            connectRoom.disconnect
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

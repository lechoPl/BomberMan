require File.dirname(__FILE__) + "/../../../Model/Menu/model_menu.rb"
require File.dirname(__FILE__) + "/../../../View/Lan/lan_menus_view.rb"
require File.dirname(__FILE__) + "/../../../Model/Menu/select_levels.rb"

require File.dirname(__FILE__) + "/../../../Controller/Lan/host_game.rb"
require File.dirname(__FILE__) + "/../../../Controller/Lan/connect_game.rb"

class GetPalyerName
  def initialize(screen)
    @screen = screen

    @view = GetPalyerNameView.new(@screen)

    @end = false
    @PlayerName = String.new()

    while !@end
      while event = SDL::Event.poll
        case event
          when SDL::Event::Quit
            exit
          when SDL::Event::KeyDown
            if event.sym == SDL::Key::ESCAPE
              @end = true
            end

            if ((event.sym >= 48 && event.sym <= 57) || (event.sym >= 97 && event.sym <= 122)) && @PlayerName.length < 15
              @PlayerName += event.sym.chr
            end

            if event.sym == SDL::Key::BACKSPACE
              @PlayerName = @PlayerName.chop
            end

            if event.sym == SDL::Key::RETURN
              if @PlayerName != nil && @PlayerName != ""

                @end = true

                #wybor host - connect
                SelectTypeGame.new(self)
              end
            end
        end
      end

      self.draw

      @screen.flip
      sleep 0.02
    end
  end

  def setEnd(val)
    @end = val
  end


  def draw
    @view.draw
    @view.drwaPlayerName(@PlayerName)
  end

  def getPlayerName
    return @PlayerName
  end

  def getScreen
    return @screen
  end

end

class SelectTypeGame
  def initialize(previousMenu)
    @screen = previousMenu.getScreen

    @view = SelectTypeGameView.new(@screen)

    @end = false

    @modelMenu = MenuModel.new(3)

    @PlayerName = previousMenu.getPlayerName


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
              @modelMenu.nextUP
              @view.setCurretnrOptions(@modelMenu.getCurrent)
            end

            if event.sym == SDL::Key::DOWN
              @modelMenu.nextDown
              @view.setCurretnrOptions(@modelMenu.getCurrent)
            end

            if event.sym == SDL::Key::RETURN
              @end = true

              case @modelMenu.getCurrent
                when 0
                  #host game
                  #otworzenie game room
                  HostGame.new(@screen,@PlayerName)
                when 1
                  #connect
                  #pobranie ip
                  GetIP.new(self)
                when 2
                  #wyscie czyli nic nierobienie
              end
            end
        end
      end

      self.draw

      @screen.flip
      sleep 0.02
    end
  end

  def setEnd(val)
    @end = val
  end

  def draw
    @view.draw
  end

  def getPlayerName
    return @PlayerName
  end

  def getScreen
    return @screen
  end


  end

class GetIP
  def initialize(previousMenu)
    @screen = previousMenu.getScreen
    @PlayerName = previousMenu.getPlayerName


    @view = GetIpView.new(@screen)

    @end = false

    @IP = String.new()

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

            if ((event.sym >= 48 && event.sym <= 59) || event.sym == 46)  && @IP.length <= 15
              @IP += event.sym.chr
            end

            if event.sym == SDL::Key::BACKSPACE
              @IP = @IP.chop
            end

            if event.sym == SDL::Key::RETURN
              if @IP != nil && @IP != ""

                @end = true

                ConnectGame.new(@screen,@PlayerName,@IP)
                #client room

              end
            end
        end
      end

      self.draw

      @screen.flip
      sleep 0.02
    end
  end

  def setEnd(val)
    @end = val
  end


  def draw
    @view.draw
    @view.drwaIP(@IP)
  end

  def getPlayerName
    return @PlayerName
  end

  def getScreen
    return @screen
  end

  def getIP
    return @IP
  end
end

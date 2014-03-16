require File.dirname(__FILE__) + "/../../View/Menu/main_menu_view.rb"
require File.dirname(__FILE__) + "/../../Model/Menu/Model_menu.rb"
require File.dirname(__FILE__) + "/../Game/game_controler.rb"
require File.dirname(__FILE__) + "/../Editor/editor_controler.rb"
require File.dirname(__FILE__) + "/NewGame/new_game_all_controlers.rb"
require File.dirname(__FILE__) + "/Lan/l_menus.rb"



class MainMenuControler
  def initialize
    SDL.init( SDL::INIT_VIDEO )
    @screen = SDL::Screen.open(800,600,16,SDL::SWSURFACE)

    @menuView = MainMenuView.new(@screen)

    @menuModel = MenuModel.new(@menuView.getNumberOfElements + 1)

    while true
      while event = SDL::Event.poll
        case event
          when SDL::Event::Quit
            exit
          when SDL::Event::KeyDown
            exit if event.sym == SDL::Key::ESCAPE

            if event.sym == SDL::Key::UP
              @menuModel.nextUP
              @menuView.setCurretnrOptions(@menuModel.getCurrent)
            end

            if event.sym == SDL::Key::DOWN
              @menuModel.nextDown
              @menuView.setCurretnrOptions(@menuModel.getCurrent)
            end

            if event.sym == SDL::Key::RETURN
              case @menuModel.getCurrent
                when 0
                  #nowa gra
                  #GameControler.new(@screen)
                  NOFPMenuControler.new(@screen)

                when 1
                  #gra sieciowa
                  GetPalyerName.new(@screen)

                when 2
                  #edytor
                  EditorControler.new(@screen)
                when 3
                  exit
              end
            end
        end
      end
      @screen.fill_rect(0,0,800,600,[0,0,0])

      @menuView.drawMenu

      @screen.flip
      sleep 0.02
    end
  end
end
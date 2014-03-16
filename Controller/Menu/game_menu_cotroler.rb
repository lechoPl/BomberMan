require File.dirname(__FILE__) + "/../../View/Menu/game_menu_view.rb"
require File.dirname(__FILE__) + "/../Game/game_controler"

class GameMenuCotroler
  def initialize(game_controler)
    @screen = game_controler.getScreen

    @menuView = GameMenuView.new(@screen)

    @menuModel = MenuModel.new(@menuView.getNumberOfElements)
    @end = false

    while !@end
      while event = SDL::Event.poll
        case event
          when SDL::Event::Quit
            exit
          when SDL::Event::KeyDown
            if event.sym == SDL::Key::ESCAPE
              @end = true
              game_controler.continueAllBombs
            end

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
                  game_controler.continueAllBombs
                  @end = true
                when 1
                  game_controler.setEnd(true)
                  @end = true
              end
            end
        end
      end

      @menuView.drawMenu

      @screen.flip
      sleep 0.02
    end
  end
end
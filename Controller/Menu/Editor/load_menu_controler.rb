require File.dirname(__FILE__) + "/../../Editor/editor_controler.rb"
require File.dirname(__FILE__) + "/../../../Model/Menu/model_menu.rb"
require File.dirname(__FILE__) + "/../../../Model/Menu/select_levels.rb"
require File.dirname(__FILE__) + "/../../../View/Menu/load_level_view.rb"

class LoadMenuControler
  def initialize(editor_controler)
    @screen = editor_controler.getScreen

    @levels = SelectLevels.new
    @menuModel = MenuModel.new(@levels.numberOfLevles)

    @loadLevelView = LoadLevelView.new(@screen)

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

            if event.sym == SDL::Key::UP
              @menuModel.nextUP
              #@menuView.setCurretnrOptions(@menuModel.getCurrent)
            end

            if event.sym == SDL::Key::DOWN
              @menuModel.nextDown
              #@menuView.setCurretnrOptions(@menuModel.getCurrent)
            end

            if event.sym == SDL::Key::RETURN
              temp = File.read(File.dirname(__FILE__) + "/../../../Data/Levels/" + @levels.getLevelName(@menuModel.getCurrent))
              editor_controler.load(temp)

              @end = true
            end
        end
      end

      @loadLevelView.draw
      @loadLevelView.drwaFileNams(@levels.getLevelsNames, @menuModel.getCurrent, @levels.numberOfLevles)

      @screen.flip
      sleep 0.02
    end
  end
end
require File.dirname(__FILE__) + "/../../../View/Menu/editor_menu_view.rb"
require File.dirname(__FILE__) + "/../../Editor/editor_controler.rb"
require File.dirname(__FILE__) + "/../../../Model/Menu/model_menu.rb"
require File.dirname(__FILE__) + "/save_level_controler.rb"
require File.dirname(__FILE__) + "/load_menu_controler.rb"

class EditorMenuControler
  def initialize(editor_controler)
    @screen = editor_controler.getScreen

    @menuView = EditorMenuView.new(@screen)


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
                  @end = true
                when 1
                  SaveLevelControler.new(editor_controler)#save
                  editor_controler.draw
                when 2
                  LoadMenuControler.new(editor_controler)
                  editor_controler.draw
                when 3
                  editor_controler.setEnd(true)
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
require File.dirname(__FILE__) + "/../../../View/Menu/save_level_view.rb"

class SaveLevelControler
  def initialize(editor_controler)
    @screen = editor_controler.getScreen

    @saveView = SaveLevelView.new(@screen)#EditorMenuView.new(@screen)

    @end = false
    @fileName = String.new()

    while !@end
      while event = SDL::Event.poll
        case event
          when SDL::Event::Quit
            exit
          when SDL::Event::KeyDown
            if event.sym == SDL::Key::ESCAPE
              @end = true
            end

            if ((event.sym >= 48 && event.sym <= 57) || (event.sym >= 97 && event.sym <= 122)) && @fileName.length < 15
              @fileName += event.sym.chr
            end

            if event.sym == SDL::Key::BACKSPACE
              @fileName = @fileName.chop
            end

            if event.sym == SDL::Key::RETURN
              #zapisanie do pliku
              if @fileName != nil && @fileName != ""
                file = File.new(File.dirname(__FILE__) + "/../../../Data/Levels/" + @fileName + ".lvl", "w")
                file << editor_controler.save
                file.close

                @end = true
              end
            end
        end
      end

      @saveView.draw
      @saveView.drwaFileName(@fileName)

      @screen.flip
      sleep 0.02
    end
  end
end
require "sdl"
require File.dirname(__FILE__) + "/editor_user.rb"
require File.dirname(__FILE__) + "/../../Model/level.rb"
require File.dirname(__FILE__) + "/../../Model/Editor/user.rb"
require File.dirname(__FILE__) + "/../../View/Editor/editor_view.rb"
require File.dirname(__FILE__) + "/../Menu/Editor/editor_menu_controler.rb"

class EditorControler
  def initialize(screen_)
    @screen = screen_

    @level = Level.new

    @user = User.new(0,3, @level)

    @userControl = EditorUser.new(@level, @user)

    @view = EditorView.new(@screen, @level, @user)

    @view.setLevel(@level)

    @end = false
    while ! @end
      while event = SDL::Event.poll
        case event
          when SDL::Event::Quit
            exit
          when SDL::Event::KeyDown
            if event.sym == SDL::Key::ESCAPE
              EditorMenuControler.new(self)
              next
            end
        end
      end

      @screen.fill_rect(0,0,800,600,[0,0,0])

      self.draw

      @userControl.move
      @userControl.setField

      @view.flip

      sleep 0.1
    end
  end

  def draw
    @view.drawBoard
    @view.drawUser
  end

  def getScreen
    return @screen
  end

  def setEnd(val)
    @end = val
  end

  #return Marshal.dump
  def save
    return @level.save
  end

  def load(marshal_dump)
    return @level.load(marshal_dump)
  end
end
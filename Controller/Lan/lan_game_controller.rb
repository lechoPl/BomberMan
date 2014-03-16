require File.dirname(__FILE__) + "/../../Model/Lan/server.rb"
require File.dirname(__FILE__) + "/../../View/Game/game_view.rb"
require File.dirname(__FILE__) + "/lan_player_controller.rb"

class LanGameController
  def initialize(screen, server_client, id)
    @ID = id
    @server = server_client

    @playerControler = LanPlayerController.new(@server, @ID)

    @screen = screen
    @view = GameView.new(@screen)

    @end = false

    while !@end
      begin
        @level = @server.getLevel
      rescue
        #wysietlenie okienka lost conection
        puts "utracono polaczenie"

        break
      end

      @view.setLevel(@level)

      while event = SDL::Event.poll
        case event
          when SDL::Event::Quit
            begin
              @server.disconnect(@ID)
            rescue
            end

            exit
          when SDL::Event::KeyDown
            if event.sym == SDL::Key::ESCAPE
              begin
                @server.disconnect(@ID)
              rescue
              end
              @end = true

              next
            end
        end
      end

      @playerControler.setBomb
      @playerControler.move

      @screen.fill_rect(0,0,800,600,[0,0,0])
      @view.drawBoard
      @view.drawPlayers
      @view.drawExplosion

      @view.flip

      sleep 0.002
    end

    begin
      @server.disconnect(@ID)
    rescue
    end

  end

end
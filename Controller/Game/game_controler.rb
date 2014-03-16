require "sdl"
require File.dirname(__FILE__) + "/../../Model/Game/game_level.rb"
require File.dirname(__FILE__) + "/../../Model/Game/pair.rb"
require File.dirname(__FILE__) + "/../../Model/Game/player.rb"
require File.dirname(__FILE__) + "/../../View/Game/game_view.rb"
require File.dirname(__FILE__) + "/../Players/player_1.rb"
require File.dirname(__FILE__) + "/../Players/player_2.rb"
require File.dirname(__FILE__) + "/../Players/player_3.rb"
require File.dirname(__FILE__) + "/../Players/player_4.rb"
require File.dirname(__FILE__) + "/../Players/player_2.rb"
require File.dirname(__FILE__) + "/../Menu/game_menu_cotroler"


class GameControler
  def initialize(screen_, level_name, playersSkinsID)
    @lock = Mutex.new

    @screen = screen_
    @view = GameView.new(@screen)
    @level = GameLevel.new()

    tempDump = File.read(File.dirname(__FILE__) + "/../../Data/Levels/" + level_name)
    @level.load(tempDump)

    @view.setLevel(@level)

    @gameStop = true

    for i in 1 .. playersSkinsID.length
      poz = @level.getPosition(i-1)
      @level.addPlayer(i, Player.new(poz.getX, poz.getY, i, @level, playersSkinsID[i-1]))
    end


    if playersSkinsID.length >= 2
      @p1 = Player_1.new(@level,1)
      @p2 = Player_2.new(@level,2)


      threadP1 = Thread.new{
        while @p1.isLive?
          playerControl(@p1, @view) if !@gameStop || @level.gameEnd?
          sleep 0.01
        end
      }

      threadP2 = Thread.new{
        while @p2.isLive?
          playerControl(@p2, @view) if !@gameStop || @level.gameEnd?
          sleep 0.01
        end
      }
    end

    if playersSkinsID.length >= 3
      @p3 = Player_3.new(@level,3)

      threadP3 = Thread.new{
        while @p3.isLive?
          playerControl(@p3, @view) if !@gameStop || @level.gameEnd?
          sleep 0.01
        end
      }
    end

    if playersSkinsID.length == 4
      @p4 = Player_4.new(@level,4)

      threadP3 = Thread.new{
        while @p4.isLive?
          playerControl(@p4, @view) if !@gameStop || @level.gameEnd?
          sleep 0.01
        end
      }
    end



    @end = false

    while !@end
      @gameStop = false

      while event = SDL::Event.poll
        case event
          when SDL::Event::Quit
            exit
          when SDL::Event::KeyDown
            if event.sym == SDL::Key::ESCAPE
              @gameStop = true

              @level.getBombs.each { |b| b.pause}
              GameMenuCotroler.new(self)
              next
            end
        end
      end

        @screen.fill_rect(0,0,800,600,[0,0,0])
        @view.drawBoard
        @view.drawPlayers
        @view.drawExplosion

        @view.flip



      sleep 0.002

      break if @level.gameEnd? && !@level.isAnyExplosion?# zakonczone eksplozje
    end

    if @level.gameEnd?

      @pressKey = false

      while !@pressKey

        while event = SDL::Event.poll
          case event
            when SDL::Event::Quit
              exit
            when SDL::Event::KeyDown
              if event.sym == SDL::Key::RETURN
                @pressKey = true
              end

          end
        end

        @view.drawWin
        @view.flip

        sleep 1
      end
    end

  end

  def continueAllBombs
    @level.getBombs.each { |b| b.resume }
  end

  def setEnd(val)
    @end =  val
  end

  def getScreen
    return @screen
  end

  def playerControl(player, view)
      if player.isLive?
        player.setBomb

        tempX = player.getX
        tempY = player.getY
        temp = player.move

        case temp
          when 2
            if tempY != player.getY
              view.startAnimation(player.getPlayer,player.getX,player.getY)
            end
          when 4
            if tempX != player.getX
              view.startAnimation(player.getPlayer,player.getX,player.getY)
            end
          when 6
            if tempX != player.getX
              view.startAnimation(player.getPlayer,player.getX,player.getY)
            end
          when 8
            if tempY != player.getY
              view.startAnimation(player.getPlayer,player.getX,player.getY)
            end

        end
      end
  end

end


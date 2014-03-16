require "drb"
require File.dirname(__FILE__) + "/../Game/game_level.rb"
require File.dirname(__FILE__) + "/../Game/player.rb"

class Server
  def initialize(ip)
    @level = GameLevel.new
    @ip = ip


    poz = @level.getPosition(0)
    @level.addPlayer(1, Player.new(poz.getX, poz.getY, 1, @level, 1))

    @level.getAllPlayers.each_value{|p|
      if p != nil
      end
    }

    @start = false
  end

  def setPlayerName(id, name)
    p = @level.getPlayer(id)
    if p != nil
      p.setName(name)
    end
  end

  def setPlayerSkin(id, skinID)
    p = @level.getPlayer(id)
    if p != nil
      p.setSkinID(skinID)
    end
  end

  def getPlayerSkin(id)
    p = @level.getPlayer(id)
    if p != nil
      return p.getSkinID
    end
  end

  def connect
    return -1 if @start

    id = 1
    @level.getAllPlayers.each_value{ |p|
      if p != nil
        id += 1
      else
        break;
      end
    }
    if id <= 4
      poz = @level.getPosition(id-1)
      @level.addPlayer(id, Player.new(poz.getX, poz.getY, id, @level, id))

      return id
    end

    return -1
  end

  def disconnect(id)
    @level.killPlayerID(id)
  end

  def start
    @start = true
  end

  def start?
    return @start
  end

  def getLevel
    return @level
  end

  def loadLevel(marshal_dump)
    @level.load(marshal_dump)
  end

  def move_UP(id)
    return -1 if !@start

    p = @level.getPlayer(id)
    return -2 if p == nil

    p.move_UP
  end

  def move_DOWN(id)
    return -1 if !@start

    p = @level.getPlayer(id)
    return -2 if p == nil

    p.move_Down
  end

  def move_LEFT(id)
    return -1 if !@start

    p = @level.getPlayer(id)
    return -2 if p == nil

    p.move_Left
  end

  def move_RIGTH(id)
    return -1 if !@start

    p = @level.getPlayer(id)
    return -2 if p == nil

    p.move_Right
  end

  def set_Bomb(id)
    return -1 if !@start
    p = @level.getPlayer(id)
    return -2 if p == nil

    p.setBomb
  end

  def run
    puts "run server: " + @ip.to_s

    adres = 'druby://' + @ip.to_s + ':9000'


    DRb.start_service(adres, self)

    DRb.thread.join

  end

  def stop
    puts "stop server: " + @ip.to_s

    Thread.kill(DRb.thread)
    DRb.stop_service()
  end
end
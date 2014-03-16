class Bomb
  @@next_id = 0

  def initialize(x, y, power, board, player)
    @ID = @@next_id
    @@next_id += 1

    @level = board

    @Power = power
    @Player = player

    @X = x
    @Y = y

    @lock = Mutex.new

    @startTime = Time.new
    @pauseTime = nil

    @isPause = false

    @Th = Thread.new{self.start}
    @Th.run
  end

  def pause
    @isPause = true
    @pauseTime = Time.new
  end

  def resume
    @isPause = false
  end

  def start
    sleep 3

    while @isPause
      sleep 0.002
    end

    if @pauseTime != nil
      temp = (3 - (@pauseTime - @startTime))

      sleep temp if temp > 0
    end

    self.explosion
    @Player.addBomb(1)
    self.drawExplosion

    @startTime = Time.new
    self.explosion_run

    while @isPause
      sleep 0.002
    end

    if @pauseTime != nil
      temp = (1.5 - (@pauseTime - @startTime))

      explosion_run_pause(temp)
    end


    #self.explosion
    self.clearExplosion

  end

  def explosion_run
    for i in 1..10
      @lock.synchronize{
        @level.killPlayer(@X, @Y)

        for i in 1 .. @upExp
          @level.killPlayer(@X, @Y-i)
        end

        for i in 1 .. @downExp
          @level.killPlayer(@X, @Y+i)
        end

        for i in 1 .. @leftExp
          @level.killPlayer(@X-i, @Y)
        end

        for i in 1 .. @rightExp
          @level.killPlayer(@X+i, @Y)
        end
      }
      sleep 0.15
    end
  end

  def explosion_run_pause(time)

    temp = time/10

    for i in 1..10
      @lock.synchronize{
        @level.killPlayer(@X, @Y)

        for i in 1 .. @upExp
          @level.killPlayer(@X, @Y-i)
        end

        for i in 1 .. @downExp
          @level.killPlayer(@X, @Y+i)
        end

        for i in 1 .. @leftExp
          @level.killPlayer(@X-i, @Y)
        end

        for i in 1 .. @rightExp
          @level.killPlayer(@X+i, @Y)
        end
      }
      sleep temp
    end
  end

  def explosion
    @lock.synchronize{
      @level.setField(@X, @Y, nil)

      @level.killPlayer(@X, @Y)


      # WYBUCH!!!
      @upExp = 0
      @downExp = 0
      @leftExp = 0
      @rightExp = 0

      #symulacja up
      for i in 1 .. @Power
        break if @Y - i < 0

        if @level.getField(@X, @Y-i) != nil && @level.getField(@X, @Y-i).class != Bomb
          #@level.destroyField(@X - i, @Y)

          @upExp = i if @level.destroyField(@X , @Y-i)
          break;
        end

        @level.killPlayer(@X, @Y-i)

        @upExp = i
      end

      #symulacja down
      for i in 1 .. @Power
        break if @Y + i >= @level.getHeight

        if @level.getField(@X, @Y+i) != nil && @level.getField(@X, @Y+i).class != Bomb
          #@level.destroyField(@X + i, @Y)

          @downExp = i if @level.destroyField(@X, @Y+i)
          break;
        end

        @level.killPlayer(@X, @Y+i)

        @downExp = i
      end

      #symulacja left
      for i in 1 .. @Power
        break if @X - i < 0

        if @level.getField(@X-i, @Y) != nil && @level.getField(@X-i, @Y).class != Bomb
          #@level.destroyField(@X, @Y - i)

          @leftExp = i if @level.destroyField(@X-i, @Y )

          break;
        end

        @level.killPlayer(@X-i, @Y)

        @leftExp = i
      end

      #symulacja rigth
      for i in 1 .. @Power

        break if @X + i >= @level.getWidth

        if @level.getField(@X+i, @Y ) != nil && @level.getField(@X+i, @Y ).class != Bomb
          #@level.destroyField(@X, @Y + i)

          @rightExp = i if @level.destroyField(@X+i, @Y)

          break;
        end

        @level.killPlayer(@X+i, @Y)

        @rightExp = i
      end
    }
  end

  def getID
    return @ID
  end

  def drawExplosion
    @lock.synchronize{
      @level.setExplosion(@ID, @X,@Y, @upExp, @downExp, @leftExp, @rightExp)
    }
  end

  def clearExplosion
    @lock.synchronize{
      @level.clearExplosion(@ID, @X,@Y, @upExp, @downExp, @leftExp, @rightExp)
    }

    @level.getBombs.delete_if { |b| b.getID == @ID }
  end
end
class SelectLevels
  def initialize
    @levels = Array.new

    Dir.foreach( File.dirname(__FILE__) + "/../../Data/Levels/"){|file|
      @levels << file if file.end_with?(".lvl") }
  end

  def numberOfLevles
    return @levels.length
  end

  def getLevelsNames
    return @levels
  end

  def getLevelName(id)
    return @levels[id]
  end
end
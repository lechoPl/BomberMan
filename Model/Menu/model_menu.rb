class MenuModel
  def initialize(max)
    @Max = max
    @currentOption = 0
  end


  def nextUP
    @currentOption -= 1

    (@currentOption = @Max - 1) if @currentOption == -1
  end

  def nextDown
    @currentOption += 1

    @currentOption = 0 if @currentOption == @Max
  end

  def getCurrent
    return @currentOption
  end

end
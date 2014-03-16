require File.dirname(__FILE__) + "/bonus.rb"

class BonusPower < Bonus
  def initialize
    @Val = 1
  end

  def getVal
    return @Val
  end
end
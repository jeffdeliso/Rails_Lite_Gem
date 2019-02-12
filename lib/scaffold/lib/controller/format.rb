class Format 
  attr_reader :controller

  def initialize(controller)
    @controller = controller
  end

  def json(&prc)
    debugger
  end
  
  def html(&prc)
  end
end
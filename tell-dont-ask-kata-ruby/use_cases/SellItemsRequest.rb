class SellItemsRequest

  attr_accessor :requests

  def initialize(requests: [])
    @requests = requests
  end
end
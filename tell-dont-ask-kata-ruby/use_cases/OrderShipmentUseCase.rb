require_relative "../spec/doubles/OrderDatabase"
require_relative "../spec/doubles/ShipmentService"
require_relative "../models/OrderStatus"
require_relative "OrderCannotBeShippedError"
require_relative "OrderCannotBeShippedTwiceError"

class OrderShipmentUseCase

  attr_accessor :order_database, :shipment_service

  def initialize (order_database:, shipment_service:)
    @order_database = order_database
    @shipment_service = shipment_service
  end

  def run(request:)
    order = order_database.find_by_id(:order_id => request.order_id)

    if (order.status == OrderStatus::CREATED || order.status == OrderStatus::REJECTED)
      raise OrderCannotBeShippedError.new()
    end

    if (order.status == OrderStatus::SHIPPED)
      raise OrderCannotBeShippedTwiceError.new()
    end

    shipment_service.ship(:order => order)

    order.status = OrderStatus::SHIPPED
    @order_database.save(:order => order)
  end

end
class Order
    attr_accessor :total, :currency, :items, :tax, :status, :id

    def initialize(total: 0.00, currency: 'Unknown', items: [], tax: 0.00, status: OrderStatus::CREATED, id: nil)
        @total = total
        @currency = currency
        @items = items
        @tax = tax
        @status = status
        @id = id
    end

end

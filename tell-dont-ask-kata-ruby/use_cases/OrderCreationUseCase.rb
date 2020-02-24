require_relative "UnknownProductError"
require_relative "../models/Order"

class OrderCreationUseCase

    attr_accessor :order_database, :product_catalog

    def initialize(order_database:, product_catalog:)
        @order_database = order_database
        @product_catalog = product_catalog
    end

    def run(request:)
        order = Order.new(
          :status => OrderStatus::CREATED,
          :items => [],
          :currency => 'EUR',
          :total => 0.00,
          :tax => 0.00
        )

        request.requests.each do | item_request |
            product = @product_catalog.find_by_name(:name => item_request.product_name)

            if (product.nil?)
                raise UnknownProductError.new()
            else
                unitary_tax = (product.price / 100.0 * product.category.tax_percentage).round(2)
                unitary_taxed_amount = (product.price + unitary_tax).round(2)
                taxed_amount = (unitary_taxed_amount * item_request.quantity).round(2)
                tax_amount = (unitary_tax * item_request.quantity)

                order_item = OrderItem.new(
                    :product => product,
                    :quantity => item_request.quantity,
                    :tax => tax_amount,
                    :taxed_amount => taxed_amount,
                )

                order.items << order_item
                order.total += taxed_amount
                order.tax += tax_amount
            end
        end

        @order_database.save(:order => order)
    end
end
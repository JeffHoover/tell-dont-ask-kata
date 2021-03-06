package it.gabrieletondi.telldontaskkata.domain;

import java.math.BigDecimal;

import static java.math.BigDecimal.valueOf;
import static java.math.RoundingMode.HALF_UP;

public class Product {
    private String name;
    private BigDecimal price;
    private Category category;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public BigDecimal getUnitaryTax() {
        return price.divide(valueOf(100))
                .multiply(category.getTaxPercentage()).setScale(2, HALF_UP);
    }

    public BigDecimal getUnitaryTaxedAmount() {
        return price.add(getUnitaryTax()).setScale(2, HALF_UP);
    }

    public BigDecimal getTaxedAmount(int quantity) {
        return getUnitaryTaxedAmount().multiply(BigDecimal.valueOf(quantity)).setScale(2, HALF_UP);
    }

    public OrderItem constructOrderItem(int quantity) {
        final OrderItem orderItem = new OrderItem();
        orderItem.setProduct(this);
        orderItem.setQuantity(quantity);
        orderItem.setTax(getUnitaryTax().multiply(BigDecimal.valueOf(quantity)));
        orderItem.setTaxedAmount(getTaxedAmount(quantity));
        return orderItem;
    }
}

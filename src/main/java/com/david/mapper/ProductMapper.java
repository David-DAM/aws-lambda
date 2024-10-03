package com.david.mapper;

import com.david.domain.Product;
import com.david.request.ProductRequest;
import org.springframework.stereotype.Component;

import java.util.function.Function;

@Component
public class ProductMapper implements Function<ProductRequest, Product> {
    @Override
    public Product apply(ProductRequest product) {
        return Product.builder()
                .name(product.getName())
                .price(product.getPrice())
                .description(product.getDescription())
                .quantity(0)
                .build();
    }


}

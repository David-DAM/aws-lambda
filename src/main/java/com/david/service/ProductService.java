package com.david.service;

import com.david.domain.Product;
import com.david.dto.ProductDto;
import com.david.mapper.ProductDtoMapper;
import com.david.mapper.ProductMapper;
import com.david.request.ProductRequest;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class ProductService {

    private final ProductDtoMapper productDtoMapper;
    private final ProductMapper productMapper;
    @Qualifier("fileStoreAwsImp")
    private final FileStoreInterface fileStoreInterface;

    public ProductDto save(ProductRequest productRequest) {

        String imageUrl;

        try {

            imageUrl = fileStoreInterface.upload(productRequest.getImage());

        } catch (Exception e) {

            throw new RuntimeException(e);
        }

        Product product = productMapper.apply(productRequest);

        product.setImageUrl(imageUrl);

        return productDtoMapper.apply(product);
    }

}

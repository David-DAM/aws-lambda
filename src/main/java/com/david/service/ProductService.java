package com.david.service;

import com.david.domain.Product;
import com.david.dto.ProductDto;
import com.david.mapper.ProductDtoMapper;
import com.david.mapper.ProductMapper;
import com.david.repository.ProductRepository;
import com.david.request.ProductRequest;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Service
@AllArgsConstructor
public class ProductService {

    private final ProductDtoMapper productDtoMapper;
    private final ProductMapper productMapper;
    @Qualifier("fileStoreAwsImp")
    private final FileStoreInterface fileStoreInterface;
    private final ProductRepository productRepository;

    public ProductDto save(ProductRequest productRequest, MultipartFile image) {

        String imageUrl;

        try {

            imageUrl = fileStoreInterface.upload(image);

        } catch (Exception e) {

            throw new RuntimeException(e);
        }

        Product product = productMapper.apply(productRequest);

        product.setImageUrl(imageUrl);

        Product saved = productRepository.save(product);

        return productDtoMapper.apply(saved);
    }

    public ProductDto update(ProductRequest productRequest) {
        return null;
    }

    public List<ProductDto> findAll() {

        List<Product> productList = productRepository.findAll();

        List<ProductDto> productDtoList = productList.stream()
                .map(productDtoMapper)
                .toList();

        return productDtoList;
    }

    public ProductDto findById(Long id) {

        Product product = productRepository.findById(id).orElseThrow(() -> new RuntimeException("Product not found"));

        return productDtoMapper.apply(product);
    }

    public void delete(Long id) {

        Product product = productRepository.findById(id).orElseThrow(() -> new RuntimeException("Product not found"));

        productRepository.delete(product);

    }

}

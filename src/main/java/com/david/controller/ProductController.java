package com.david.controller;

import com.david.domain.Product;
import com.david.dto.ProductDto;
import com.david.request.ProductRequest;
import com.david.service.ProductService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/products")
@AllArgsConstructor
public class ProductController {

    private final ProductService productService;

    @PostMapping()
    public ResponseEntity<ProductDto> save(@RequestBody ProductRequest productRequest ){

        ProductDto saved = productService.save(productRequest);

        return new ResponseEntity<>(saved, HttpStatus.CREATED);
    }
}

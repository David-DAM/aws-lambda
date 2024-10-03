package com.david.controller;

import com.david.dto.ProductDto;
import com.david.request.ProductRequest;
import com.david.service.ProductService;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/products")
@AllArgsConstructor
public class ProductController {

    private final ProductService productService;

    @PostMapping(produces = "application/json", consumes = "application/json")
    public ResponseEntity<ProductDto> save(@RequestBody ProductRequest productRequest) {

        ProductDto saved = productService.save(productRequest);

        return new ResponseEntity<>(saved, HttpStatus.CREATED);
    }

    @GetMapping(produces = "application/json", consumes = "application/json")
    public ResponseEntity<List<ProductDto>> findAll() {

        List<ProductDto> productDtoList = productService.findAll();

        return new ResponseEntity<>(productDtoList, HttpStatus.OK);
    }

    @GetMapping(name = "/{id}", produces = "application/json", consumes = "application/json")
    public ResponseEntity<ProductDto> findById(@RequestParam Long id) {

        ProductDto productDto = productService.findById(id);

        return new ResponseEntity<>(productDto, HttpStatus.OK);
    }
}

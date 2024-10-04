package com.david.controller;

import com.david.dto.ProductDto;
import com.david.request.ProductRequest;
import com.david.service.ProductService;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/api/products")
@AllArgsConstructor
public class ProductController {

    private final ProductService productService;

    @PostMapping()
    public ResponseEntity<ProductDto> save(@RequestBody ProductRequest productRequest, @RequestParam MultipartFile image) {

        ProductDto saved = productService.save(productRequest, image);

        return new ResponseEntity<>(saved, HttpStatus.CREATED);
    }

    @GetMapping()
    public ResponseEntity<List<ProductDto>> findAll() {

        List<ProductDto> productDtoList = productService.findAll();

        return new ResponseEntity<>(productDtoList, HttpStatus.OK);
    }

    @GetMapping("/{id}")
    public ResponseEntity<ProductDto> findById(@PathVariable Long id) {

        ProductDto productDto = productService.findById(id);

        return new ResponseEntity<>(productDto, HttpStatus.OK);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {

        productService.delete(id);

        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }
}

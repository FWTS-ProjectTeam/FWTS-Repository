package com.teamf.fwts.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.teamf.fwts.dto.ProductsDto;
import com.teamf.fwts.mapper.ProductsMapper;

@Service
public class ProductsService {

    @Autowired
    private ProductsMapper productsMapper;

    // 상품 등록
    public void addProduct(ProductsDto product) {
        productsMapper.insertProduct(product);
    }

    // 상품 조회
    public ProductsDto getProductById(int proId) {
        return productsMapper.getProductById(proId);
    }

    // 상품 수정
    public void updateProduct(ProductsDto product) {
    	productsMapper.updateProduct(product);
    }

    // 상품 삭제
    public void deleteProduct(int proId) {
    	productsMapper.deleteProduct(proId);
    }
    
    // 상품 목록 조회
    public List<ProductsDto> getAllProducts() {
        return productsMapper.getAllProducts();
    }
    // 상품 개수 조회
    public int countProducts(Map<String, Object> params) {
    	return productsMapper.countProducts(params);
    }    
    // 상품 목록 페이지 조회
    public List<ProductsDto> getProductsWithPage(Map<String, Object> params) {
        return productsMapper.getProductsWithPage(params);
    }

    // 특정 셀러의 상품 목록 조회
    public List<ProductsDto> getProductsBySellerId(int sellerId) {
        return productsMapper.getProductsBySellerId(sellerId);
    }

    // 특정 셀러의 상품 개수 조회
    public int countBySellerId(int sellerId) {
        return productsMapper.countBySellerId(sellerId);
    }

    // 특정 셀러의 상품 목록 (페이지네이션 포함)
    public List<ProductsDto> findBySellerIdAndPage(Map<String, Object> params) {
        return productsMapper.findBySellerIdAndPage(params);
    }
    

    
}
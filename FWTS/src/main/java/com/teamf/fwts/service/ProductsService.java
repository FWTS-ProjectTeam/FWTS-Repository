package com.teamf.fwts.service;

import java.util.HashMap;
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

    // 상품 개수 조회
    public int countAllProducts(Map<String, Object> params) {
    	return productsMapper.countAllProducts(params);
    }    
    // 상품 목록 페이지 조회
    public List<ProductsDto> findProductsWithPage(Map<String, Object> params) {
        return productsMapper.findProductsWithPage(params);
    }

    // 셀러의 상품 개수 조회
    public int countBySellerId(int sellerId) {
        return productsMapper.countBySellerId(sellerId);
    }
    // 셀러의 상품 목록 페이지 조회
    public List<ProductsDto> findBySellerIdWithPage(Map<String, Object> params) {
        return productsMapper.findBySellerIdWithPage(params);
    }
    
    // 셀러의 상품 개수 조회 (판매 x 상품 포함)
    public int countAllBySellerId(int sellerId) {
        return productsMapper.countAllBySellerId(sellerId);
    }
    // 셀러의 상품 목록 페이지 조회 (판매 x 상품 포함)
    public List<ProductsDto> findAllBySellerIdWithPage(Map<String, Object> params) {
        return productsMapper.findAllBySellerIdWithPage(params);
    }
    
    // 메인 페이지 HOT 상품 조회
    public List<ProductsDto> getTop5Products() {
        Map<String, Object> params = new HashMap<>();
        params.put("category", "0");      // 모든 카테고리 조회
        params.put("keyword", "");        // 검색어 없이 전체 조회
        params.put("sort", "total_sales"); // 판매량 기준 정렬
        params.put("start", 0);           // 0번부터 시작
        params.put("count", 5);           // 상위 5개만 조회

        return productsMapper.findProductsWithPage(params);
    }
    
}
package com.teamf.fwts.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.teamf.fwts.dto.Products;
import com.teamf.fwts.service.ProductService;

@Controller
public class ProductController {
	
	 private final ProductService productService;

	    public ProductController(ProductService productService) {
	        this.productService = productService;
	    }
	    
	    // 상품 목록 조회
	    @GetMapping("/productList")
	    public String getProductList(Model model) {
	    	List<Products> productList = productService.getProducts();
	    	model.addAttribute("productList", productList);
	    	
	    	return "product/product_list";
	    }
	    
	    // 상품 상세 조회
	    @GetMapping("/productDetail")
	    public String getProductDetail(@RequestParam("proId") int proId, Model model) {
	    	Products productDetail = productService.getProductDetail(proId);
	    	model.addAttribute("product", productDetail);
	    	
	    	return "product/product_detail";
	    }
}

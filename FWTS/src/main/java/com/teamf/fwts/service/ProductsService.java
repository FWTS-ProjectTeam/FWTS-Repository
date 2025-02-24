package com.teamf.fwts.service;

import java.util.List;

import org.springframework.stereotype.Service;
import com.teamf.fwts.dto.Products;
import com.teamf.fwts.dao.ProductDao;
import com.teamf.fwts.dao.SellerOrderDao;

@Service
public class ProductService {
	
	private final ProductDao productDao;

    public ProductService(ProductDao productDao) {
        this.productDao = productDao;
    }

    public List<Products> getProducts(){
    	return productDao.getProductList();
    }
    
    public Products getProductDetail(int proId) {
    	return productDao.getProductDetail(proId);
    }
}

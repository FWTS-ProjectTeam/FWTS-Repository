package com.teamf.fwts.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.teamf.fwts.dto.Products;

@Mapper
public interface ProductDao {

	// 전체 상품 조회
	@Select("SELECT pro_id, pro_name " + // 상품 아이디, 상품명
    		"FROM products ")
	List<Products> getProductList();
	
	// 상품 상세 조회
	@Select("SELECT pro_id, pro_name, unit_price, delivery_fee " +
			"FROM products " +
			"WHERE pro_id = #{proId}")
	Products getProductDetail(@Param("proId") int proId);
}

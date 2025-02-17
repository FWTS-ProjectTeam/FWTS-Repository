package com.teamf.fwts.mapper;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.apache.ibatis.annotations.Param;

import com.teamf.fwts.dto.ProductsDto;

import java.util.List;
import java.util.Map;

@Mapper
public interface ProductsMapper {

	// 상품 등록
	@Insert("INSERT INTO products (seller_id, category_id, color_id, pro_name, inventory, max_possible, min_possible, unit_price, is_sales, description, img_path, is_delete, regist_date, delivery_fee) "
			+ "VALUES (#{sellerId}, #{categoryId}, #{colorId}, #{proName}, #{inventory}, #{maxPossible}, #{minPossible}, #{unitPrice}, #{isSales}, #{description}, #{imgPath}, #{isDelete}, #{registDate}, #{deliveryFee})")
	void insertProduct(ProductsDto product);

    // 상품 조회
    @Select("SELECT * FROM products WHERE pro_id = #{proId}")
    ProductsDto getProductById(@Param("proId") int proId);

    // 상품 목록 조회
    @Select("SELECT * FROM products WHERE is_delete = FALSE")
    List<ProductsDto> getAllProducts();
    // 상품 개수 조회 (검색 조건 포함)
    @Select("<script>" +
            "SELECT COUNT(*) FROM products WHERE is_delete = FALSE" +
            "<if test='category != null'> AND category_id = #{category} </if>" +
            "<if test='keyword != null'> AND pro_name LIKE CONCAT('%', #{keyword}, '%') </if>" +
            "</script>")
    int countProducts(Map<String, Object> params);
    // 페이지네이션+재정렬 상품 목록 조회
    @Select("<script>" +
            "SELECT * FROM products WHERE is_delete = FALSE" +
            "<if test='category != null and category != \"0\"'> AND category_id = #{category} </if>" +
            "<if test='keyword != null and keyword != \"\"'> AND pro_name LIKE CONCAT('%', #{keyword}, '%') </if>" +
            "<choose>" +
            "   <when test='sort == \"price_high\"'> ORDER BY unit_price DESC </when>" +
            "   <when test='sort == \"price_low\"'> ORDER BY unit_price ASC </when>" +
            "   <otherwise> ORDER BY total_sales DESC </otherwise>" +
            "</choose>" +
            "LIMIT #{start}, #{count}" +
            "</script>")
    List<ProductsDto> getProductsWithPage(Map<String, Object> params);
    
    // 셀러의 상품 목록 조회 (특정 셀러의 상품만)
    @Select("SELECT * FROM products WHERE seller_id = #{sellerId} AND is_delete = FALSE")
    List<ProductsDto> getProductsBySellerId(@Param("sellerId") int sellerId);    
    // 셀러의 상품 개수 조회 (셀러 ID에 해당하는 상품 개수를 반환)
    @Select("SELECT COUNT(*) FROM products WHERE seller_id = #{sellerId} AND is_delete = FALSE")
    int countBySellerId(@Param("sellerId") int sellerId);
    // 셀러의 상품 목록 조회 (페이지 네비게이션 포함)
    @Select("SELECT * FROM products WHERE seller_id = #{sellerId} AND is_delete = FALSE LIMIT #{start}, #{count}")
    List<ProductsDto> findBySellerIdAndPage(Map<String, Object> params);
    
	/*
	 * // 특정 샵의 상품 개수 조회 (검색 포함)
	 * 
	 * @Select("<script>" +
	 * "SELECT COUNT(*) FROM products WHERE seller_id = #{sellerId} AND is_delete = FALSE"
	 * +
	 * "<if test='keyword != null and keyword != \"\"'> AND pro_name LIKE CONCAT('%', #{keyword}, '%') </if>"
	 * + "</script>") int countBySellerIdWithKeyword(Map<String, Object> params);
	 * 
	 * // 특정 샵의 상품 목록 조회 (페이지네이션 + 정렬 포함)
	 * 
	 * @Select("<script>" +
	 * "SELECT * FROM products WHERE seller_id = #{sellerId} AND is_delete = FALSE"
	 * +
	 * "<if test='keyword != null and keyword != \"\"'> AND pro_name LIKE CONCAT('%', #{keyword}, '%') </if>"
	 * + "<choose>" +
	 * "   <when test='sort == \"price_high\"'> ORDER BY unit_price DESC </when>" +
	 * "   <when test='sort == \"price_low\"'> ORDER BY unit_price ASC </when>" +
	 * "   <otherwise> ORDER BY total_sales DESC </otherwise>" + "</choose>" +
	 * "LIMIT #{start}, #{count}" + "</script>") List<ProductsDto>
	 * findBySellerIdAndPage(Map<String, Object> params);
	 */
	// 상품 업데이트
	@Update("UPDATE products SET pro_name = #{proName}, inventory = #{inventory}, unit_price = #{unitPrice}, description = #{description}, is_sales = #{isSales}, img_path = #{imgPath}, regist_date = #{registDate} WHERE pro_id = #{proId}")
	void updateProduct(ProductsDto product);

	// 상품 삭제 (소프트 삭제)
	@Update("UPDATE products SET is_delete = TRUE WHERE pro_id = #{proId}")
	void deleteProduct(@Param("proId") int proId);

}

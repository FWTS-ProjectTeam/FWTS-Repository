package com.teamf.fwts.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.teamf.fwts.dto.Cart;

@Mapper
public interface BuyerCartDao {

	// ✅ 장바구니 데이터 INSERT
    @Insert("INSERT INTO carts ( buyer_id, pro_id, selected_quantity, regist_date) " +
            "VALUES (#{buyerId}, #{proId}, #{selectedQuantity}, NOW())")
    int insertCart(@Param("buyerId") int buyerId, 
                   @Param("proId") int proId, 
                   @Param("selectedQuantity") int selectedQuantity);
    
    // ✅ 기존 장바구니 조회 (전체 조회)
    @Select("SELECT c.cart_id, c.buyer_id, c.pro_id, c.selected_quantity, c.regist_date, " +
            "p.pro_name, p.unit_price, p.delivery_fee, u.ceo_name " +
            "FROM carts c " +
            "JOIN products p ON c.pro_id = p.pro_id " +
            "JOIN user_details u ON p.seller_id = u.user_id " +
            "WHERE c.buyer_id = #{buyerId} " + // 특정 구매자의 장바구니만 가져오기
            "ORDER BY c.regist_date DESC")
    List<Cart> getCartList(@Param("buyerId") int buyerId);

    // ✅ 장바구니 총 개수 조회 (페이징 처리 1단계)
    @Select("SELECT COUNT(*) FROM carts WHERE buyer_id = #{buyerId}")
    int getCartCount(@Param("buyerId") int buyerId);

    // ✅ 페이징된 장바구니 리스트 조회 (페이징 처리 2단계)
    @Select("SELECT c.cart_id, c.buyer_id, c.pro_id, c.selected_quantity, c.regist_date, " +
            "p.pro_name, p.unit_price, p.delivery_fee, u.ceo_name " +
            "FROM carts c " +
            "JOIN products p ON c.pro_id = p.pro_id " +
            "JOIN user_details u ON p.seller_id = u.user_id " +
            "WHERE c.buyer_id = #{buyerId} " +
            //"ORDER BY c.pro_id DESC " +
            "ORDER BY c.regist_date DESC " +
            "LIMIT #{offset}, #{limit}") // ✅ 페이징 적용
    List<Cart> getPagedCartList(@Param("buyerId") int buyerId, @Param("offset") int offset, @Param("limit") int limit);

   // ✅ 장바구니에서 특정 상품 삭제
   @Delete("DELETE FROM carts WHERE buyer_id = #{buyerId} AND cart_id = #{cartId}")
   int removeCartItem(@Param("buyerId") int buyerId, @Param("cartId") int cartId);
}

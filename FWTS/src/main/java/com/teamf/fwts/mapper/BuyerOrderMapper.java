package com.teamf.fwts.mapper;

import com.teamf.fwts.dto.OrderList;
import com.teamf.fwts.dto.OrderDto;
import com.teamf.fwts.dto.OrderDetail;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

@Mapper
public interface BuyerOrderMapper {
	// 주문을 위한 정보 가져오기
	@Select({"SELECT buyer.ceo_name, buyer.phone_num, buyer.postal_code, buyer.address, buyer.detail_address,", // 구매자 정보
	        "p.pro_id, p.pro_name, p.seller_id, p.unit_price, p.delivery_fee, p.min_possible,", // 상품 정보
	        "b.account_num, b.bank_name,", // 판매자 계좌번호
	        "seller.company_name", // 판매 업체 이름
	        "FROM products p",
	        "JOIN account b ON p.seller_id = b.user_id",
	        "JOIN user_details seller ON p.seller_id = seller.user_id", // 판매자 정보
	        "JOIN user_details buyer ON buyer.user_id = #{buyerId}", // 구매자 정보
	        "WHERE p.pro_id = #{proId}"})
	OrderDto getOrderNow(@Param("buyerId") int buyerId, @Param("proId") int proId);

	// 최소 주문 수량 조회
    @Select("SELECT min_possible FROM products WHERE pro_id = #{proId}")
    int getMinPossible(@Param("proId") int proId);
	
	// ✅ 사용자의 최근 배송지 가져오기
	@Select("SELECT CONCAT('(', postal_code, ') ', address, ', ', detail_address) " +
	        "FROM user_details WHERE user_id = #{buyerId}")
	String getSavedAddress(@Param("buyerId") int buyerId);

	// ✅ 새로운 배송지 업데이트 - user_details
	@Update("UPDATE user_details SET postal_code = #{postalCode}, " +
			"address = #{address}, detail_address = #{detailAddress} " +
			"WHERE user_id = #{buyerId}")
	int updateUserAddress(@Param("buyerId") int buyerId,
						  @Param("postalCode") String postalCode,
						  @Param("address") String address,
						  @Param("detailAddress") String detailAddress);
	
	// ✅ 주문 데이터 INSERT - orders
    @Insert("INSERT INTO orders (seller_id, buyer_id, pro_id, purchase_quantity, total_price, order_state, order_date, delivery_address) " +
            "VALUES (#{sellerId}, #{buyerId}, #{proId}, #{purchaseQuantity}, #{totalPrice}, 0, NOW(), #{deliveryAddress})")
    @Options(useGeneratedKeys = true, keyProperty = "orderNum") // order_num 자동 증가
    int insertOrder(OrderDto order);
    
    // ✅ 상품 재고 수량 조회
    @Select("SELECT inventory FROM products WHERE pro_id = #{proId}")
    int getInventory(@Param("proId") int proId);
    
    // ✅ 주문 성공 시, 상품 재고 차감
    @Update("UPDATE products SET inventory = inventory - #{purchaseQuantity} WHERE pro_id = #{proId} AND inventory >= #{purchaseQuantity}")
    int decreaseInventory(@Param("proId") int proId, @Param("purchaseQuantity") int purchaseQuantity);
    
    // Mybatis의 @Insert 어노테이션은 기본적으로 실행된 SQL 쿼리의 영향을 받은 행(row)의 수를 반환 -> method int로 return
    // 1이면 성공적으로 한 개의 주문이 추가된 것, 0이면 추가되지 않은 것
    // 왜 int 대신 void로 하면 안 되나? -> 가능은 하지만, 성공 여부를 알 수 없음

    // ✅ 모든 주문 정보 리스트로 조회
//    @Select("SELECT o.order_num, o.purchase_quantity, o.total_price, o.order_state, o.order_date, " +
//    		"p.pro_name " +
//    		"FROM orders o " +
//    		"JOIN products p ON o.pro_id = p.pro_id " +
//    		"WHERE o.buyer_id = #{buyerId} " +
//    		"ORDER BY o.order_date DESC") // 현재 로그인한 판매자의 아이디로 조회")
//    List<OrderList> getAllOrders(@Param("buyerId") int buyerId);
    
    // ✅ 총 주문 개수 조회 - 검색어가 없는 경우 사용
    @Select("SELECT COUNT(*) FROM orders WHERE buyer_id = #{buyerId}")
    int getOrderCount(@Param("buyerId") int buyerId);
    
//    // ✅ 페이징된 주문 리스트 조회 (페이징 처리 2단계)
//    @Select("SELECT o.order_num, p.pro_name, o.purchase_quantity, o.total_price, o.order_state, o.order_date " +
//    		"FROM orders o " +
//    		"JOIN products p ON o.pro_id = p.pro_id " +
//    		"WHERE o.buyer_id = #{buyerId} " +
//    		"ORDER BY o.order_date DESC " +
//    		"LIMIT #{offset}, #{limit}") // 한번에 10개씩 조회
//    List<OrderList> getPagedOrderList(@Param("buyerId") int buyerId, @Param("offset") int offset, @Param("limit") int limit);
    
    // ✅ 주문 상세 조회 (주문 + 상품 + 판매자 정보 + 배송 정보)
    @Select("SELECT o.order_num, o.purchase_quantity, o.total_price, o.order_state, o.order_date, o.courier, o.shipment_num, " +
            // ✅ 주문 정보 (주문 번호, 구매 수량, 구매액, 주문 및 배송 상태, 주문 날짜, 택배사, 운송장 번호)
            "p.pro_id, p.pro_name, " + // ✅ 상품 아이디, 상품명
            "Seller.company_name, Seller.ceo_name, Seller.phone_num, Seller.company_num, " + // ✅ 판매자 정보 (판매 업체명, 대표자명, 전화번호)
            // "d.delivery_address, d.delivery_detail_address " + // ✅ 배송 정보 (주소, 상세 주소)
            "o.delivery_address " + // ✅ 주문 당시 배송지
            "FROM orders o " +
            // "JOIN user_details Buyer ON Buyer.user_id = o.buyer_id " + // 구매자 아이디 조인
            "JOIN products p ON o.pro_id = p.pro_id " + // ✅ 상품 조인
            "JOIN user_details Seller ON o.seller_id = Seller.user_id " + // ✅ 판매자 상세 정보 조인 (user_detail에서 조인)
            // "LEFT JOIN delivery_destination d ON o.delivery_id = d.delivery_id " + // ✅ 배송 정보 조인 (LEFT JOIN: 일부 주문에 배송 정보가 없을 수 있음)
            "WHERE o.order_num = #{orderNum}") // ✅ 특정 주문 번호(orderNum)로 검색
    OrderDetail getOrderWithProducts(@Param("orderNum") String orderNum); // 특정 주문 (NOT List) : OrderDetail (DTO)
    
    // ✅ 전체 주문 목록 조회 (엑셀 다운로드용)
    @Select("SELECT o.order_num, o.order_date, o.purchase_quantity, o.total_price, " +
            "p.pro_id, p.pro_name, Seller.company_name " +
            "FROM orders o " +
            "JOIN products p ON o.pro_id = p.pro_id " +
            "JOIN user_details Seller ON o.seller_id = Seller.user_id " +
            "WHERE o.buyer_id = #{buyerId} " +
    		"ORDER BY o.order_date DESC") // ✅ 최신 주문 먼저 조회
    List<OrderDetail> getAllOrdersForExcel(@Param("buyerId") int buyerId);
    
    
    // ✅ 주문 목록 조회 (검색어 + 페이징 적용)
    @Select("<script>" +
            "SELECT o.order_num, o.purchase_quantity, o.total_price, o.order_state, o.order_date, " +
            "p.pro_name " +
            "FROM orders o " +
            "JOIN products p ON o.pro_id = p.pro_id " +
            "WHERE o.buyer_id = #{buyerId} " +
            "<if test='searchKeyword != null and searchKeyword != \"\"'>" +
            "AND p.pro_name LIKE #{searchKeyword} " + // 검색어가 입력되었을 떄 추가 조건
            // 사용자가 searchKeyword를 입력하면 상품명 기준으로 검색하도록 like 조건 추가
            "</if>" +
            "ORDER BY o.order_date DESC " +
            "LIMIT #{offset}, #{pageSize}" + // 페이징 적용, LIMIT를 사용해 페이징당 데이터 개수 제한
            "</script>")
    List<OrderList> getOrdersWithPagination(@Param("buyerId") int buyerId, 
                                            @Param("searchKeyword") String searchKeyword,
                                            @Param("offset") int offset, 
                                            @Param("pageSize") int pageSize);

    // ✅ 검색어가 있는 경우 검색된 총 개수 조회, 없으면 전체 주문 개수 조회
    @Select("<script>" +
            "SELECT COUNT(*) FROM orders o " +
            "JOIN products p ON o.pro_id = p.pro_id " +
            "WHERE o.buyer_id = #{buyerId} " +
            "<if test='searchKeyword != null and searchKeyword != \"\"'>" +
            "AND p.pro_name LIKE #{searchKeyword} " + // 검색어가 있는 경우 검색 적용, 없으면 이 부분이 쿼리에서 빠지고 전체 개수를 조회
            "</if>" +
            "</script>")
    int getTotalOrderCount(@Param("buyerId") int buyerId, @Param("searchKeyword") String searchKeyword);
    
    
    // List<Map<S, O>> 형태인 이유
    // : 하나의 주문(order_num)이 여러 개의 상품을 포함할 수 있기 때문)
    // @Param("orderNum) : Mybatis에서 SQL 쿼리 내
    // #{orderNum}과 메서드의 orderNum 매개변수를 매핑하기 위함
    
    
}

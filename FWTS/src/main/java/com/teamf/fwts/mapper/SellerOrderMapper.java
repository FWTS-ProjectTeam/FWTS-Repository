package com.teamf.fwts.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.teamf.fwts.dto.OrderList;
import com.teamf.fwts.dto.OrderDetail;

@Mapper
public interface SellerOrderMapper {
    // ✅ 총 주문 개수 조회 (페이징 처리 1단계)
    @Select("SELECT COUNT(*) FROM orders WHERE seller_id = #{sellerId}")
    int getOrderCount(@Param("sellerId") int sellerId);
     
    // ✅ 주문 상세 조회 (주문 + 상품 + 구매자 정보 + 배송 정보)
    @Select("SELECT o.order_num, o.purchase_quantity, o.total_price, o.order_state, o.order_date, o.courier, o.shipment_num, " +
            // ✅ 주문 정보 (주문 번호, 구매 수량, 구매액, 주문 및 배송 상태, 주문 날짜, 택배사, 운송장 번호)
            "p.pro_id, p.pro_name, " + // ✅ 상품 아이디, 상품명
            "ud.company_name, ud.ceo_name, ud.phone_num, ud.company_num, " + // ✅ 구매자 정보 (판매 업체명, 대표자명, 전화번호)
            "o.delivery_address " + // ✅ 구매자 배송 정보 (주소, 상세 주소)
            "FROM orders o " +
            "JOIN products p ON o.pro_id = p.pro_id " + // ✅ 상품 조인
            "JOIN user_details ud ON o.buyer_id = ud.user_id " + // ✅ 구매자 상세 정보 조인 (user_detail에서 조인)
            // "LEFT JOIN delivery_destination d ON o.delivery_id = d.delivery_id " + // ✅ 배송 정보 조인 (LEFT JOIN: 일부 주문에 배송 정보가 없을 수 있음)
            "WHERE o.order_num = #{orderNum}") // ✅ 특정 주문 번호(orderNum)로 검색
    OrderDetail getOrderWithProducts(@Param("orderNum") String orderNum);

    // ✅ 판매자가 주문 상태 변경
    @Update("UPDATE orders SET order_state = #{orderState} WHERE order_num = #{orderNum}")
    void updateOrderState(@Param("orderNum") String orderNum, @Param("orderState") int orderState);
    
    // ✅ 판매자가 운송 정보 입력
    @Update("UPDATE orders SET courier = #{courier}, shipment_num = #{shipmentNum} WHERE order_num = #{orderNum}")
    void updateShipmentInfo(@Param("orderNum") String orderNum,
    						@Param("courier") String courier,
    						@Param("shipmentNum") String shipmentNum);
    // Update를 사용하는 이유 : 판매자가 입력할 때는 새로운 데이터를 추가하는 것이 아닌,
    // 기존 주문 데이터(row)에 값을 갱신(update)하는 것이기 때문
    
    // ✅ 전체 주문 목록 조회 (엑셀 다운로드용)
    @Select("SELECT o.order_num, o.order_date, o.purchase_quantity, o.total_price, " +
            "p.pro_id, p.pro_name, Buyer.company_name " +
            "FROM orders o " +
            "JOIN products p ON o.pro_id = p.pro_id " +
            "JOIN user_details Buyer ON o.buyer_id = Buyer.user_id " +
            "WHERE o.seller_id = #{sellerId} " +
            "ORDER BY o.order_date DESC") // ✅ 최신 주문 먼저 조회
    List<OrderDetail> getAllOrdersForExcel(@Param("sellerId") int sellerId);
    
    
    @Select("<script>" +
    	    "SELECT o.order_num, o.purchase_quantity, o.total_price, o.order_state, o.order_date, " +
    	    "p.pro_name " +
    	    "FROM orders o " +
    	    "JOIN products p ON o.pro_id = p.pro_id " +
    	    "WHERE o.seller_id = #{sellerId} " +

    	    // ✅ 상품명 검색 (CONCAT 사용)
    	    "<if test='searchKeyword != null and searchKeyword != \"\"'> " +
    	    "AND p.pro_name LIKE CONCAT('%', #{searchKeyword}, '%') " +
    	    "</if> " +

    	    // ✅ 날짜 검색 (CDATA 사용)
    	    "<if test='startDate != null and startDate != \"\"'> " +
    	    "AND o.order_date <![CDATA[ >= ]]> #{startDate} " +
    	    "</if> " +
    	    "<if test='endDate != null and endDate != \"\"'> " +
    	    "AND o.order_date <![CDATA[ < ]]> DATE_ADD(#{endDate}, INTERVAL 1 DAY) " +
    	    "</if> " +

    	    "ORDER BY o.order_date DESC " +
    	    "LIMIT #{offset}, #{pageSize} " +
    	    "</script>")
    	List<OrderList> getOrdersWithPagination(@Param("sellerId") int sellerId, 
    	                                        @Param("searchKeyword") String searchKeyword,
    	                                        @Param("startDate") String startDate,
    	                                        @Param("endDate") String endDate,
    	                                        @Param("offset") int offset, 
    	                                        @Param("pageSize") int pageSize);

    @Select("<script>" +
    	    "SELECT COUNT(*) FROM orders o " +
    	    "JOIN products p ON o.pro_id = p.pro_id " +
    	    "WHERE o.seller_id = #{sellerId} " +

    	    // ✅ 상품명 검색 (LIKE 사용)
    	    "<if test='searchKeyword != null and searchKeyword != \"\"'> " +
    	    "AND p.pro_name LIKE CONCAT('%', #{searchKeyword}, '%') " +
    	    "</if> " +

    	    // ✅ 날짜 조건 추가 (CDATA 사용)
    	    "<if test='startDate != null and startDate != \"\"'> " +
    	    "AND o.order_date <![CDATA[ >= ]]> #{startDate} " +
    	    "</if> " +
    	    "<if test='endDate != null and endDate != \"\"'> " +
    	    "AND o.order_date <![CDATA[ < ]]> DATE_ADD(#{endDate}, INTERVAL 1 DAY) " +
    	    "</if> " +

    	    "</script>")
    	int getTotalOrderCount(@Param("sellerId") int sellerId,
    	                       @Param("searchKeyword") String searchKeyword,
    	                       @Param("startDate") String startDate,
    	                       @Param("endDate") String endDate);   
}
package com.teamf.fwts.service;

import java.util.List;
import org.springframework.stereotype.Service;
import com.teamf.fwts.dao.SellerOrderDao;
import com.teamf.fwts.dto.OrderList;
import com.teamf.fwts.dto.OrderDetail;

@Service
public class SellerOrderService {
	
    private final SellerOrderDao orderDao;

    public SellerOrderService(SellerOrderDao orderDao) {
        this.orderDao = orderDao;
    }

//    // ✅ 기존: 모든 주문 목록 조회
//    public List<OrderList> getAllOrders(int sellerId) {
//       return orderDao.getAllOrders(sellerId);
//    }
//    
    // ✅ 총 주문 개수 조회 (페이징 처리에 필요)
    public int getOrderCount(int sellerId) {
    	return orderDao.getOrderCount(sellerId);
    }
    
//    // ✅ 페이징된 주문 목록 조회
//    public List<OrderList> getPagedOrderList(int sellerId, int offset, int limit){
//    	return orderDao.getPagedOrderList(sellerId, offset, limit);
//    }
    
    // ✅ 주문 상세 조회
    public OrderDetail getOrderWithProducts(String orderNum) {
    	return orderDao.getOrderWithProducts(orderNum);
    }
    
    // ✅ 주문 상태 업데이트
    public void updateOrderState(String orderNum, int orderState) {
        orderDao.updateOrderState(orderNum, orderState);
    }
    
    // ✅ 택배사/운송장 번호 업데이트
    public void updateShipmentInfo(String orderNum, String courier, String shipmentNum) {
    	orderDao.updateShipmentInfo(orderNum, courier, shipmentNum);
    }
    
    // ✅ 전체 주문 내역 조회 (엑셀 다운로드용)
    public List<OrderDetail> getAllOrdersForExcel(int sellerId) {
        return orderDao.getAllOrdersForExcel(sellerId);
    }

    // ✅ 검색어 처리
    public List<OrderList> getOrdersWithPagination(int sellerId, String searchKeyword, int offset, int pageSize) {
        if (searchKeyword != null && !searchKeyword.isEmpty()) {
            searchKeyword = "%" + searchKeyword + "%"; // LIKE 검색을 위해 % 추가
        }
        return orderDao.getOrdersWithPagination(sellerId, searchKeyword, offset, pageSize);
    }

    public int getTotalOrderCount(int sellerId, String searchKeyword) {
        if (searchKeyword != null && !searchKeyword.isEmpty()) {
            searchKeyword = "%" + searchKeyword + "%";
        }
        return orderDao.getTotalOrderCount(sellerId, searchKeyword);
    }
}

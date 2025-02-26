package com.teamf.fwts.service;

import java.util.List;
import org.springframework.stereotype.Service;

import com.teamf.fwts.dto.OrderList;
import com.teamf.fwts.mapper.SellerOrderMapper;

import lombok.RequiredArgsConstructor;

import com.teamf.fwts.dto.OrderDetail;

@RequiredArgsConstructor 
@Service
public class SellerOrderService {
	
    private final SellerOrderMapper orderMapper;

//    // ✅ 기존: 모든 주문 목록 조회
//    public List<OrderList> getAllOrders(int sellerId) {
//       return orderDao.getAllOrders(sellerId);
//    }
//    
    // ✅ 총 주문 개수 조회 (페이징 처리에 필요)
    public int getOrderCount(int sellerId) {
    	return orderMapper.getOrderCount(sellerId);
    }
    
//    // ✅ 페이징된 주문 목록 조회
//    public List<OrderList> getPagedOrderList(int sellerId, int offset, int limit){
//    	return orderDao.getPagedOrderList(sellerId, offset, limit);
//    }
    
    // ✅ 주문 상세 조회
    public OrderDetail getOrderWithProducts(String orderNum) {
    	return orderMapper.getOrderWithProducts(orderNum);
    }
    
    // ✅ 주문 상태 업데이트
    public void updateOrderState(String orderNum, int orderState) {
        orderMapper.updateOrderState(orderNum, orderState);
    }
    
    // ✅ 택배사/운송장 번호 업데이트
    public void updateShipmentInfo(String orderNum, String courier, String shipmentNum) {
    	orderMapper.updateShipmentInfo(orderNum, courier, shipmentNum);
    }
    
    // ✅ 전체 주문 내역 조회 (엑셀 다운로드용)
    public List<OrderDetail> getAllOrdersForExcel(int sellerId) {
        return orderMapper.getAllOrdersForExcel(sellerId);
    }

 // ✅ 검색어 처리 (페이징을 적용한 주문 목록을 가져오는 역할)
    // 검색어가 있을 경우 like 연산자 이용하여 검색어 반환
	public List<OrderList> getOrdersWithPagination(int sellerId, String searchKeyword,
	            String startDate, String endDate,
	            int offset, int pageSize) {
		// ✅ 검색어가 있으면 LIKE 검색을 위해 % 추가
		if (searchKeyword != null && !searchKeyword.isEmpty()) {
			searchKeyword = "%" + searchKeyword + "%";
		}
	
		// ✅ 날짜 값이 빈 문자열이면 null 처리
		if (startDate != null && startDate.isEmpty()) {
			startDate = null;
		}
		if (endDate != null && endDate.isEmpty()) {
			endDate = null;
		}
	
		return orderMapper.getOrdersWithPagination(sellerId, searchKeyword, startDate, endDate, offset, pageSize);
	}


    // ✅ 검색 조건에 맞는 전체 주문 개수를 가져옴 ; 페이징 계산을 위해 사용
    // 1. 검색어가 있을 경우 like 연산자 통해서 검색 조건 추가
    // 2. 검색어가 없을 경우 전체 주문 개수 조회
    // 3. 전체 개수를 반환 -> 이를 사용해 총 페이지 수 계산 가능
    public int getTotalOrderCount(int sellerId, String searchKeyword, String startDate, String endDate) {
        if (searchKeyword != null && !searchKeyword.isEmpty()) {
            searchKeyword = "%" + searchKeyword + "%";
        }
        
        // ✅ 날짜 값이 빈 문자열이면 null 처리
        if (startDate != null && startDate.isEmpty()) {
            startDate = null;
        }
        if (endDate != null && endDate.isEmpty()) {
            endDate = null;
        }
        return orderMapper.getTotalOrderCount(sellerId, searchKeyword, startDate, endDate);
    }
}

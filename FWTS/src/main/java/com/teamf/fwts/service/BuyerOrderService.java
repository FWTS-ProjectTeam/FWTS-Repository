package com.teamf.fwts.service;

import com.teamf.fwts.dto.OrderList;
import com.teamf.fwts.dto.OrderDto;
import com.teamf.fwts.mapper.BuyerCartMapper;
import com.teamf.fwts.mapper.BuyerOrderMapper;

import lombok.RequiredArgsConstructor;

import com.teamf.fwts.dto.OrderDetail;
import org.springframework.stereotype.Service;
import java.util.List;

@RequiredArgsConstructor // private final 자동 추가
@Service
public class BuyerOrderService {
	// 생성자 주입
    private final BuyerOrderMapper orderMapper;
    private final BuyerCartMapper cartMapper;
    
    // ✅ 상품 주문
    public OrderDto getOrderNow(int buyerId, int proId) {
    	return orderMapper.getOrderNow(buyerId, proId);
    }
    
    // 상품 데이터 삽입
    public boolean placeOrder(int buyerId, int cartId, int proId, int purchaseQuantity, int totalPrice, 
            				  String postalCode, String address, String addressDetail) {
		// 주문 정보 조회 (판매자 및 상품 정보 포함)
    	OrderDto order = orderMapper.getOrderNow(buyerId, proId);
		
		if (order == null) {
			return false; // 상품 정보 조회 실패
		}
		
		// ✅ 현재 상품의 재고 확인
	    int currentStock = orderMapper.getInventory(proId);
	    int minPossible = orderMapper.getMinPossible(proId);
	    if (purchaseQuantity > currentStock) {
	        System.out.println("❌ 재고 부족으로 주문 실패! (proId: " + proId + ", 남은 재고: " + currentStock + ")");
	        return false; // 🚨 재고 부족으로 주문을 취소
	    } else if (purchaseQuantity < minPossible) {
          System.out.println("실패");
          return false; 
       }
		
		// ✅ 주문 객체 생성 및 정보 설정
		order.setBuyerId(buyerId);
		order.setProId(proId);
		order.setSellerId(order.getSellerId()); 
		order.setPurchaseQuantity(purchaseQuantity);
		order.setTotalPrice(totalPrice);
		
		// ✅ 배송지 설정 (입력값이 없으면 기존 주소 사용)
		String deliveryAddress;
		if (postalCode != null && !postalCode.isEmpty()) {
			// 사용자가 새로운 배송지를 입력했다면 해당 값을 사용
			deliveryAddress = "(" + postalCode + ") " + address;
			if (!addressDetail.isBlank())
				deliveryAddress += ", " + addressDetail;
			// ✅ 새로운 배송지를 하나의 문자열로 변환하여 사용자의 주소 정보 업데이트
			
			// user_details 테이블의 기존 주소를 새 주소로 업데이트
			orderMapper.updateUserAddress(buyerId, postalCode, address, addressDetail);
		} else {
			// 만일 사용자가 새로운 배송지를 입력하지 않을 시 기존 저장된 배송지 사용
			// user_details 테이블에서 가장 최근에 저장된 주소 불러오기
			deliveryAddress = orderMapper.getSavedAddress(buyerId);
		}
		// deliveryAddress(최근 배송지)를 주문 객체에 저장
		order.setDeliveryAddress(deliveryAddress);
		
		// ✅ 주문 정보 DB 저장	
		// > 0 조건을 통해 1개 이상의 행이 삽입되었는지 확인하여 성공 여부를 반환
		boolean orderSuccess = orderMapper.insertOrder(order) > 0;
		
		if(orderSuccess) {
			// ✅ 주문 성공 시 재고 감소
			int updatedRows = orderMapper.decreaseInventory(proId, purchaseQuantity);
			if (updatedRows == 0) {
				System.out.println("❌ 재고 부족으로 차감 실패 (proId: " + proId + ")");
				return false; // 재고가 부족한 경우 주문을 취소
			}

			// ✅ 장바구니에서 주문한 경우, 해당 상품 삭제
			if (cartId > 0) { 
				System.out.println(cartId);
				int deletedRows = cartMapper.removeCartItem(buyerId, cartId);
				System.out.println("🛒 장바구니 삭제 결과 - 삭제된 행 개수: " + deletedRows);
			}
		}
		
		return orderSuccess;	
	}
    
    // ✅ 주문 상세 조회
    public OrderDetail getOrderWithProducts(String orderNum) {
    		return orderMapper.getOrderWithProducts(orderNum);
    }
    
    // ✅ 전체 주문 내역 조회 (엑셀 다운로드용)
    public List<OrderDetail> getAllOrdersForExcel(int buyerId) {
        return orderMapper.getAllOrdersForExcel(buyerId);
    }
    
    // ✅ 검색어 처리 (페이징을 적용한 주문 목록을 가져오는 역할)
    // 검색어가 있을 경우 like 연산자 이용하여 검색어 반환
	public List<OrderList> getOrdersWithPagination(int buyerId, String searchKeyword,
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
	
		return orderMapper.getOrdersWithPagination(buyerId, searchKeyword, startDate, endDate, offset, pageSize);
	}


    // ✅ 검색 조건에 맞는 전체 주문 개수를 가져옴 ; 페이징 계산을 위해 사용
    // 1. 검색어가 있을 경우 like 연산자 통해서 검색 조건 추가
    // 2. 검색어가 없을 경우 전체 주문 개수 조회
    // 3. 전체 개수를 반환 -> 이를 사용해 총 페이지 수 계산 가능
    public int getTotalOrderCount(int buyerId, String searchKeyword, String startDate, String endDate) {
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
        return orderMapper.getTotalOrderCount(buyerId, searchKeyword, startDate, endDate);
    }
}
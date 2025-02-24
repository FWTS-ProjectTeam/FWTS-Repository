package com.teamf.fwts.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor // 모든 필드를 포함한 생성자 자동 생성
@NoArgsConstructor // 기본 생성자(매개변수 없음) 자동 생성
@Data
public class OrderDetail { // 주문 상세
	private String orderNum;
	private int purchaseQuantity;
	private int totalPrice;
	private int orderState;
	private LocalDateTime orderDate; //주문 날짜
	private String courier; // 택배사
	private String shipmentNum; // 송장 번호
	
	private int proId; // 상품 아이디
	private String proName; // 상품명
	
	private int sellerId; // 판매자 아이디
	private String companyName; // 판매 업체명
	private String ceoName; // 판매업체 대표명
	private String phoneNum; // 판매자 연락처
    private String companyNum; // 판매업체 번호
    
    private String postalCode;
	private String address;
	private String addressDetail;
	
	private String deliveryAddress; // 주문 당시 사용한 배송지
    
//    private String deliveryAddress; // 구매자 주소
//    private String deliveryDetailAddress; // 구매자 상세 주소
    
}

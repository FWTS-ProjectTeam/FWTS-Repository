package com.teamf.fwts.dto;

import lombok.Data;

//@AllArgsConstructor // 모든 필드를 포함한 생성자 자동 생성
//@NoArgsConstructor // 기본 생성자(매개변수 없음) 자동 생성
@Data
public class OrderDto {
	// 구매자 정보
	private int buyerId;
	private String ceoName;
	private String phoneNum;
	
	private String postalCode;
	private String address;
	private String detailAddress;
	
	// 배송 주소
	private String deliveryAddress;
	
	// 주문 상품
	private int orderNum;
	private int proId;
	private String proName;
	private int unitPrice;
	private int deliveryFee;
	private int inventory;
	
	// 입금할 계좌
	private int sellerId;
	private String accountNum;
	private String bankName;
	private String companyName;
	
	// 결제 정보
	private int purchaseQuantity;
	private int totalPrice;
	
	// 장바구니 아이디
	private int cartId;
}
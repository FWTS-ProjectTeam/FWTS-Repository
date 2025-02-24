package com.teamf.fwts.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

//@AllArgsConstructor // 모든 필드를 포함한 생성자 자동 생성
//@NoArgsConstructor // 기본 생성자(매개변수 없음) 자동 생성
@Data
public class OrderNow {
	
	// 구매자 정보
	private int buyerId;
	private String ceoName;
	private String phoneNum;
	
	private String deliveryAddress; // 배송 주소
	private String deliveryDetailAddress; // 배송 상세 주소
	private String postalCode;
	private String address;
	private String addressDetail;
	
	
	// 주문 상품
	private int orderNum;
	private int proId;
	private String proName;
	
	// 입금할 계좌
	private int sellerId;
	private String accountNum;
	private String bankName;
	private String companyName;
	
	// 결제 금액
	private int purchaseQuantity;
	private int totalPrice;
	
	// 장바구니 아이디
	private int cartId;
	
	private int inventory;
}

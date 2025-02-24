package com.teamf.fwts.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor // 모든 필드를 포함한 생성자 자동 생성
@NoArgsConstructor // 기본 생성자(매개변수 없음) 자동 생성
@Data
public class OrderList { // 주문 내역
	private String orderNum; // 주문 번호
	private int purchaseQuantity; // 구매 수량
	private int totalPrice; // 구매 총액
	private int orderState; // 주문 및 배송 상태
	private String proName; // 상품명
}

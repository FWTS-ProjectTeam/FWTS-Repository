package com.teamf.fwts.dto;

import lombok.Data;

@Data
public class DeliveryDestination {
	private int deliveryId; // 배송지 id
	private int buyerId; // 구매자 id
	private String postalCode; // 우편 번호
	private String deliveryAddress; // 배송 주소
	private String deliveryDetailAddress; // 배송 상세 주소
	private boolean isDefault; // 기본 배송지 여부
}

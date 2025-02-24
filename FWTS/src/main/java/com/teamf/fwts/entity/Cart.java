package com.teamf.fwts.entity;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class Cart {
	private int cartId;
	private int buyerId;
	private int proId;
	private int selectedQuantity;
	private LocalDateTime registDate;
	
	private int sellerId;
	
	private String proName;
	private int unitPrice;
	private int deliveryFee;
	private int totalPricw;
}

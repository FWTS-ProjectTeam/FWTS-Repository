package com.teamf.fwts.dto;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

import lombok.Data;

@Data
public class ProductsDto {
    private int proId;             // 상품 ID
    private int sellerId;          // 판매자 ID
    private int categoryId;        // 카테고리 ID
    private int colorId;           // 색상 ID
    private String proName;        // 상품 이름
    private int inventory;         // 재고
    private int maxPossible;       // 최대 가능 수량
    private int minPossible;       // 최소 가능 수량
    private int unitPrice;         // 단가
    private boolean isSales;       // 판매 중 여부
    private String description;    // 상품 설명
    private int totalSales;        // 총 판매 수량
    private String imgPath;        // 이미지 경로
    private LocalDateTime registDate; // 등록 일자
    private boolean isDelete;      // 삭제 여부
    private int deliveryFee;       // 배송비

    public boolean isSales() {
        return isSales;
    }

    public Date getFormattedDate() {
        return registDate != null ? Date.from(registDate.atZone(ZoneId.systemDefault()).toInstant()) : null;
    }
    
    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }
} 
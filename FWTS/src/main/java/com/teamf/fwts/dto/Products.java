package com.teamf.fwts.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor // 모든 필드를 포함한 생성자 자동 생성
@NoArgsConstructor // 기본 생성자(매개변수 없음) 자동 생성
public class Products {
    private int proId;
    private int sellerId;
    private int categoryId;
    private int colorId;
    private String proName;
    private int inventory;
    private int maxPossible;
    private int minPossible;
    private int unitPrice;
    private int deliveryFee;
    private boolean isSales;
    private String description;
    private int totalSales;
    private String imgPath;
    private LocalDateTime registDate;
    private boolean isDelete;
}

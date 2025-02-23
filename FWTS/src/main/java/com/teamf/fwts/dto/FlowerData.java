package com.teamf.fwts.dto;

import lombok.Getter;

@Getter
public class FlowerData {
    private int avgPrice; // 평균 가격
    private int totalQty; // 총 판매량

    public FlowerData(int avgPrice, int totalQty) {
        this.avgPrice = avgPrice;
        this.totalQty = totalQty;
    }
}
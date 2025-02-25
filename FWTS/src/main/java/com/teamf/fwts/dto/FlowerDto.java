package com.teamf.fwts.dto;

import lombok.Getter;

@Getter
public class FlowerDto {
    private int avgPrice; // 평균 가격
    private int totalQty; // 총 판매량

    public FlowerDto(int avgPrice, int totalQty) {
        this.avgPrice = avgPrice;
        this.totalQty = totalQty;
    }
}
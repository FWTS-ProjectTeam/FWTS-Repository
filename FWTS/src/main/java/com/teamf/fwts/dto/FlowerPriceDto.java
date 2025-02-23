package com.teamf.fwts.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter @Setter
@JsonIgnoreProperties(ignoreUnknown = true)
public class FlowerPriceDto {
    @JsonProperty("response")
    private ResponseData response;

    @Getter @Setter
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class ResponseData {
        @JsonProperty("resultCd")
        private String resultCode;

        @JsonProperty("resultMsg")
        private String resultMessage;

        @JsonProperty("numOfRows")
        private int numOfRows;

        @JsonProperty("items")
        private List<FlowerPriceItem> items;
    }

    @Getter @Setter
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class FlowerPriceItem {
        @JsonProperty("saleDate")
        private String saleDate;

        @JsonProperty("flowerGubn")
        private String flowerGubn;

        @JsonProperty("pumName")
        private String pumName;

        @JsonProperty("goodName")
        private String goodName;

        @JsonProperty("lvNm")
        private String lvNm;

        @JsonProperty("maxAmt")
        private int maxAmt;

        @JsonProperty("minAmt")
        private int minAmt;

        @JsonProperty("avgAmt")
        private int avgAmt;

        @JsonProperty("totAmt")
        private int totAmt;

        @JsonProperty("totQty")
        private int totQty;
    }
}
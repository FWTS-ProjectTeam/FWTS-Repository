package com.teamf.fwts.service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.teamf.fwts.dto.FlowerData;
import com.teamf.fwts.dto.FlowerPriceDto;

@Service
public class FlowerPriceService {
	@Value("${flower.api.url}")
    private String API_URL;

    @Value("${flower.api.key}")
    private String SERVICE_KEY;
    
    // 데이터를 Map 형태로 변환하여 반환
    public Map<String, FlowerData> getFlowerPricesByType(String flowerType) throws Exception {
    	List<String> dates = getRecent3Dates();
        Map<String, Integer> priceSum = new HashMap<>();
        Map<String, Integer> qtySum = new HashMap<>();
        Map<String, Integer> countMap = new HashMap<>();

        for (String date : dates) {
            String requestUrl = String.format("%s?kind=f001&serviceKey=%s&baseDate=%s&flowerGubn=%s&dataType=json&countPerPage=999",
                    API_URL, SERVICE_KEY, date, flowerType);

            RestTemplate restTemplate = new RestTemplate();
            ResponseEntity<String> response = restTemplate.getForEntity(requestUrl, String.class);
            ObjectMapper objectMapper = new ObjectMapper();
            FlowerPriceDto flowerPriceResponse = objectMapper.readValue(response.getBody(), FlowerPriceDto.class);

            if (flowerPriceResponse.getResponse() != null && flowerPriceResponse.getResponse().getItems() != null) {
                for (FlowerPriceDto.FlowerPriceItem item : flowerPriceResponse.getResponse().getItems()) {
                    String key = item.getPumName() + " (" + item.getGoodName() + ")";
                    int avgPrice = item.getAvgAmt();
                    int qty = item.getTotQty(); // 총 거래량

                    priceSum.put(key, priceSum.getOrDefault(key, 0) + avgPrice);
                    qtySum.put(key, qtySum.getOrDefault(key, 0) + qty);
                    countMap.put(key, countMap.getOrDefault(key, 0) + 1);
                }
            }
        }

        // 평균 가격 & 총 판매량 계산
        Map<String, FlowerData> aggregatedData = new HashMap<>();
        for (String key : priceSum.keySet()) {
            int avgPrice = priceSum.get(key) / countMap.get(key);
            int totalQty = qtySum.get(key);  // 총 판매량
            aggregatedData.put(key, new FlowerData(avgPrice, totalQty));
        }

        return aggregatedData;
    }
    
    // Map<String, Integer> 형태의 원데이터를 받아서, 괄호 앞의 품목명으로 그룹화한 후 평균 가격을 계산하는 메소드
    public Map<String, FlowerData> calculateAveragedData(Map<String, FlowerData> rawData) {
        Map<String, Integer> priceSum = new HashMap<>();
        Map<String, Integer> qtySum = new HashMap<>();
        Map<String, Integer> countMap = new HashMap<>();

        for (Map.Entry<String, FlowerData> entry : rawData.entrySet()) {
            String fullName = entry.getKey();  // 예: "튜립 (망고참)"
            FlowerData data = entry.getValue();

            // 괄호 이전 품목명 추출 ("튜립 (망고참)" -> "튜립")
            String category = fullName.split(" \\(")[0];

            priceSum.put(category, priceSum.getOrDefault(category, 0) + data.getAvgPrice());
            qtySum.put(category, qtySum.getOrDefault(category, 0) + data.getTotalQty());
            countMap.put(category, countMap.getOrDefault(category, 0) + 1);
        }

        Map<String, FlowerData> averagedData = new HashMap<>();
        for (String category : priceSum.keySet()) {
            int avgPrice = priceSum.get(category) / countMap.get(category);
            int totalQty = qtySum.get(category);  // 판매량은 평균이 아니라 총합 유지
            averagedData.put(category, new FlowerData(avgPrice, totalQty));
        }

        return averagedData;
    }

    // 최근 3일 날짜를 반환하는 메서드
    private List<String> getRecent3Dates() {
        List<String> dates = new ArrayList<>();
        LocalDate today = LocalDate.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        // 어제, 그제, 3일 전
        for (int i = 1; i <= 3; i++) {
            dates.add(today.minusDays(i).format(formatter));
        }
        return dates;
    }

}
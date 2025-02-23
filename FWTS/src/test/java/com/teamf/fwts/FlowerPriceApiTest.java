package com.teamf.fwts;

import static org.junit.jupiter.api.Assertions.assertNotNull;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.teamf.fwts.dto.FlowerPriceDto;

@SpringBootTest
public class FlowerPriceApiTest {
	@Value("${flower.api.url}")
    private String apiUrl;

    @Value("${flower.api.key}")
    private String serviceKey;

    private String getYesterdayDate() {
        LocalDate yesterday = LocalDate.now().minusDays(1);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        return yesterday.format(formatter);
    }

    @Test
    public void testGetYesterdayCutFlowerData() throws Exception {
        String baseDate = getYesterdayDate();
        String requestUrl = String.format("%s?kind=f001&serviceKey=%s&baseDate=%s&flowerGubn=1&dataType=json&countPerPage=999",
                apiUrl, serviceKey, baseDate);

        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> response = restTemplate.getForEntity(requestUrl, String.class);

        System.out.println("API 응답: " + response.getBody());

        // 응답 데이터가 null이 아닌지 확인
        assertNotNull(response.getBody(), "API 응답이 null이어선 안됩니다.");

        // JSON을 DTO로 변환
        ObjectMapper objectMapper = new ObjectMapper();
        FlowerPriceDto flowerPriceResponse = objectMapper.readValue(response.getBody(), FlowerPriceDto.class);

        // 변환된 객체 출력
        if (flowerPriceResponse.getResponse() != null && flowerPriceResponse.getResponse().getItems() != null) {
            for (FlowerPriceDto.FlowerPriceItem item : flowerPriceResponse.getResponse().getItems()) {
                System.out.println("품목명: " + item.getPumName() +
                        ", 품종명: " + item.getGoodName() +
                        ", 평균가: " + item.getAvgAmt() + "원");
            }
        }
    }
}

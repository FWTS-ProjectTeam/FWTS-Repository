package com.teamf.fwts.service;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

@Service
public class NTSService {
    private final OkHttpClient client = new OkHttpClient();
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Value("${nts.api.url}")
    private String API_URL;

    @Value("${nts.api.key}")
    private String SERVICE_KEY;

    public boolean checkBusinessValidity(String businessNo, String ceoName, String openingDate) {
        try {
            String encodedServiceKey = URLEncoder.encode(SERVICE_KEY, StandardCharsets.UTF_8);
            String url = API_URL + "?serviceKey=" + encodedServiceKey + "&returnType=JSON";

            // 요청 JSON 생성
            String jsonRequest = "{ \"businesses\": [ { " +
                    "\"b_no\": \"" + businessNo.replace("-", "") + "\", " +
                    "\"start_dt\": \"" + openingDate + "\", " +
                    "\"p_nm\": \"" + ceoName + "\" " +
                    "} ] }";
            
            RequestBody requestBody = RequestBody.create(jsonRequest, MediaType.get("application/json; charset=utf-8"));

            Request request = new Request.Builder()
                    .url(url)  // API URL
                    .post(requestBody)  // 🚀 POST 방식으로 요청
                    .addHeader("Content-Type", "application/json")
                    .build();

            try (Response response = client.newCall(request).execute()) {
                if (!response.isSuccessful()) {
                    return false;
                }

                // JSON 응답 파싱
                JsonNode rootNode = objectMapper.readTree(response.body().string());
                if (!"OK".equals(rootNode.path("status_code").asText())) {
                    return false;
                }

                // 데이터 리스트 가져오기
                JsonNode dataNode = rootNode.path("data");
                if (!dataNode.isArray() || dataNode.isEmpty()) {
                    return false;
                }

                // 사업자 유효성 체크 (valid == "01"이면 정상)
                String validCode = dataNode.get(0).path("valid").asText();
                return "01".equals(validCode);
            }
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
}
package com.teamf.fwts.util;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

public class HtmlUtils {
    // HTML에서 텍스트 또는 이미지가 있는지 확인
    public static boolean containsContent(String html) {
        if (html == null || html.trim().isEmpty()) {
            return false;
        }

        // HTML 파싱
        Document document = Jsoup.parse(html);
        
        // 텍스트 내용 가져오기
        String plainText = document.text().trim();

        // 이미지 태그 존재 여부 확인
        boolean hasImage = !document.select("img").isEmpty();

        // 텍스트가 있거나 이미지가 있으면 true 반환
        return !plainText.isEmpty() || hasImage;
    }
}
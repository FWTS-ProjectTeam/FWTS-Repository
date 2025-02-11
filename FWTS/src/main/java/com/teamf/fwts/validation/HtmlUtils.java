package com.teamf.fwts.validation;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

public class HtmlUtils {
    // HTML을 제거하고 순수한 텍스트만 반환하는 메서드
    public static String stripHtml(String html) {
        if (html == null || html.trim().isEmpty()) {
            return "";
        }

        // Jsoup을 사용하여 HTML을 파싱 후, 텍스트만 가져오기
        Document document = Jsoup.parse(html);
        return document.text().trim(); // 공백 제거 후 반환
    }
}
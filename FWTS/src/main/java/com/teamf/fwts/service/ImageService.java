package com.teamf.fwts.service;

import java.io.File;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.stereotype.Service;

import jakarta.servlet.http.HttpServletRequest;

@Service
public class ImageService {
	// 이미지 삭제
	public void deleteImage(String content, HttpServletRequest request) {
		Pattern pattern = Pattern.compile("<img[^>]+src=[\"']([^\"']+)[\"']");
        Matcher matcher = pattern.matcher(content);

    	while (matcher.find()) {
            try {
                String realPath = request.getServletContext().getRealPath(matcher.group(1));
                File file = new File(realPath);
                if (file.exists() && !file.delete())
                    System.err.println("파일 삭제 실패: " + realPath);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
	}
}
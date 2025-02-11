package com.teamf.fwts.validation;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

public class NotEmptyHtmlValidator implements ConstraintValidator<NotEmptyHtml, String> {

    @Override
    public boolean isValid(String value, ConstraintValidatorContext context) {
        if (value == null || value.trim().isEmpty()) {
            return false;
        }

        // HTML을 제거한 순수 텍스트 가져오기
        String plainText = HtmlUtils.stripHtml(value);

        // 텍스트가 완전히 비어있으면 false 반환 (유효성 검사 실패)
        return !plainText.isEmpty();
    }
}
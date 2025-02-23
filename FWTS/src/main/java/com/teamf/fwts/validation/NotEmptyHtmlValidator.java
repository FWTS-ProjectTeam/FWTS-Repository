package com.teamf.fwts.validation;

import com.teamf.fwts.util.HtmlUtils;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

public class NotEmptyHtmlValidator implements ConstraintValidator<NotEmptyHtml, String> {

    @Override
    public boolean isValid(String value, ConstraintValidatorContext context) {
        return HtmlUtils.containsContent(value);
    }
}
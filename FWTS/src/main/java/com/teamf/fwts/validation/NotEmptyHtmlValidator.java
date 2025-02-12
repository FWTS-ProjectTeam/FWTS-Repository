package com.teamf.fwts.validation;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import util.HtmlUtils;

public class NotEmptyHtmlValidator implements ConstraintValidator<NotEmptyHtml, String> {

    @Override
    public boolean isValid(String value, ConstraintValidatorContext context) {
        return HtmlUtils.containsContent(value);
    }
}
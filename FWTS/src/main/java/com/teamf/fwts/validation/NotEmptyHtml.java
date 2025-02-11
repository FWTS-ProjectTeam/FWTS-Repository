package com.teamf.fwts.validation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;

@Constraint(validatedBy = NotEmptyHtmlValidator.class)
@Target({ ElementType.FIELD, ElementType.METHOD })
@Retention(RetentionPolicy.RUNTIME)
public @interface NotEmptyHtml {
    String message() default "내용을 입력해주세요."; // 에러 메시지
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
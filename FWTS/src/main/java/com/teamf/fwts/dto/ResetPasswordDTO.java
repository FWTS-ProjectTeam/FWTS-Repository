package com.teamf.fwts.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class ResetPasswordDTO {
	@Size(min = 4, max = 20)
	private String username;
	@NotNull
    @Size(min = 8, max = 20)
	@Pattern(regexp = "^(?=.*[a-zA-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+=-])[A-Za-z\\d!@#$%^&*()_+=-]{8,20}$")
    private String password;
	@NotNull
    private String confirmPassword;
}
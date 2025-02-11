package com.teamf.fwts.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.teamf.fwts.dto.ResetPasswordDto;
import com.teamf.fwts.entity.Users;
import com.teamf.fwts.service.UsersService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/mypage")
public class UserController {
	private final UsersService userService;
	
	// 회원정보 수정 페이지
	@GetMapping("/edit-profile")
	public String profilEditeForm() {
		return "mypage/edit-profile";
	}
	
//	@PostMapping("/reset-password")
//    public ResponseEntity<?> resetPassword(ResetPasswordDto dto, BindingResult bindingResult, Authentication authentication) {
//		String password = dto.getPassword();
//		String username = authentication.getName();
//        Users user = userService.findByUsername(username);
        
        // 유효성 검사
//        if (bindingResult.hasErrors() || !password.equals(dto.getConfirmPassword())) {
//        	return ResponseEntity.badRequest()
//            		.body("{\"href\": \"/mypage/edit-profile\"}"); // 회원정보 수정 페이지
//        }
//
//        try {
//            userService.resetPassword(email, password);
//            session.removeAttribute("email"); // 이메일 삭제
//            return "auth/reset-password-complete";
//        } catch (Exception e) {
//        	model.addAttribute("inputData", dto);
//        	model.addAttribute("errorMessage", "비밀번호를 재설정을 할 수 없습니다. 다시 시도해 주세요.");
//            return "auth/reset-password";
//        }

        // 현재 비밀번호 검증
//        if (!userService.checkPassword(dto.getCurrentPassword(), user.getPassword())) {
//        	return ResponseEntity.badRequest()
//            		.body("{\"errorMessage\": \"현재 비밀번호가 일치하지 않습니다.\"}");
//        }
//
//        // 새 비밀번호 확인
//        if (!request.getNewPassword().equals(request.getConfirmPassword())) {
//            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("새 비밀번호가 일치하지 않습니다.");
//        }
//
//        // 새 비밀번호 암호화 후 저장
//        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
//        userService.save(user);
//
//        return ResponseEntity.ok("비밀번호가 성공적으로 변경되었습니다.");
//    }
}
package com.teamf.fwts.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.teamf.fwts.dto.InquiryListDto;
import com.teamf.fwts.dto.ResetPasswordDto;
import com.teamf.fwts.entity.UserDetails;
import com.teamf.fwts.entity.Users;
import com.teamf.fwts.service.InquiryBoardService;
import com.teamf.fwts.service.UserService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/mypage")
public class MyPageController {
	private final UserService userService;
	private final InquiryBoardService inquiryBoardService;
	
	// 내 정보 수정 페이지
	@GetMapping("/edit-profile")
	public String editProfilForm(Authentication authentication, Model model) {
		Users user = userService.findByUsername(authentication.getName());
		UserDetails userDetails = userService.findByUserId(user.getUserId());
		
		model.addAttribute("userDetails", userDetails);
		return "mypage/edit-profile";
	}
	
	// 회원정보 수정
	@PostMapping("/edit-profile")
	public ResponseEntity<?> editProfile(@Valid @RequestBody UserDetails userDetails, BindingResult bindingResult, Authentication authentication) {
		Users user = userService.findByUsername(authentication.getName());
		
		// 유효성 검사
        if (bindingResult.hasErrors())
        	return ResponseEntity.badRequest().build();
        
        try {
        	userDetails.setUserId(user.getUserId());
        	userService.updateUserDetails(userDetails);
        	return ResponseEntity.ok().build();
		} catch (Exception e) {
			return ResponseEntity.internalServerError().build();
		}
	}
	
	// 비밀번호 재설정
	@PostMapping("/reset-password")
    public ResponseEntity<?> resetPassword(@Valid @RequestBody ResetPasswordDto dto, BindingResult bindingResult, Authentication authentication) {
		String password = dto.getPassword();
		String username = authentication.getName();
        Users user = userService.findByUsername(username);
        
        // 유효성 검사
        if (bindingResult.hasErrors() || !password.equals(dto.getConfirmPassword()))
        	return ResponseEntity.badRequest().build();
        
        // 현재 비밀번호 검증
        if (!userService.checkPassword(dto.getCurrentPassword(), user.getPassword()))
        	return ResponseEntity.badRequest().body(Map.of("errorMessage", "현재 비밀번호와 일치하지 않습니다."));
        
        try {
        	userService.resetPassword(user.getEmail(), password);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
        	return ResponseEntity.internalServerError().build();
        }
    }
	
	// 문의사항 내역 조회
	@GetMapping("/inquiry-history")
	public String noticeList(@RequestParam(name = "page", defaultValue = "1") Integer page, Authentication authentication, Model model) {
	    Users user = userService.findByUsername(authentication.getName());
		
	    Map<String, Integer> params = new HashMap<>();
	    params.put("writerId", user.getUserId());
	    
		int count = inquiryBoardService.countByWriterId(params);

	    if (count > 0) {
	        int perPage = 8; // 한 페이지에 보여줄 수
	        int startRow = (page - 1) * perPage; // 페이지 번호
	        int totalPages = (int) Math.ceil((double) count / perPage); // 전체 페이지 수

	        params.put("start", startRow);
	        params.put("count", perPage);

	        List<InquiryListDto> inquirys = inquiryBoardService.findByWriterId(params);

	        model.addAttribute("inquirys", inquirys);
	        model.addAttribute("currentPage", page);
	        model.addAttribute("totalPages", totalPages);
	    }

	    model.addAttribute("count", count);
	    return "mypage/inquiry-history";
	}
}
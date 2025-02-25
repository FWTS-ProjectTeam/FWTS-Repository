package com.teamf.fwts.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.teamf.fwts.dto.InquiryListDto;
import com.teamf.fwts.dto.ProfileDto;
import com.teamf.fwts.dto.ResetPasswordDto;
import com.teamf.fwts.entity.Account;
import com.teamf.fwts.entity.UserDetails;
import com.teamf.fwts.entity.Users;
import com.teamf.fwts.service.AccountService;
import com.teamf.fwts.service.InquiryBoardService;
import com.teamf.fwts.service.UserService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/my-page")
public class MyPageController {
	private final UserService userService;
	private final AccountService accountService;
	private final InquiryBoardService inquiryBoardService;
	
	// 내 정보 관리 페이지
	@GetMapping("/info")
	public String editProfilForm(Authentication authentication, Model model) {
		Users user = userService.findByUsername(authentication.getName());
		UserDetails userDetails = userService.findUserDetailsByUserId(user.getUserId());

		// 도매업자 처리
		if (user.getRole() == 1) {
			Account account = accountService.findByUserId(user.getUserId());
			model.addAttribute("account", account);
		}
		
		model.addAttribute("userDetails", userDetails);
		return "mypage/info";
	}
	
	// 회원정보 수정
	@PostMapping("/info/edit-profile")
	public ResponseEntity<?> editProfile(@Valid @RequestBody ProfileDto dto, BindingResult bindingResult, Authentication authentication) {
		Users user = userService.findByUsername(authentication.getName());

		// 유효성 검사
        if (bindingResult.hasErrors())
        	return ResponseEntity.badRequest().build();
        
        try {
        	dto.setUserId(user.getUserId());
        	userService.updateProfile(dto);
        	
        	// 도매업자 처리
        	if (user.getRole() == 1)
        		accountService.updateAccount(dto);

        	return ResponseEntity.ok().build();
		} catch (Exception e) {
			return ResponseEntity.internalServerError().build();
		}
	}
	
	// 회원탈퇴
	@ResponseBody
	@DeleteMapping("/info/delete")
	public Map<String, Object> deleteUser(Authentication authentication, HttpSession session) {
		Users user = userService.findByUsername(authentication.getName());
	    Map<String, Object> response = new HashMap<>();

	    // 탈퇴 제한 조건 추가
	    if (user.isLimited()) {
	        response.put("success", false);
	        response.put("message", "회원 탈퇴가 제한된 상태입니다.");
	        return response;
	    }

	    try {
	        userService.deleteByUsername(authentication.getName());
	        session.invalidate(); // 세션 무효화
	        response.put("success", true);
	    } catch (Exception e) {
	        response.put("success", false);
	        response.put("message", "회원 탈퇴 중 오류가 발생했습니다.");
	    }
	    
	    return response;
	}
	
	// 비밀번호 재설정
	@PostMapping("/info/reset-password")
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
	
	// 문의 내역 조회
	@GetMapping("/inquiry-history")
	public String inquiryAll(@RequestParam(name = "page", defaultValue = "1") Integer page,
							 Authentication authentication, Model model) {
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
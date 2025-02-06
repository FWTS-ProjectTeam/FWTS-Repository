package com.teamf.fwts.controller;

import java.time.LocalDateTime;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

import com.teamf.fwts.dto.ResetPasswordDTO;
import com.teamf.fwts.dto.SignupDTO;
import com.teamf.fwts.dto.UserDTO;
import com.teamf.fwts.dto.VerificationCodeDTO;
import com.teamf.fwts.service.EmailService;
import com.teamf.fwts.service.UserService;
import com.teamf.fwts.service.VerifyService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class AuthController {
    private final UserService userService;
    private final VerifyService verifyService;
    private final EmailService emailService;
    private final AuthenticationManager authenticationManager;

    // 로그인 페이지
    @GetMapping("/login")
    public String loginForm(@RequestParam(name = "error", required = false) Boolean error, Model model) {
    	if (error != null && error == true) {
    		model.addAttribute("errorMessage", "아이디 또는 비밀번호가 유효하지 않습니다.");
    	}
    	return "auth/login";
    }
    
    // 로그인
    @PostMapping("/login")
    public String login(UserDTO dto, Model model) {
        try {
            Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(dto.getUsername(), dto.getPassword())
            );
            SecurityContextHolder.getContext().setAuthentication(authentication);
            return "redirect:/";
        } catch (Exception e) {
            return "redirect:/login?error=true"; // 로그인 페이지
        }
    }

    // 로그아웃
    @GetMapping("/logout")
    public String logout() {
        SecurityContextHolder.clearContext();
        return "redirect:/";
    }
    
    // 회원가입 페이지
    @GetMapping("/sign-up")
    public String signupForm(@RequestParam(name = "step", defaultValue = "1") Integer step) {
    	if (step == 1) {
    		return "auth/signup-agreement"; // 약관동의 페이지
    	}
    	return "auth/signup"; // 정보입력 페이지
    }
    
    // 회원가입
    @PostMapping("/sign-up")
    public String signup(@Valid SignupDTO dto, BindingResult bindingResult, Model model) {
    	// 유효성 검사
        if (bindingResult.hasErrors()) {
            model.addAttribute("inputData", dto);
            //model.addAttribute("errorMessages", bindingResult);
            return "auth/signup"; // 정보입력 페이지
        }
        
    	try {
            userService.signup(dto);
            return "auth/signup-complete"; //가입완료 페이지
        } catch (Exception e) {
        	model.addAttribute("inputData", dto);
        	model.addAttribute("errorMessage", "가입에 실패했습니다...");
            return "auth/signup"; // 정보입력 페이지
        }
    }

    // 중복 확인 (이메일, 아이디)
    @GetMapping("/check-duplicate")
    public ResponseEntity<Boolean> checkDuplicate(@RequestParam("type") String type,
    											  @RequestParam("value") String value) {
    	boolean isDuplicate = userService.isDuplicate(type, value);
        return ResponseEntity.ok(isDuplicate);
    }
    
    // 사업자등록번호 확인 (* 중복 확인만 진행)
    @GetMapping("/check-business-no")
	public ResponseEntity<Boolean> checkDuplicate(@RequestParam("businessNo") String businessNo) {
		boolean isDuplicate = userService.isDuplicate("businessNo", businessNo);
		return ResponseEntity.ok(isDuplicate);
	}
    
    // 계정 찾기 페이지
    @GetMapping({"/find-id", "/find-password"})
    public String findAccountForm() {
    	return "auth/find-account";
    }
    
    // 아이디 찾기
    @PostMapping("/find-id")
    public String findUsername(UserDTO dto, Model model) {
    	String email = dto.getEmail();
    	
    	String username = userService.findUsernameByEmail(email);
        model.addAttribute("username", username);
        model.addAttribute("email", email);
        return "auth/find-username-result";
    }
    
    // 인증 코드 요청
    @PostMapping("/find-password/send-code")
    public ResponseEntity<?> verifyForm(@RequestBody Map<String, String> request, HttpSession session) {
        String email = request.get("email");
    	
    	if (!userService.existsByEmail(email)) {
            return ResponseEntity.badRequest()
            		.body("{\"errorMessage\": \"존재하지 않는 이메일입니다.\"}");
        }

        String verificationCode = verifyService.generateCode(email);
        LocalDateTime expiryTime = LocalDateTime.now().plusMinutes(5); // 5분 후 만료

        session.setAttribute("verificationCode", verificationCode);
        session.setAttribute("verificationCodeExpiry", expiryTime);
        session.setAttribute("email", email);

        emailService.sendVerificationCode(email, verificationCode);

        return ResponseEntity.ok("{\"message\": \"코드 전송 완료\"}");
    }
    
    // 인증 번호 재전송 요청
    @PostMapping("/find-password/resend-code")
    public ResponseEntity<?> resendVerificationCode(HttpSession session) {
    	String email = (String) session.getAttribute("email");
    	
    	// 이메일이 존재하지 않으면
        if (email == null) {
            return ResponseEntity.badRequest()
                    .body("{\"errorMessage\": \"잘못된 요청입니다.\"}");
        }

        String verificationCode = verifyService.generateCode(email);
        LocalDateTime expiryTime = LocalDateTime.now().plusMinutes(5); // 5분 후 만료
        
        // 세션에 저장
        session.setAttribute("verificationCode", verificationCode);
        session.setAttribute("verificationCodeExpiry", expiryTime);

        emailService.sendVerificationCode(email, verificationCode);

        return ResponseEntity.ok("{\"message\": \"코드 전송 완료\"}");
    }
    
    // 인증 코드 입력 페이지
    @GetMapping("/find-password/verify-code")
    public String verifyCodeForm(HttpSession session) {
        String email = (String) session.getAttribute("email");

        // 이메일이 존재하지 않으면
        if (email == null) {
        	return "redirect:/find-password"; // 비밀번호 찾기 페이지
        }
        
        return "auth/verify-code";
    }

    // 인증 코드 확인 처리
    @PostMapping("/find-password/verify-code")
    public String verifyCode(VerificationCodeDTO dto, HttpSession session, Model model) {
        String code = dto.getCode();
    	
    	String verificationCode = (String) session.getAttribute("verificationCode");
        LocalDateTime expiryTime = (LocalDateTime) session.getAttribute("verificationCodeExpiry");
        String email = (String) session.getAttribute("email");
        
        // 이메일이 존재하지 않거나 세션에 인증 코드가 없으면
        if (email == null || verificationCode == null) {
        	return "redirect:/find-password"; // 비밀번호 찾기 페이지
        }

        // 현재 시간이 만료시간보다 늦으면 인증 실패
        if (LocalDateTime.now().isAfter(expiryTime)) {
            model.addAttribute("errorMessage", "만료된 인증 코드입니다.");
            
            // 만료된 인증 코드 삭제
            session.removeAttribute("verificationCode");
            session.removeAttribute("verificationCodeExpiry");
            return "auth/verify-code"; // 인증 코드 입력 페이지
        }

        // 인증 코드가 일치하는지 확인
        if (!verificationCode.equals(code)) {
            model.addAttribute("errorMessage", "잘못된 인증 코드입니다.");
            return "auth/verify-code"; // 인증 코드 입력 페이지
        }
        
        // 인증 코드 삭제
        session.removeAttribute("verificationCode");
        session.removeAttribute("verificationCodeExpiry");
        
        return "redirect:/find-password/reset-password";
    }
    
    // 비밀번호 재설정 페이지
    @GetMapping("/find-password/reset-password")
    public String resetPasswordForm(HttpSession session) {
    	String email = (String) session.getAttribute("email");
    	
    	// 이메일이 존재하지 않으면
        if (email == null) {
        	return "redirect:/find-password"; // 비밀번호 찾기 페이지
        }
    	
    	return "auth/reset-password";
    }
    
    // 비밀번호 재설정
    @PostMapping("/find-password/reset-password")
    public String resetPassword(@Valid ResetPasswordDTO dto, BindingResult bindingResult, HttpSession session, Model model) {    	
    	String email = (String) session.getAttribute("email");
        String password = dto.getPassword();
        String confirmPassword = dto.getConfirmPassword();
        
        // 유효성 검사
        if (bindingResult.hasErrors() || !password.equals(confirmPassword)) {
        	return "redirect:/find-password/reset-password"; // 비밀번호 재설정 페이지
        }

        try {
            userService.resetPassword(email, password);
            session.removeAttribute("email"); // 이메일 삭제
            return "auth/reset-password-complete";
        } catch (Exception e) {
        	model.addAttribute("inputData", dto);
        	model.addAttribute("errorMessage", "비밀번호를 재설정을 할 수 없습니다. 다시 시도해 주세요.");
            return "auth/reset-password";
        }
    }
}
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

import com.teamf.fwts.dto.ResetPasswordDto;
import com.teamf.fwts.dto.SignupDto;
import com.teamf.fwts.dto.UserDto;
import com.teamf.fwts.dto.VerificationCodeDto;
import com.teamf.fwts.service.EmailService;
import com.teamf.fwts.service.UsersService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class AuthController {
    private final UsersService userService;
    private final EmailService emailService;
    private final AuthenticationManager authenticationManager;

    // 로그인 페이지
    @GetMapping("/login")
    public String loginForm(@RequestParam(name = "error", defaultValue = "false") boolean error, Model model) {
    	if (error == true)
    		model.addAttribute("errorMessage", "아이디 또는 비밀번호가 유효하지 않습니다.");
    	
    	return "auth/login";
    }
    
    // 로그인
    @PostMapping("/login")
    public String login(UserDto dto) {
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
    public String signupForm(@RequestParam(name = "step", defaultValue = "1") int step) {
    	if (step == 1)
    		return "auth/signup-agreement"; // 약관동의 페이지
    	return "auth/signup"; // 정보입력 페이지
    }
    
    // 회원가입 (*수정 필요)
    @PostMapping("/sign-up")
    public String signup(@Valid SignupDto dto, BindingResult bindingResult, Model model) {
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
    @PostMapping("/check-duplicate")
    public ResponseEntity<Boolean> checkDuplicate(@RequestBody Map<String, String> request){
    	String type = request.get("type");
        String value = request.get("value");

        // 유효성 검사
        if (type == null || value == null)
            return ResponseEntity.ok(true);
    	
    	boolean isDuplicate = userService.isDuplicate(request.get("type"), request.get("value"));
        return ResponseEntity.ok(isDuplicate);
    }
    
    // 사업자등록번호 확인 (*중복 확인만 진행)
    @PostMapping("/check-business-no")
	public ResponseEntity<Boolean> checkBusinessNo(@RequestBody Map<String, String> request) {
    	String value = request.get("value");

        // 유효성 검사
        if (value == null)
            return ResponseEntity.ok(true);
    	
		boolean isDuplicate = userService.isDuplicate("businessNo", request.get("value"));
		return ResponseEntity.ok(isDuplicate);
	}
    
    // 계정 찾기 페이지
    @GetMapping({"/find-id", "/find-password"})
    public String findAccountForm() {
    	return "auth/find-account";
    }
    
    // 아이디 찾기
    @PostMapping("/find-id")
    public String findUsername(UserDto dto, Model model) {
    	String email = dto.getEmail();
    	String username = userService.findUsernameByEmail(email);
    	
    	model.addAttribute("email", email);
        model.addAttribute("username", username);
        return "auth/find-username-result";
    }
    
    // 인증 코드 요청    
    @PostMapping("/find-password/send-code")
    public ResponseEntity<?> sendCode(@RequestBody Map<String, String> request, HttpSession session) {
        String email = request.get("email");

        // 유효성 검사
        if (email == null || email.trim().isEmpty())
            return ResponseEntity.badRequest().build();
        
        // 이메일 존재 여부 확인
        if (!userService.existsByEmail(email))
        	return ResponseEntity.badRequest().body(Map.of("errorMessage", "존재하지 않는 이메일입니다."));

        try {
            generateCode(email, session); // 인증 코드 생성 및 전송
            return ResponseEntity.ok().build();
        } catch (Exception e) {
        	return ResponseEntity.internalServerError().build();
        }
    }
    
    // 인증 번호 재전송 요청
    @PostMapping("/find-password/resend-code")
    public ResponseEntity<Void> resendCode(HttpSession session) {
        String email = (String) session.getAttribute("email");
        
        // 이메일이 존재하지 않으면 제한
        if (email == null)
            return ResponseEntity.badRequest().build();

        try {
            generateCode(email, session); // 인증 코드 생성 및 전송
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // 인증 코드 입력 페이지
    @GetMapping("/find-password/verify-code")
    public String verifyCodeForm(HttpSession session) {
        String email = (String) session.getAttribute("email");

        // 이메일이 존재하지 않으면 제한
        if (email == null)
        	return "redirect:/find-password"; // 비밀번호 찾기 페이지
        return "auth/verify-code";
    }

    // 인증 코드 확인 처리
    @PostMapping("/find-password/verify-code")
    public String verifyCode(VerificationCodeDto dto, HttpSession session, Model model) {
        String code = dto.getCode();
        
    	String verificationCode = (String) session.getAttribute("verificationCode");
        LocalDateTime expiryTime = (LocalDateTime) session.getAttribute("verificationCodeExpiry");
        String email = (String) session.getAttribute("email");
        
        // 세션에 이메일이나 인증 코드가 없으면 제한
        if (email == null || verificationCode == null)
        	return "redirect:/find-password"; // 비밀번호 찾기 페이지

        // 현재 시간이 만료시간보다 늦으면 실패
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
        
        return "redirect:/find-password/reset-password";
    }
    
    // 비밀번호 재설정 페이지
    @GetMapping("/find-password/reset-password")
    public String resetPasswordForm(HttpSession session) {
    	String email = (String) session.getAttribute("email");
    	
    	// 세션에 이메일이 없으면 제한
        if (email == null)
        	return "redirect:/find-password"; // 비밀번호 찾기 페이지
    	return "auth/reset-password";
    }
    
    // 비밀번호 재설정
    @PostMapping("/find-password/reset-password")
    public String resetPassword(@Valid ResetPasswordDto dto, BindingResult bindingResult, HttpSession session, Model model) {    	
    	String email = (String) session.getAttribute("email");
        String password = dto.getPassword();
        
        // 유효성 검사
        if (bindingResult.hasErrors() || !password.equals(dto.getConfirmPassword()))
        	return "redirect:/find-password/reset-password"; // 비밀번호 재설정 페이지

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
    
    // 인증 코드 전송
    private void generateCode(String email, HttpSession session) {
    	String verificationCode = String.valueOf((int) (Math.random() * 900000) + 100000); // 인증 코드 생성
    	LocalDateTime expiryTime = LocalDateTime.now().plusMinutes(5); // 5분 후 만료
    	
        session.setAttribute("verificationCode", verificationCode);
        session.setAttribute("verificationCodeExpiry", expiryTime);
        session.setAttribute("email", email);
        
        emailService.sendVerificationCode(email, verificationCode);
    }
}
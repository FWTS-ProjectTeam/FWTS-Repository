package com.teamf.fwts.service;

import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.teamf.fwts.dto.ProfileDto;
import com.teamf.fwts.dto.SignupDto;
import com.teamf.fwts.dto.UserListDto;
import com.teamf.fwts.entity.UserDetails;
import com.teamf.fwts.entity.Users;
import com.teamf.fwts.mapper.UserAccountMapper;
import com.teamf.fwts.mapper.UserMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserService {
    private final UserMapper userMapper;
    private final UserAccountMapper userAccountMapper;
    private final PasswordEncoder passwordEncoder;
    private final AccountService accountService;
    
    private static final Pattern BUSINESS_NO_PATTERN = Pattern.compile("^\\d{3}-\\d{2}-\\d{5}$");
	private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    // 회원가입
    @Transactional
    public void signup(SignupDto dto) {
    	String hashedPassword = hashPassword(dto.getPassword());

        // User 추가
        Users user = new Users();
        user.setEmail(dto.getEmail());
        user.setUsername(dto.getUsername());
        user.setPassword(hashedPassword);
        user.setRole(dto.getRole());

        userMapper.insertUser(user);
        
        // UserDetail 추가
        UserDetails userDetail = new UserDetails();
        userDetail.setUserId(user.getUserId());
        userDetail.setPhoneNum(dto.getPhoneNum());       
        userDetail.setBusinessNo(dto.getBusinessNo());
        userDetail.setCompanyName(dto.getCompanyName());
        userDetail.setCeoName(dto.getCeoName());
        userDetail.setPostalCode(dto.getPostalCode());
        userDetail.setAddress(dto.getAddress());
        
        // 빈 문자열이면 NULL로 변환
        userDetail.setCompanyNum(
        		dto.getCompanyNum().isBlank() ? null : dto.getCompanyNum()
        );
        userDetail.setDetailAddress(
        		dto.getDetailAddress().isBlank() ? null : dto.getDetailAddress()
        );
        
        userMapper.insertUserDetail(userDetail);
        
        // BackAccount 추가
        accountService.insertAccount(user.getUserId());
    }
    
    // 비밀번호 재설정
    @Transactional
    public void resetPassword(String email, String password) {
        userMapper.resetPassword(email, hashPassword(password));
    }
    
    // 비밀번호 암호화
    public String hashPassword(String password) {
    	return passwordEncoder.encode(password);
    }

    // 중복 확인
    public boolean isDuplicate(String type, String value) {
    	// 이메일 또는 아이디 중복 확인
        if ((type.equals("email") && EMAIL_PATTERN.matcher(value).matches()) || type.equals("username"))
        	return userMapper.checkEmailOrUsername(type, value) > 0;
    	
    	// 사업자등록번호 중복 확인
        if (type.equals("businessNo") && BUSINESS_NO_PATTERN.matcher(value).matches())
        	return userMapper.checkBesinessNo(value) > 0;
        	
        return true;
    }
    
    // 아이디 조회
    public String findUsernameByEmail(String email) {
        return userMapper.findUsernameByEmail(email);
    }
    
    // 이메일 조회
    public boolean existsByEmail(String email) {
        return userMapper.existsByEmail(email) > 0;
    }
    
    // 전체 회원 정보 조회
 	public List<UserListDto> findAll(Map<String, Object> params) {
 		return userAccountMapper.findAll(params);
 	}

    // 회원 정보 조회
	public Users findByUsername(String name) {
		return userMapper.findByUsername(name);
	}
	
	// 회원 상세 정보 조회
	public UserDetails findByUserId(Integer userId) {
		return userMapper.findByUserId(userId);
	}
	
	// 비밀번호 검증
	public boolean checkPassword(String inputPassword, String currentPassword) {
		return passwordEncoder.matches(inputPassword, currentPassword);
	}

	// 회원 상세 정보 수정
	@Transactional
	public void updateProfile(ProfileDto dto) {
        UserDetails userDetail = new UserDetails();
        userDetail.setUserId(dto.getUserId());
        userDetail.setPhoneNum(dto.getPhoneNum());       
        userDetail.setBusinessNo(dto.getBusinessNo());
        userDetail.setCompanyName(dto.getCompanyName());
        userDetail.setCeoName(dto.getCeoName());
        userDetail.setPostalCode(dto.getPostalCode());
        userDetail.setAddress(dto.getAddress());
		
		// 빈 문자열이면 NULL로 변환
        userDetail.setCompanyNum(
        		dto.getCompanyNum().isBlank() ? null : dto.getCompanyNum()
        );
        userDetail.setDetailAddress(
				dto.getDetailAddress().isBlank() ? null : dto.getDetailAddress()
        );
		
        userMapper.updateUserDetails(userDetail);
	}

	// 회원 수 확인
	public int count() {
		return userMapper.count();
	}
}
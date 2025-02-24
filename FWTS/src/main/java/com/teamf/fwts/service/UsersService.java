package com.teamf.fwts.service;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.teamf.fwts.dao.UserDao;
import com.teamf.fwts.dto.SignupDto;
import com.teamf.fwts.entity.UserDetails;
import com.teamf.fwts.entity.Users;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UsersService {
    private final UserDao userDao;
    private final PasswordEncoder passwordEncoder;

    // 회원가입
    @Transactional
    public void signup(SignupDto dto) {
    	String hashedPassword = hashPassword(dto.getPassword());

    	System.out.println("SignupDto: " + dto);
    	
        // User 객체 생성
        Users user = new Users();
        user.setEmail(dto.getEmail());
        user.setUsername(dto.getUsername());
        user.setPassword(hashedPassword);
        user.setRole(dto.getRole());

        userDao.insertUser(user);

        // UserDetail 객체 생성
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
        
        System.out.println("SignupDto: " + dto);

        userDao.insertUserDetail(userDetail);
    }
    
    // 비밀번호 재설정
    @Transactional
    public void resetPassword(String email, String password) {
        String hashedPassword = hashPassword(password);
        userDao.resetPassword(email, hashedPassword);
    }
    
    // 비밀번호 암호화
    public String hashPassword(String password) {
    	return passwordEncoder.encode(password);
    }

    // 중복 확인
    public boolean isDuplicate(String type, String value) {
    	// 사업자등록번호 중복 확인
        if ("businessNo".equals(type))
        	return userDao.checkBesinessNo(value) > 0;

        // 나머지 중복 확인
        if ("email".equals(type) || "username".equals(type))
        	return userDao.checkEmailOrUsername(type, value) > 0;
        	
        return false;
    }
    
    // 아이디 조회
    public String findUsernameByEmail(String email) {
        return userDao.findUsernameByEmail(email);
    }
    
    // 이메일 확인
    public boolean existsByEmail(String email) {
        return userDao.existsByEmail(email) > 0;
    }

    // 회원 조회
	public Users findByUsername(String name) {
		return userDao.findByUsername(name);
	}
	
//	public Users findbyUserId(int userId) {
//		return userDao.findByUserId(userId);
//	}
}
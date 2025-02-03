package com.teamf.fwts.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.teamf.fwts.dao.UserMapper;
import com.teamf.fwts.dto.User;
import com.teamf.fwts.dto.UserDetail;

@Service
public class UserService {
    @Autowired
    private UserMapper userMapper;

    // 회원가입 처리
    @Transactional
    public void registerUser(User user, UserDetail userDetail) {
        // 비밀번호 해싱 처리
        user.setPassword(BCrypt.hashpw(user.getPassword(), BCrypt.gensalt()));
        
        // 회원 정보 저장
        userMapper.insertUser(user);
        userDetail.setUserId(user.getUserId());
        userMapper.insertUserDetail(userDetail);
    }

    // 중복 확인
    public boolean isDuplicate(String type, String value) {
        return userMapper.checkDuplicate(type, value) > 0;
    }
}
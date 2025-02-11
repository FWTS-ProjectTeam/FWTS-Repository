package com.teamf.fwts.service;

import com.teamf.fwts.entity.Users;
import com.teamf.fwts.mapper.UserMapper;

import lombok.RequiredArgsConstructor;

import java.util.Collections;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserDetailsServiceImpl implements UserDetailsService {
    private final UserMapper userMapper;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Users user = userMapper.findByUsername(username);
        
        if (user == null) {
            throw new UsernameNotFoundException("User not found with username: " + username);
        }

        // 권한 리스트 생성
        List<GrantedAuthority> authorities;
        if (!user.isLimited()) {
            authorities = Collections.singletonList(new SimpleGrantedAuthority(getRoleString(user)));
        } else {
            authorities = Collections.emptyList();
        }

        return new User(
            user.getUsername(),
            user.getPassword(),
            authorities
        );
    }
    
    // Spring Security 역할 변환
    private String getRoleString(Users user) {
        return switch (user.getRole()) {
            case 0 -> "ROLE_ADMIN";
            case 1 -> "ROLE_SELLER";
            default -> "ROLE_BUYER";
        };
    }
}
package com.teamf.fwts.service;

import com.teamf.fwts.dao.UserDao;
import com.teamf.fwts.entity.Users;

import lombok.RequiredArgsConstructor;

import java.util.Collections;

import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserDetailsServiceImpl implements UserDetailsService {
    private final UserDao userMapper;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Users user = userMapper.findByUsername(username);
        
        if (user == null) {
            throw new UsernameNotFoundException("User not found with username: " + username);
        }

        return new User(
            user.getUsername(),
            user.getPassword(),
            Collections.singletonList(new SimpleGrantedAuthority(getRoleString(user)))
        );
    }
    
    // Spring Security 역할 변환
    private String getRoleString(Users user) {
        return switch (user.getRole()) {
            case 0 -> "ROLE_ADMIN";
            case 1 -> "ROLE_WHOLESALER";
            default -> "ROLE_RETAILER";
        };
    }
}
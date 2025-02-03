package com.teamf.fwts.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {
	@Bean
    SecurityFilterChain filterChain(HttpSecurity security) throws Exception {
		security.csrf(AbstractHttpConfigurer::disable) // CSRF 비활성화
                .authorizeHttpRequests(auth -> auth
                		.requestMatchers("/mypage/**").authenticated() // 인증 필요 경로
                		.anyRequest().permitAll()
                )
				.formLogin(login -> login.loginPage("/login").defaultSuccessUrl("/", true).permitAll())
				.logout(logout -> logout.logoutUrl("/logout").logoutSuccessUrl("/").permitAll());
		
        return security.build();
    }
	
	@Bean
	PasswordEncoder passwordEncoder() {
		return PasswordEncoderFactories.createDelegatingPasswordEncoder();
	}
}
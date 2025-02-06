package com.teamf.fwts.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {
	@Bean
    SecurityFilterChain filterChain(HttpSecurity security) throws Exception {
		security.csrf(AbstractHttpConfigurer::disable) // CSRF 비활성화
                .authorizeHttpRequests(auth -> auth
                		.requestMatchers("/mypage/**").authenticated() // 인증자 허용 경로
                		.requestMatchers("/admin/**").hasRole("ADMIN") // 관리자 허용 경로
                		.anyRequest().permitAll()
                )
				.formLogin(login -> login
						.loginPage("/login")
						.defaultSuccessUrl("/", true)
						.failureUrl("/login?error=true")
						.permitAll())
				.logout(logout -> logout.logoutUrl("/logout").logoutSuccessUrl("/").permitAll());
		
        return security.build();
    }
	
	@Bean
	PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
	
    @Bean
    AuthenticationManager authenticationManager(AuthenticationConfiguration authenticationConfiguration) throws Exception {
        return authenticationConfiguration.getAuthenticationManager();
    }
}
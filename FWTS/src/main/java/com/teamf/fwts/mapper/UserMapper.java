package com.teamf.fwts.mapper;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.teamf.fwts.entity.UserDetails;
import com.teamf.fwts.entity.Users;

@Mapper
public interface UserMapper {
	// 회원 정보 저장
	@Insert({"INSERT INTO users (email, username, password, role)",
			"VALUES (#{email}, #{username}, #{password}, #{role})"})
	@Options(useGeneratedKeys = true, keyProperty = "userId")
	void insertUser(Users user);
	
	// 회원 상세 정보 저장
	@Insert({"INSERT INTO user_details (user_id, phone_num, company_num, business_no, company_name, ceo_name, postal_code, address, detail_address)",
			"VALUES (#{userId}, #{phoneNum}, #{companyNum}, #{businessNo}, #{companyName}, #{ceoName}, #{postalCode}, #{address}, #{detailAddress})"})
    void insertUserDetail(UserDetails userDetail);
	
	// 비밀번호 재설정
	@Update("UPDATE users SET password = #{password} WHERE email = #{email}")
	void resetPassword(@Param("email") String email, @Param("password") String password);
    
	// 아이디 조회
	@Select("SELECT username FROM users WHERE email = #{email}")
	String findUsernameByEmail(@Param("email") String email);

	// 이메일 확인
	@Select("SELECT COUNT(*) FROM users WHERE email = #{email}")
	int existsByEmail(@Param("email") String email);
	
	// 이메일 또는 아이디 중복 확인
	@Select("SELECT COUNT(*) FROM users WHERE ${type} = #{value}")
    int checkEmailOrUsername(@Param("type") String type, @Param("value") String value);

	// 사업자등록번호 중복 확인
	@Select("SELECT COUNT(*) FROM user_details WHERE business_no = #{value}")
    int checkBesinessNo(@Param("value") String value);
	
	// 회원 조회
	@Select("SELECT * FROM users WHERE username = #{username}")
    Users findByUsername(String username);
}
package com.teamf.fwts.dao;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.teamf.fwts.dto.User;
import com.teamf.fwts.dto.UserDetail;

@Mapper
public interface UserMapper {
	// 회원 정보 저장
	@Insert({"INSERT INTO user (username, password, role, created_at)",
			"VALUES (#{username}, #{password}, #{role}, NOW());"})
	void insertUser(User user);
	
	// 회원 상세 정보 저장
	@Insert({"INSERT INTO user_detail (user_id, email, phone_num, company_num, business_regist_no, company_name, ceo_name)",
			"VALUES (#{userId}, #{email}, #{phoneNum}, #{companyNum}, #{businessRegistNo}, #{companyName}, #{ceoName});"})
    void insertUserDetail(UserDetail userDetail);
    
	// 아이디, 비밀번호 중복 확인
	@Select("SELECT COUNT(*) FROM user WHERE ${type} = #{value};")
    int checkDuplicate(@Param("type") String type, @Param("value") String value);
}
package com.teamf.fwts.mapper;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.teamf.fwts.entity.Account;

@Mapper
public interface AccountMapper {
	// 회원 계좌 생성
	@Insert("INSERT INTO account (user_id) VALUES (#{userId})")
	void insertAccount(@Param("userId") Integer userId);
	
	// 회원 계좌 수정
	@Update({"UPDATE account SET",
		    "bank_name = #{bankName}, account_num = #{accountNum}",
		    "WHERE user_id = #{userId}"})
	void updateAccount(Account bankAccount);
	
	// 회원 계좌 조회
	@Select("SELECT * FROM account WHERE user_id = #{userId}")
	Account findByUserId(@Param("userId") Integer userId);
}
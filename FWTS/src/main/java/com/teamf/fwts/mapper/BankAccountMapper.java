package com.teamf.fwts.mapper;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.teamf.fwts.entity.BankAccount;

@Mapper
public interface BankAccountMapper {
	// 회원 계좌 생성
	@Insert("INSERT INTO bank_account (user_id) VALUES (#{userId})")
	void insertBankAccount(@Param("userId") Integer userId);
	
	// 회원 계좌 수정
	@Update({"UPDATE bank_account SET",
		    "bank_name = #{bankName}, account_num = #{accountNum}",
		    "WHERE user_id = #{userId}"})
	void updateBankAccount(BankAccount bankAccount);
	
	// 회원 계좌 조회
	@Select("SELECT * FROM bank_account WHERE user_id = #{userId}")
	BankAccount findByUserId(@Param("userId") Integer userId);
}
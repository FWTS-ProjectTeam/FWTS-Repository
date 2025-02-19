package com.teamf.fwts.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.teamf.fwts.dto.ProfileDto;
import com.teamf.fwts.entity.Account;
import com.teamf.fwts.mapper.AccountMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AccountService {
	private final AccountMapper accountMapper;

	// 회원 계좌 생성
	@Transactional
	public void insertAccount(Integer userId) {
		accountMapper.insertAccount(userId);
	}

	// 회원 계좌 조회
	public Account findByUserId(Integer userId) {
		return accountMapper.findByUserId(userId);
	}

	// 회원 계좌 수정
	@Transactional
	public void updateAccount(ProfileDto dto) {
		Account account = new Account();
		account.setUserId(dto.getUserId());
		account.setBankName(dto.getBankName());       
		account.setAccountNum(dto.getAccountNum());
		
		accountMapper.updateAccount(account);
	}
}

package com.teamf.fwts.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.teamf.fwts.dto.ProfileDto;
import com.teamf.fwts.entity.BankAccount;
import com.teamf.fwts.mapper.BankAccountMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class BankAccountService {
	private final BankAccountMapper bankAccountMapper;

	// 회원 계좌 생성
	@Transactional
	public void insertBankAccount(Integer userId) {
		bankAccountMapper.insertBankAccount(userId);
	}

	// 회원 계좌 조회
	public BankAccount findByUserId(Integer userId) {
		return bankAccountMapper.findByUserId(userId);
	}

	// 회원 계좌 수정
	@Transactional
	public void updateBankAccount(ProfileDto dto) {
		BankAccount bankAccount = new BankAccount();
		bankAccount.setUserId(dto.getUserId());
		bankAccount.setBankName(dto.getBankName());       
		bankAccount.setAccountNum(dto.getAccountNum());
		
		bankAccountMapper.updateBankAccount(bankAccount);
	}
}

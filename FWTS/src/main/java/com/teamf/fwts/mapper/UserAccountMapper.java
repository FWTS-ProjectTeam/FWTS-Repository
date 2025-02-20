package com.teamf.fwts.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.teamf.fwts.dto.UserListDto;

@Mapper
public interface UserAccountMapper {
	// 회원 수 확인
	int count(Map<String, Object> params);
	
	// 회원 조회
	List<UserListDto> findAll(Map<String, Object> params);
}
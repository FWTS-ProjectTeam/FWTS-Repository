package com.teamf.fwts.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.teamf.fwts.dto.UserListDto;

@Mapper
public interface UserAccountMapper {
	// 전체 회원 정보 조회
	@Select({"SELECT ud.user_id, u.username, u.email, u.role, u.is_limited, u.created_at,",
	    	"ud.ceo_name, ud.phone_num, ud.company_num, ud.business_no, ud.company_name, ud.postal_code, ud.address, ud.detail_address,",
	    	"a.bank_name, a.account_Num",
	    	"FROM user_details ud",
	    	"JOIN users u ON u.user_id = ud.user_id",
	    	"LEFT JOIN account a ON u.user_id = a.user_id",
	    	"LIMIT #{start}, #{count}"})
	List<UserListDto> findAll(Map<String, Object> params);
}
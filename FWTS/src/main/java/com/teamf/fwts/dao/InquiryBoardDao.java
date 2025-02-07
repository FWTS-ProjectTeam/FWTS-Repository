package com.teamf.fwts.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Result;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.teamf.fwts.dto.InquiryListDto;
import com.teamf.fwts.entity.NoticeBoard;

@Mapper
public interface InquiryBoardDao {
	// 문의사항 조회
	@Select({"SELECT ib.inquiry_id, u.user_id, u.username, ib.inquiry_title, ib.created_date",
	    	 "FROM inquiry_board ib",
	    	 "JOIN users u ON ib.writer_id = u.user_id",
	    	 "ORDER BY ib.inquiry_id DESC",
	    	 "LIMIT #{start}, #{count}"})
	@Results({
	    @Result(column = "user_id", property = "writer.userId"),
	    @Result(column = "username", property = "writer.username")
	})
	List<InquiryListDto> inquiryList(Map<String, Object> paging);
	
	// 문의사항 수 확인
	@Select("SELECT COUNT(*) FROM inquiry_board")
	int count();

	// 문의사항 상세 조회
	@Select("SELECT * FROM inquiry_board WHERE inquiry_id = #{id}")
	NoticeBoard inquiryOne(@Param("id") int id);
}
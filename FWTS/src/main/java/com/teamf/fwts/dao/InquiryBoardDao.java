package com.teamf.fwts.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Result;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.teamf.fwts.dto.InquiryListDto;
import com.teamf.fwts.entity.InquiryBoard;

@Mapper
public interface InquiryBoardDao {
	// 문의사항 수 확인
//	@Select("SELECT COUNT(*) FROM inquiry_board")
//	int count();
	
	@Select({
        "<script>",
        "SELECT COUNT(*) FROM inquiry_board",
        "<where>",
        "  <if test='category != null and keyword != null'>",
        "    <choose>",
        "      <when test='category == \"title\"'>AND inquiry_title LIKE CONCAT('%', #{keyword}, '%')</when>",
        "      <when test='category == \"content\"'>AND inquiry_content LIKE CONCAT('%', #{keyword}, '%')</when>",
        "      <otherwise>AND (inquiry_title LIKE CONCAT('%', #{keyword}, '%') OR inquiry_content LIKE CONCAT('%', #{keyword}, '%'))</otherwise>",
        "    </choose>",
        "  </if>",
        "</where>",
        "</script>"
    })
	int count(Map<String, Object> paging);
	
	// 문의사항 조회
//	@Select({"SELECT ib.inquiry_id, u.username, ib.inquiry_title, ib.created_date",
//		   	 "FROM inquiry_board ib",
//		   	 "JOIN users u ON ib.writer_id = u.user_id",
//		   	 "ORDER BY ib.inquiry_id DESC",
//		   	 "LIMIT #{start}, #{count}"})
//	List<InquiryListDto> inquiryList(Map<String, Object> paging);
	
	@Select({
        "<script>",
        "SELECT ib.inquiry_id, u.username, ib.inquiry_title, ib.created_date",
        "FROM inquiry_board ib",
        "JOIN users u ON ib.writer_id = u.user_id",
        "<where>",
        "  <if test='category != null and keyword != null'>",
        "    <choose>",
        "      <when test='category == \"title\"'>AND ib.inquiry_title LIKE CONCAT('%', #{keyword}, '%')</when>",
        "      <when test='category == \"content\"'>AND ib.inquiry_content LIKE CONCAT('%', #{keyword}, '%')</when>",
        "      <otherwise>AND (ib.inquiry_title LIKE CONCAT('%', #{keyword}, '%') OR ib.inquiry_content LIKE CONCAT('%', #{keyword}, '%'))</otherwise>",
        "    </choose>",
        "  </if>",
        "</where>",
        "ORDER BY ib.inquiry_id DESC",
        "LIMIT #{start}, #{count}",
        "</script>"
    })
	List<InquiryListDto> inquiryList(Map<String, Object> paging);

	// 문의사항 상세 조회
	@Select({"SELECT ib.*, u.user_id, u.username FROM inquiry_board ib",
			 "JOIN users u ON ib.writer_id = u.user_id",
			 "WHERE inquiry_id = #{id}"})
	@Results({
	    @Result(column = "user_id", property = "writer.userId"),
	    @Result(column = "username", property = "writer.username")
	})
	InquiryBoard inquiryOne(@Param("id") int id);
}
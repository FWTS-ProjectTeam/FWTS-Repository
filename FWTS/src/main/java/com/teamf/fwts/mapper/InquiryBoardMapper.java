package com.teamf.fwts.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.teamf.fwts.dto.InquiryListDto;
import com.teamf.fwts.entity.InquiryBoard;

@Mapper
public interface InquiryBoardMapper {
	// 문의사항 수 확인
	int count(Map<String, Object> params);
	
	// 문의사항 내역 수 확인
	@Select("SELECT COUNT(*) FROM inquiry_board WHERE writer_id = #{writerId}")
	int countByWriterId(@Param("writerId") Integer writerId);
	
	// 문의사항 조회
	List<InquiryListDto> findAll(Map<String, Object> params);
	
	// 문의사항 내역 조회
	@Select({"SELECT ib.inquiry_id, u.username, ib.inquiry_title, ib.created_date",
			 "FROM inquiry_board ib",
			 "JOIN users u ON ib.writer_id = u.user_id",
			 "WHERE ib.writer_id = #{writerId}",
			 "ORDER BY ib.inquiry_id DESC",
			 "LIMIT #{start}, #{count}"})
	List<InquiryListDto> findByWriterId(Map<String, Integer> params);

	// 문의사항 상세 조회
	@Select({"SELECT ib.*, u.user_id, u.username FROM inquiry_board ib",
			 "JOIN users u ON ib.writer_id = u.user_id",
			 "WHERE inquiry_id = #{id}"})
	@Results({
	    @Result(column = "user_id", property = "writer.userId"),
	    @Result(column = "username", property = "writer.username")
	})
	InquiryBoard findByInquiryId(@Param("id") int id);

	// 문의사항 작성
	@Insert({"INSERT INTO inquiry_board (inquiry_title, inquiry_content, writer_id)",
            "VALUES (#{inquiryTitle}, #{inquiryContent}, #{writer.userId})"})
	@Options(useGeneratedKeys = true, keyProperty = "inquiryId")
	void saveInquiry(InquiryBoard newInquiry);
	
	// 문의사항 수정
	@Update({"UPDATE inquiry_board SET",
			"inquiry_title = #{inquiryTitle}, inquiry_content = #{inquiryContent}",
			"WHERE inquiry_id = #{inquiryId}"})
    void updateInquiry(InquiryBoard oldInquiry);
	
	// 문의사항 삭제
	@Delete("DELETE FROM inquiry_board WHERE inquiry_id = #{id}")
	void deleteInquiryById(int id);
	
	// 답변 작성
	@Update({"UPDATE inquiry_board SET reply = #{reply}, reply_date = NOW()",
			"WHERE inquiry_id = #{inquiryId}"})
	void saveReply(InquiryBoard newInquiry);
	
	// 답변 수정
	@Update("UPDATE inquiry_board SET reply = #{reply} WHERE inquiry_id = #{inquiryId}")
	void updateReply(InquiryBoard oldInquiry);
}
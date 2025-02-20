package com.teamf.fwts.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.teamf.fwts.dto.NoticeListDto;
import com.teamf.fwts.entity.NoticeBoard;

@Mapper
public interface NoticeBoardMapper {
	// 공지사항 수 확인
	@Select("SELECT COUNT(*) FROM notice_board")
	int count();
	
	// 공지사항 조회
	@Select({"SELECT notice_id, notice_title, created_date",
			 "FROM notice_board ORDER BY notice_id DESC",
			 "LIMIT #{start}, #{count}"})
	List<NoticeListDto> findAll(Map<String, Object> params);

	// 공지사항 상세 조회
	@Select("SELECT * FROM notice_board WHERE notice_id = #{id}")
	NoticeBoard findByNoticeId(@Param("id") int id);
	
	// 공지사항 작성
	@Insert({"INSERT INTO notice_board (notice_title, notice_content)",
            "VALUES (#{noticeTitle}, #{noticeContent})"})
	@Options(useGeneratedKeys = true, keyProperty = "noticeId")
	void saveNotice(NoticeBoard newNotice);
	
	// 공지사항 수정
	@Update({"UPDATE notice_board SET",
			"notice_title = #{noticeTitle}, notice_content = #{noticeContent}",
			"WHERE notice_id = #{noticeId}"})
    void updateNotice(NoticeBoard oldNotice);
	
	// 공지사항 삭제
	@Delete("DELETE FROM notice_board WHERE notice_id = #{id}")
	void deleteNoticeById(int id);
}
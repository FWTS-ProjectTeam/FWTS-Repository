package com.teamf.fwts.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.teamf.fwts.dto.NoticeListDto;
import com.teamf.fwts.entity.NoticeBoard;

@Mapper
public interface NoticeBoardMapper {
	// 공지사항 조회
	@Select({"SELECT notice_id, notice_title, created_date",
			 "FROM notice_board ORDER BY notice_id DESC",
			 "LIMIT #{start}, #{count}"})
	List<NoticeListDto> noticeList(Map<String, Object> paging);
	
	// 공지사항 수 확인
	@Select("SELECT COUNT(*) FROM notice_board")
	int count();

	// 공지사항 상세 조회
	@Select("SELECT * FROM notice_board WHERE notice_id = #{id}")
	NoticeBoard noticeOne(@Param("id") int id);
}
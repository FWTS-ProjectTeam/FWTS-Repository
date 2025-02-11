package com.teamf.fwts.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.teamf.fwts.dto.NoticeListDto;
import com.teamf.fwts.entity.NoticeBoard;
import com.teamf.fwts.mapper.NoticeBoardMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class NoticeBoardService {
	private final NoticeBoardMapper noticeBoardMapper;

	// 공지사항 조회
	public List<NoticeListDto> noticeList(Map<String, Object> paging) {
		return noticeBoardMapper.noticeList(paging);
	}
	
	// 공지사항 수 확인
	public int count() {
		return noticeBoardMapper.count();
	}

	// 공지사항 상세 조회
	public NoticeBoard noticeOne(int id) {
		return noticeBoardMapper.noticeOne(id);
	}
}
package com.teamf.fwts.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.teamf.fwts.dao.NoticeBoardDao;
import com.teamf.fwts.dto.NoticeListDto;
import com.teamf.fwts.entity.NoticeBoard;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class NoticeBoardService {
	private final NoticeBoardDao noticeBoardDao;

	// 공지사항 조회
	public List<NoticeListDto> noticeList(Map<String, Object> paging) {
		return noticeBoardDao.noticeList(paging);
	}
	
	// 공지사항 수 확인
	public int count() {
		return noticeBoardDao.count();
	}

	// 공지사항 상세 조회
	public NoticeBoard noticeOne(int id) {
		return noticeBoardDao.noticeOne(id);
	}
}
package com.teamf.fwts.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.teamf.fwts.dto.NoticeListDto;
import com.teamf.fwts.entity.NoticeBoard;
import com.teamf.fwts.mapper.NoticeBoardMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class NoticeBoardService {
	private final NoticeBoardMapper noticeBoardMapper;
	
	// 공지사항 수 확인
	public int count() {
		return noticeBoardMapper.count();
	}

	// 공지사항 조회
	public List<NoticeListDto> findAll(Map<String, Object> params) {
		return noticeBoardMapper.findAll(params);
	}

	// 공지사항 상세 조회
	public NoticeBoard findByNoticeId(int id) {
		return noticeBoardMapper.findByNoticeId(id);
	}

	// 공지사항 작성
	@Transactional
	public void saveNotice(NoticeBoard newNotice) {
		noticeBoardMapper.saveNotice(newNotice);
	}
	
	// 공지사항 수정
	@Transactional
	public void updateNotice(NoticeBoard oldNotice) {
		noticeBoardMapper.updateNotice(oldNotice);
	}
	
	// 공지사항 삭제
	@Transactional
	public void deleteNoticeById(int id) {
		noticeBoardMapper.deleteNoticeById(id);
	}
}
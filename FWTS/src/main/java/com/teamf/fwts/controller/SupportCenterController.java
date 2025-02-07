package com.teamf.fwts.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.teamf.fwts.dto.InquiryListDto;
import com.teamf.fwts.dto.NoticeListDto;
import com.teamf.fwts.entity.NoticeBoard;
import com.teamf.fwts.service.InquiryBoardService;
import com.teamf.fwts.service.NoticeBoardService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/support-center")
public class SupportCenterController {
	private final NoticeBoardService noticeBoardService;
	private final InquiryBoardService inquiryBoardService;
	
	// 공지사항 조회
	@GetMapping("/notice")
	public String noticeList(@RequestParam(name = "page", defaultValue = "1") int page, Model model) {
	    int count = noticeBoardService.count();

	    if (count > 0) {
	        int perPage = 8; // 한 페이지에 보여줄 수
	        int startRow = (page - 1) * perPage;
	        int totalPages = (int) Math.ceil((double) count / perPage); // 전체 페이지 수

	        Map<String, Object> paging = new HashMap<>();
	        paging.put("start", startRow);
	        paging.put("count", perPage);

	        List<NoticeListDto> notices = noticeBoardService.noticeList(paging);

	        model.addAttribute("notices", notices);
	        model.addAttribute("currentPage", page);
	        model.addAttribute("totalPages", totalPages);
	    }

	    model.addAttribute("count", count);
	    return "support/notice";
	}
	
	// 공지사항 상세 조회
	@GetMapping("/notice/{id}")
	public String noticeDetail(@PathVariable("id") int id, Model model) {
		NoticeBoard notice = noticeBoardService.noticeOne(id);
		
		model.addAttribute("notice", notice);
		return "support/notice-detail";
	}
	
	// 문의사항 조회
	@GetMapping("/inquiry")
    public String inquiryAll(@RequestParam(name = "page", defaultValue = "1")  int page, Model model) {
		int count = inquiryBoardService.count();

	    if (count > 0) {
	        int perPage = 8; // 한 페이지에 보여줄 수
	        int startRow = (page - 1) * perPage;
	        int totalPages = (int) Math.ceil((double) count / perPage); // 전체 페이지 수

	        Map<String, Object> paging = new HashMap<>();
	        paging.put("start", startRow);
	        paging.put("count", perPage);

	        List<InquiryListDto> inquirys = inquiryBoardService.inquiryList(paging);

	        model.addAttribute("inquirys", inquirys);
	        model.addAttribute("currentPage", page);
	        model.addAttribute("totalPages", totalPages);
	        
	        System.out.println(inquirys);
	    }
		
	    model.addAttribute("count", count);
		return "support/inquiry";
    }
}
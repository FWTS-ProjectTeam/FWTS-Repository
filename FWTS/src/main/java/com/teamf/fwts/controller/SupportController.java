package com.teamf.fwts.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.teamf.fwts.dto.InquiryListDto;
import com.teamf.fwts.dto.NoticeListDto;
import com.teamf.fwts.dto.ReplyDto;
import com.teamf.fwts.entity.InquiryBoard;
import com.teamf.fwts.entity.NoticeBoard;
import com.teamf.fwts.service.InquiryBoardService;
import com.teamf.fwts.service.NoticeBoardService;
import com.teamf.fwts.service.UserService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/support-center")
public class SupportController {
	private final NoticeBoardService noticeBoardService;
	private final InquiryBoardService inquiryBoardService;
	private final UserService userService;
	
	// 공지사항 조회
	@GetMapping("/notices")
	public String noticeAll(@RequestParam(name = "page", defaultValue = "1") Integer page, Model model) {
	    int count = noticeBoardService.count();

	    if (count > 0) {
	        int perPage = 8; // 한 페이지에 보여줄 수
	        int startRow = (page - 1) * perPage; // 페이지 번호
	        int totalPages = (int) Math.ceil((double) count / perPage); // 전체 페이지 수

	        Map<String, Object> params = new HashMap<>();
	        params.put("start", startRow);
	        params.put("count", perPage);

	        List<NoticeListDto> notices = noticeBoardService.findAll(params);

	        model.addAttribute("notices", notices);
	        model.addAttribute("currentPage", page);
	        model.addAttribute("totalPages", totalPages);
	    }

	    model.addAttribute("count", count);
	    return "support/notice";
	}
	
	// 공지사항 상세 조회
	@GetMapping("/notices/{id}")
	public String noticeDetail(@PathVariable("id") int id, Model model) {
		NoticeBoard notice = noticeBoardService.findByNoticeId(id);
		
		model.addAttribute("notice", notice);
		return "support/notice-detail";
	}
	
	// 공지사항 편집 페이지
	@GetMapping("/notices/edit")
	public String editNoticeForm(@RequestParam(name = "id", required = false) Integer id, Model model) {
	    // 글 수정 처리
	    if (id != null) {
			NoticeBoard notice = noticeBoardService.findByNoticeId(id);
			
			if (notice == null)
		    	return "redirect:/support-center/notices"; // 공지사항 페이지
			
		    model.addAttribute("notice", notice);
	    }

	    return "support/edit-notice";
	}
	
	// 공지사항 편집
	@PostMapping("/notices/edit")
	public String editNotice(@Valid NoticeBoard notice, BindingResult bindingResult, Model model) {
	    // 유효성 검사
	    if (bindingResult.hasErrors()) {
	    	if (bindingResult.hasFieldErrors("noticeContent"))
	    		notice.setNoticeContent(null);
	    	
	    	model.addAttribute("validMessage", "제목 또는 내용을 입력하세요.");
	        model.addAttribute("notice", notice);
	        return "support/edit-notice";
	    }

	    try {
	    	Integer noticeId;
	    	
	        // 글 작성
	        if (notice.getNoticeId() == null) {
	        	noticeBoardService.saveNotice(notice);
	            noticeId = notice.getNoticeId();
	        }
	        
	        // 글 수정
	        else {
	            NoticeBoard oldNotice = noticeBoardService.findByNoticeId(notice.getNoticeId());

	            oldNotice.setNoticeTitle(notice.getNoticeTitle());
	            oldNotice.setNoticeContent(notice.getNoticeContent());
	            noticeBoardService.updateNotice(oldNotice);
	            
	            noticeId = oldNotice.getNoticeId();
	        }

	        return "redirect:/support-center/notices/" + noticeId; // 문의사항 페이지
	    } catch (Exception e) {
	        model.addAttribute("errorMessage", "처리 중 오류가 발생했습니다. 다시 시도해 주세요.");
	        model.addAttribute("notice", notice);
	        return "support/edit-notice";
	    }
	}
	
	// 공지사항 삭제
	@ResponseBody
	@DeleteMapping("/notices/delete/{id}")
	public Map<String, Boolean> deleteNotice(@PathVariable("id") int id) {
	    Map<String, Boolean> response = new HashMap<>();
	    
	    try {
	    	noticeBoardService.deleteNoticeById(id);
	        response.put("success", true);
	    } catch (Exception e) {
	        response.put("success", false);
	    }
	    
	    return response;
	}
	
	// 문의사항 조회
	@GetMapping("/inquirys")
    public String inquiryAll(@RequestParam(name = "category", required = false) String category,
    	    				 @RequestParam(name = "keyword", required = false) String keyword,
    	    				 @RequestParam(name = "page", defaultValue = "1")  Integer page,
    						 Model model) {
		// 카테고리 값 검증
		category = Optional.ofNullable(category)
                .filter(Set.of("all", "title", "content")::contains)
                .orElse(null);

		Map<String, Object> params = new HashMap<>();
		params.put("category", category);
		params.put("keyword", keyword);
        
		int count = inquiryBoardService.count(params);

	    if (count > 0) {
	        int perPage = 8; // 한 페이지에 보여줄 수
	        int startRow = (page - 1) * perPage; // 페이지 번호
	        int totalPages = (int) Math.ceil((double) count / perPage); // 전체 페이지 수

	        params.put("start", startRow);
	        params.put("count", perPage);

	        List<InquiryListDto> inquirys = inquiryBoardService.findAll(params);
	        
	        model.addAttribute("inquirys", inquirys);
	        model.addAttribute("currentPage", page);
	        model.addAttribute("totalPages", totalPages);
	    }
	    
	    model.addAttribute("count", count);
	    model.addAttribute("category", category);
	    model.addAttribute("keyword", keyword);
		return "support/inquiry";
    }
	
	// 문의사항 상세 조회
	@GetMapping("/inquirys/{id}")
	public String inquiryDetail(@PathVariable("id") int id, Model model) {
		InquiryBoard inquiry = inquiryBoardService.findByInquiryId(id);
		
		model.addAttribute("inquiry", inquiry);
		return "support/inquiry-detail";
	}
	
	// 문의사항 편집 페이지
	@GetMapping("/inquirys/edit")
	public String editInquiryForm(@RequestParam(name = "id", required = false) Integer id, 
	                          	  Authentication authentication, Model model) {
	    // 글 수정 처리
	    if (id != null) {
			InquiryBoard inquiry = inquiryBoardService.findByInquiryId(id);
		    if (inquiry == null)
		    	return "redirect:/support-center/inquiry"; // 문의사항 페이지

		    // 작성자 검증
		    String writerUsername = inquiry.getWriter().getUsername();
		    if (!writerUsername.equals(authentication.getName()))
		        return "redirect:/support-center/inquiry"; // 문의사항 페이지
		    
		    model.addAttribute("inquiry", inquiry);
	    }

	    return "support/edit-inquiry";
	}
	
	// 문의사항 편집
	@PostMapping("/inquirys/edit")
	public String editInquiry(@Valid InquiryBoard inquiry, BindingResult bindingResult,
	                          Authentication authentication, Model model) {
	    // 유효성 검사
	    if (bindingResult.hasErrors()) {
	    	if (bindingResult.hasFieldErrors("inquiryContent"))
	    		inquiry.setInquiryContent(null);
	    	
	    	model.addAttribute("validMessage", "제목 또는 내용을 입력하세요.");
	        model.addAttribute("inquiry", inquiry);
	        return "support/edit-inquiry";
	    }

	    try {
	    	Integer inquiryId;
	    	
	        // 글 작성
	        if (inquiry.getInquiryId() == null) {
	        	inquiry.setWriter(userService.findByUsername(authentication.getName()));
	            inquiryBoardService.saveInquiry(inquiry);
	            inquiryId = inquiry.getInquiryId();
	        }
	        
	        // 글 수정
	        else {
	            InquiryBoard oldInquiry = inquiryBoardService.findByInquiryId(inquiry.getInquiryId());
	            String writerUsername = oldInquiry.getWriter().getUsername();

	            // 작성자이면 기존 글 업데이트
	            if (writerUsername.equals(authentication.getName())) {
		            oldInquiry.setInquiryTitle(inquiry.getInquiryTitle());
		            oldInquiry.setInquiryContent(inquiry.getInquiryContent());
		            inquiryBoardService.updateInquiry(oldInquiry);
	            }
	            
	            inquiryId = oldInquiry.getInquiryId();
	        }

	        return "redirect:/support-center/inquirys/" + inquiryId; // 문의사항 페이지
	    } catch (Exception e) {
	        model.addAttribute("errorMessage", "처리 중 오류가 발생했습니다. 다시 시도해 주세요.");
	        model.addAttribute("inquiry", inquiry);
	        return "support/edit-inquiry";
	    }
	}

	// 문의사항 삭제
	@ResponseBody
	@DeleteMapping("/inquirys/delete/{id}")
	public Map<String, Boolean> deleteInquiry(@PathVariable("id") int id, Authentication authentication) {
	    Map<String, Boolean> response = new HashMap<>();
	    
	    try {
	    	InquiryBoard inquiry = inquiryBoardService.findByInquiryId(id);
		    String currentUsername = inquiry.getWriter().getUsername();
		    
		    // 작성자 검증 및 처리
		    if (currentUsername.equals(authentication.getName())) {
		    	inquiryBoardService.deleteInquiryById(id);
		        response.put("success", true);
		    } else {
		    	response.put("success", false);
		    }
	    } catch (Exception e) {
	        response.put("success", false);
	    }
	    
	    return response;
	}
	
	// 답변 편집
	@PostMapping("/inquirys/reply/{id}")
	public String editReply(@PathVariable("id") int id, ReplyDto dto, Model model) {
		InquiryBoard inquiry = inquiryBoardService.findByInquiryId(id);
		inquiry.setReply(dto.getReply());
		
		try {
			// 답변 작성
			if (inquiry.getReplyDate() == null)
				inquiryBoardService.saveReply(inquiry);
			
			// 답변 수정
			else {
				inquiry.setReplyDate(dto.getReplyDate());
				inquiryBoardService.updateReply(inquiry);
			}
			
			return "redirect:/support-center/inquirys/" + id;
		} catch (Exception e) {
	        model.addAttribute("errorMessage", "처리 중 오류가 발생했습니다. 다시 시도해 주세요.");
	        model.addAttribute("inquiry", inquiry);
	        return "support/inquiry-detail";
	    }
	}
}
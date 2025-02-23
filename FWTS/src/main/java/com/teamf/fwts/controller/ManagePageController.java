package com.teamf.fwts.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.teamf.fwts.dto.UserListDto;
import com.teamf.fwts.entity.Users;
import com.teamf.fwts.service.UserService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/manage-page")
public class ManagePageController {
	private final UserService userService;
	
	// 도매업자 조회
	@GetMapping("/wholesalers")
	public String wholesalerAll(@RequestParam(name = "category", required = false) String category,
								@RequestParam(name = "keyword", required = false) String keyword,
								@RequestParam(name = "isLimited", defaultValue = "false") Boolean isLimited,
								@RequestParam(name = "page", defaultValue = "1")  Integer page,
								Model model) {
		// 카테고리 값 검증
		category = Optional.ofNullable(category)
	            .filter(Set.of("username", "email", "companyName", "ceoName")::contains)
	            .orElse(null);
		
		Map<String, Object> params = new HashMap<>();
		params.put("role", 1);
		params.put("category", category);
	    params.put("keyword", keyword);
	    params.put("isLimited", isLimited);
		
		int count = userService.count(params);
		
		if (count > 0) {
			int perPage = 20; // 한 페이지에 보여줄 수
			int startRow = (page - 1) * perPage; // 페이지 번호
			int totalPages = (int) Math.ceil((double) count / perPage); // 전체 페이지 수
			
			params.put("start", startRow);
			params.put("count", perPage);
			
			List<UserListDto> users = userService.findAll(params);
			
			model.addAttribute("users", users);
			model.addAttribute("currentPage", page);
			model.addAttribute("totalPages", totalPages);
		}
		
		model.addAttribute("count", count);
		model.addAttribute("tCategory", category);
		model.addAttribute("tKeyword", keyword);
		model.addAttribute("isLimited", isLimited);
		return "managepage/wholesalers";
	}
	
	// 소매업자 조회
	@GetMapping("/retailers")
	public String retailerAll(@RequestParam(name = "category", required = false) String category,
							  @RequestParam(name = "keyword", required = false) String keyword,
							  @RequestParam(name = "isLimited", defaultValue = "false") Boolean isLimited,
							  @RequestParam(name = "page", defaultValue = "1")  Integer page,
							  Model model) {
		// 카테고리 값 검증
		category = Optional.ofNullable(category)
		.filter(Set.of("username", "email", "companyName", "ceoName")::contains)
		.orElse(null);
		
		Map<String, Object> params = new HashMap<>();
		params.put("role", 2);
		params.put("category", category);
		params.put("keyword", keyword);
		params.put("isLimited", isLimited);
		
		int count = userService.count(params);
		
		if (count > 0) {
		int perPage = 20; // 한 페이지에 보여줄 수
		int startRow = (page - 1) * perPage; // 페이지 번호
		int totalPages = (int) Math.ceil((double) count / perPage); // 전체 페이지 수
		
		params.put("start", startRow);
		params.put("count", perPage);
		
		List<UserListDto> users = userService.findAll(params);
		
		model.addAttribute("users", users);
		model.addAttribute("currentPage", page);
		model.addAttribute("totalPages", totalPages);
		}
		
		model.addAttribute("count", count);
		model.addAttribute("category", category);
		model.addAttribute("keyword", keyword);
		model.addAttribute("isLimited", isLimited);
		return "managepage/retailers";
	}
	
	// 제한 여부 변경
	@ResponseBody
	@PostMapping("/users/update/{id}")
	public Map<String, Boolean> updateUserStatus(@PathVariable("id") Integer id) {
		Map<String, Boolean> response = new HashMap<>();
	    
		try {
			Users user = userService.findByUserId(id);
	        user.setLimited(!user.isLimited());
		    userService.updateUserStatus(user);
		    
	        response.put("success", true);
	        response.put("isLimited", user.isLimited());
	    } catch (Exception e) {
	        response.put("success", false);
	    }
	    
	    return response;
	}
}
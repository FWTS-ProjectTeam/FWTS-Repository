package com.teamf.fwts.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.teamf.fwts.dto.UserListDto;
import com.teamf.fwts.service.UserService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/manage-page")
public class ManagePageController {
	private final UserService userService;
	
	@GetMapping("/users")
	public String userManagementForm(@RequestParam(name = "page", defaultValue = "1") Integer page, Model model) {
		int count = userService.count();

	    if (count > 0) {
	        int perPage = 10; // 한 페이지에 보여줄 수
	        int startRow = (page - 1) * perPage; // 페이지 번호
	        int totalPages = (int) Math.ceil((double) count / perPage); // 전체 페이지 수

	        Map<String, Object> params = new HashMap<>();
	        params.put("start", startRow);
	        params.put("count", perPage);

	        List<UserListDto> users = userService.findAll(params);

	        model.addAttribute("users", users);
	        model.addAttribute("currentPage", page);
	        model.addAttribute("totalPages", totalPages);
	    }

	    model.addAttribute("count", count);
		return "managepage/user-management";
	}
}
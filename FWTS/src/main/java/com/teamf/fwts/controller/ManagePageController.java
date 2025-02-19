package com.teamf.fwts.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.teamf.fwts.service.UserService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/manage-page")
public class ManagePageController {
	private final UserService userService;
	
	@GetMapping("/user")
	public String userManagementForm(Model model) {
		return "managepage/user-management";
	}
}
package com.teamf.fwts.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MypageController {

    @GetMapping("/mypage/orders")
    public String myOrders(Model model) {
        model.addAttribute("activeMenu", "orders"); // ✅ 주문 내역 활성화
        return "order/orders"; // ✅ orders.jsp로 이동
    }

    @GetMapping("/mypage/profile")
    public String myProfile(Model model) {
        model.addAttribute("activeMenu", "profile"); // ✅ 내 정보 관리 활성화
        return "mypage/profile"; 
    }

    @GetMapping("/mypage/cart")
    public String myCart(Model model) {
        model.addAttribute("activeMenu", "cart"); // ✅ 장바구니 활성화
        return "mypage/cart";
    }

    @GetMapping("/mypage/inquiries")
    public String myInquiries(Model model) {
        model.addAttribute("activeMenu", "inquiries"); // ✅ 문의 내역 활성화
        return "mypage/inquiries";
    }
}

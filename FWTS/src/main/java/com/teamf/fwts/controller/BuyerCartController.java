package com.teamf.fwts.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.security.core.Authentication;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.teamf.fwts.entity.Cart;
import com.teamf.fwts.service.BuyerCartService;
import com.teamf.fwts.service.UserService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/buyer")
@RequiredArgsConstructor // private final 자동 추가
public class BuyerCartController {
	private final BuyerCartService cartService;
	private final UserService userService;
	
	// 장바구니에 상품 추가
	@GetMapping("/addToCart")
	public String addToCart(@RequestParam("proId") Integer proId,
							@RequestParam("quantity") Integer quantity,
							RedirectAttributes redirectAttributes) {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login"; // 로그인 안 된 경우 로그인 페이지로 이동
        }

        String username = authentication.getName(); 
        int buyerId = userService.findByUsername(username).getUserId(); // 로그인한 사용자의 ID 조회

        boolean success = cartService.addToCart(buyerId, proId, quantity);

        if (success) {
            redirectAttributes.addFlashAttribute("message", "✅ 장바구니에 추가되었습니다!");
        } else {
            redirectAttributes.addFlashAttribute("message", "⚠ 장바구니 추가 실패!");
        }
		
		return "redirect:/products/buy/" + proId; // 상품 목록으로 리다이렉트
	}
	
	// 장바구니 리스트 조회 (로그인한 사용자만 조회)
	@GetMapping("/carts")
	public String cartList(
	    @RequestParam(value = "page", defaultValue = "1") int page, 
	    Model model) {

	    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    if (authentication == null || !authentication.isAuthenticated()) {
	        return "redirect:/login"; // 로그인 안 된 경우 로그인 페이지로 이동
	    }

	    String username = authentication.getName();
	    int buyerId = userService.findByUsername(username).getUserId();

	    int pageSize = 3; // ✅ 한 페이지에 3개씩
	    int offset = (page - 1) * pageSize;
	    int totalItems = cartService.getCartCount(buyerId);
	    int totalPages = (int) Math.ceil((double) totalItems / pageSize);

	    List<Cart> cartList = cartService.getPagedCartList(buyerId, offset, pageSize);

	    model.addAttribute("cartList", cartList);
	    model.addAttribute("currentPage", page);
	    model.addAttribute("totalPages", totalPages);

	    return "cart/carts";
	}
	
	// 장바구니 특정 상품 삭제
	@PostMapping("/removeFromCart")
	@ResponseBody
	public Map<String, String> removeFromCart(@RequestParam("cartId") int cartId) {
	    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    
	    Map<String, String> response = new HashMap<>();

	    if (cartId <= 0) { // 🚨 잘못된 cartId 체크
	        response.put("status", "error");
	        response.put("message", "❌ 잘못된 장바구니 ID입니다.");
	        return response;
	    }
	    
	    if (authentication == null || !authentication.isAuthenticated()) {
	        response.put("status", "error");
	        response.put("message", "로그인이 필요합니다.");
	        return response;
	    }

	    // 로그인된 사용자 ID 가져오기
	    String username = authentication.getName();
	    int buyerId = userService.findByUsername(username).getUserId();

	    // 삭제 실행 (로그인한 사용자의 장바구니만 삭제)
	    boolean success = cartService.deleteCartItem(buyerId, cartId);

	    if (success) {
	        response.put("status", "success");
	        response.put("message", "장바구니에서 삭제되었습니다.");
	    } else {
	        response.put("status", "error");
	        response.put("message", "장바구니 삭제 실패.");
	    }

	    return response;
	}
}

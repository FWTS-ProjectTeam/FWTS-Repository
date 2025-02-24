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

import com.teamf.fwts.dto.Cart;
import com.teamf.fwts.service.BuyerCartService;
import com.teamf.fwts.service.BuyerOrderService;
import com.teamf.fwts.service.UsersService;
import lombok.RequiredArgsConstructor;

@RequestMapping("/buyer")
@RequiredArgsConstructor // private final 자동 추가
@Controller
public class BuyerCartController {

	private final BuyerCartService cartService;
	private final UsersService userService;
	
	// ✅ 장바구니에 상품 추가
	@PostMapping("/addToCart")
	public String addToCart(@RequestParam("proId") int proId,
							@RequestParam("selectedQuantity") int selectedQuantity,
							RedirectAttributes redirectAttributes) {
		// Q. 왜 proId와 selectedQauntity만 요청 파라미터로 받는가?
		// A. buyerId는 Spring Security를 통해 로그인된 사용자의 정보를 가져올 수 있기 때문
		//    + 클라이언트(브라우줘)에서는 buyer_id를 직접 보낼 필요 x -> 보안상 안전
		//    + buyerId는 서버에서 SecurityContextHolder를 통해 로그인된 사용자의 정보를 가져와 자동으로 조회
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login"; // 로그인 안 된 경우 로그인 페이지로 이동
        }

        String username = authentication.getName(); 
        int buyerId = userService.findByUsername(username).getUserId(); // 로그인한 사용자의 ID 조회

        boolean success = cartService.addToCart(buyerId, proId, selectedQuantity);

        if (success) {
            redirectAttributes.addFlashAttribute("message", "✅ 장바구니에 추가되었습니다!");
        } else {
            redirectAttributes.addFlashAttribute("message", "⚠ 장바구니 추가 실패!");
        }
		
		return "redirect:/productList"; // 상품 목록으로 리다이렉트
	}
	
	// ✅ 장바구니 리스트 조회 (로그인한 사용자만 조회)
	@GetMapping("/cartList")
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

	    return "cart/cart_list";
	}
	
	// ✅ 장바구니 특정 상품 삭제
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

	    // ✅ 로그인된 사용자 ID 가져오기
	    String username = authentication.getName();
	    int buyerId = userService.findByUsername(username).getUserId();

	    // ✅ 삭제 실행 (로그인한 사용자의 장바구니만 삭제)
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

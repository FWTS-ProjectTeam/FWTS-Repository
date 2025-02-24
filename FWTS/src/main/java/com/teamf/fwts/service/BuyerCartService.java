package com.teamf.fwts.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.teamf.fwts.dto.Cart;
import com.teamf.fwts.mapper.BuyerCartMapper;

@Service
public class BuyerCartService {
	
	// 생성자 주입
    private final BuyerCartMapper cartDao;

    public BuyerCartService(BuyerCartMapper cartDao) {
        this.cartDao = cartDao;
    }
    
    // ✅ 장바구니 추가
    public boolean addToCart(int buyerId, int proId, int selectedQuantity) {
    	return cartDao.insertCart(buyerId, proId, selectedQuantity) > 0;
    }
    
    // ✅ 기존 전체 장바구니 조회 유지
    public List<Cart> getCartList(int buyerId) {
        return cartDao.getCartList(buyerId);
    }

    // ✅ 장바구니 총 개수 조회
    public int getCartCount(int buyerId) {
        return cartDao.getCartCount(buyerId);
    }

    // ✅ 페이징된 장바구니 조회
    public List<Cart> getPagedCartList(int buyerId, int offset, int limit) {
        return cartDao.getPagedCartList(buyerId, offset, limit);
    }
    
    // ✅ 장바구니에서 특정 상품 삭제
    public boolean deleteCartItem(int buyerId, int cartId) {
        return cartDao.removeCartItem(buyerId, cartId) > 0;
    }
}

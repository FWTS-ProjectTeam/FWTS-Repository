<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    
<div class="sidebar">
	<h2>마이페이지</h2>
	<a href="/my-page/info" class="profile-active">내 정보 관리</a>
            
	<!-- 도매업자 항목 -->
	<sec:authorize access="hasRole('ROLE_SELLER')">
		<a href="/products/shopM/${sellerId}"  class="product-active">상품 관리</a>
		<a href="#"  class="order-active">주문 관리</a>
		<a href="/my-page/inquiry-history"  class="inquiry-active">문의 내역</a>
		<a href="#"  class="stats-active">통계</a>
	</sec:authorize>
	<!-- 소매업자 항목 -->
	<sec:authorize access="hasRole('ROLE_BUYER')">
		<a href="#"  class="cart-active">장바구니</a>
		<a href="#"  class="order-active">주문 내역</a>
		<a href="/my-page/inquiry-history"  class="inquiry-active">문의 내역</a>
	</sec:authorize>
	
</div>
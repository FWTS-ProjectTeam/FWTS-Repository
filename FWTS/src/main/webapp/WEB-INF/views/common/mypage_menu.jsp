<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- ✅ 마이페이지 사이드 메뉴 -->
<div class="mypage-menu">
    <h2>마이페이지</h2>
    <ul>
        <li class="${activeMenu == 'profile' ? 'active' : ''}">
            <a href="/mypage/profile">내 정보 관리</a>
        </li>
        <li class="${activeMenu == 'cart' ? 'active' : ''}">
            <a href="/mypage/cart">장바구니</a>
        </li>
        <li class="${activeMenu == 'orders' ? 'active' : ''}">
            <a href="/mypage/orders">주문 내역</a>
        </li>
        <li class="${activeMenu == 'inquiries' ? 'active' : ''}">
            <a href="/mypage/inquiries">문의 내역</a>
        </li>
    </ul>
</div>

<!-- ✅ 스타일 -->
<style>
    .mypage-menu {
        width: 200px;
        padding: 20px;
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.1);
    }
    .mypage-menu h2 {
        font-size: 18px;
        font-weight: bold;
        margin-bottom: 10px;
    }
    .mypage-menu ul {
        list-style: none;
        padding: 0;
        margin: 0;
    }
    .mypage-menu ul li {
        padding: 10px;
        text-align: left;
    }
    .mypage-menu ul li a {
        text-decoration: none;
        color: #333;
        display: block;
    }
    .mypage-menu ul li.active {
        background-color: #ff6080; /* ✅ 현재 페이지 활성화 색상 */
        color: white;
        border-radius: 5px;
    }
    .mypage-menu ul li.active a {
        color: white;
        font-weight: bold;
    }
</style>

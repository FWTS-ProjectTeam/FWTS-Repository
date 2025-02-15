<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="header">
    <div class="header-left">
        <h1>생화24</h1>
        <div class="search-container">
            <input class="search-box" type="text" placeholder="찾으시는 꽃을 입력해주세요!">
            <button class="search-button">
                <i class="fas fa-search"></i>
            </button>
        </div>
    </div>
    <div class="header-right">
        <sec:authorize access="isAnonymous()">
            <a href="/login"><strong>로그인</strong></a>
            <a href="/sign-up">회원가입</a>
        </sec:authorize>

        <sec:authorize access="isAuthenticated()">
            <a href="/logout">로그아웃</a>
        </sec:authorize>
    </div>
</div>

<div class="nav-container">
    <div class="nav">
        <a href="#">절화</a>
        <a href="#">난</a>
        <a href="#">관엽</a>
        <a href="#">기타</a>
    </div>
    <div class="nav-right">
        <a href="/mypage/edit-profile">마이페이지</a>
        <a href="/support-center/notice">고객센터</a>
    </div>
</div>
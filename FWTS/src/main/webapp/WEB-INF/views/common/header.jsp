<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="header">
    <div class="header-left">
        <h1>생화24</h1>
        
        <!-- 검색 -->
        <div class="search-container">
            <input class="search-box" placeholder="찾으시는 꽃을 입력해주세요!">
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
    	<!-- 관리자 항목 -->
    	<sec:authorize access="hasRole('ROLE_ADMIN')">
		    <a href="/manage-page/wholesalers">관리페이지</a>
		</sec:authorize>
		
		<!-- 비관리자 항목 -->
		<sec:authorize access="!hasRole('ROLE_ADMIN')">
		    <a href="/my-page/info">마이페이지</a>
		</sec:authorize>
		
        <a href="/support-center/notices">고객센터</a>
    </div>
</div>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="header">
    <div class="header-left">
		<a href="/FWTS" class="special-font">생화24</a>
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
				<a href="/products" class="${category == 'all' ? 'active' : ''}">
					<span style="color: var(--main4);">ALL</span>
				</a>
				<a href="/products?category=1" class="${category == 1 ? 'active' : ''}">절화</a>
				<a href="/products?category=2" class="${category == 2 ? 'active' : ''}">난</a>
				<a href="/products?category=3" class="${category == 3 ? 'active' : ''}">관엽</a>
				<a href="/products?category=4" class="${category == 4 ? 'active' : ''}">기타</a>
			</div>
    <div class="nav-right">
    	<!-- 관리자 항목 -->
    	<sec:authorize access="hasRole('ROLE_ADMIN')">
		    <a href="/manage-page/user">관리페이지</a>
		</sec:authorize>
		
		<!-- 비관리자 항목 -->
		<sec:authorize access="!hasRole('ROLE_ADMIN')">
		    <a href="/my-page/info">마이페이지</a>
		</sec:authorize>
		
        <a href="/support-center/notice">고객센터</a>
    </div>
</div>
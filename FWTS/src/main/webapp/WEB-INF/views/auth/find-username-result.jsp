<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>생화24 - 아이디 찾기</title>
<link rel="stylesheet" href="/resources/css/auth.css">
<style>
    .username {
        font-size: 18px;
        font-weight: 600;
        color: #ff6699;
        margin-bottom: 20px;
    }
</style>
</head>
<body>
<div class="container">
	<c:choose>
		<c:when test="${not empty username}">
	     	<h1>아이디 찾기 성공</h1>
	     	<p class="result-message"><strong>${email}</strong>에 등록된 아이디입니다.</p>
	     	<div class="username">
	        	<p>${username}</p>
	    	</div>
		</c:when>
	    <c:otherwise>
	    	<h1>아이디 찾기 실패</h1>
	    	<p class="result-message"><strong>${email}</strong>에 등록된 아이디가 없습니다.</p>
	    </c:otherwise>
	</c:choose>

    <div class="button-container">
        <button onclick="location.href='/login'">로그인 하기</button>
    </div>

    <div class="links-container">
        <a href="/find-id">계속 찾으러 가기</a>
    </div>
</div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>생화 24 - 고객센터</title>
<link rel="stylesheet" href="/resources/css/common.css">
<link rel="stylesheet" href="/resources/css/sidebar.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<style>
    .sidebar .notice-active {
    	font-weight: 600;
        background-color: #ff7f9d;
        color: #fff;
        border-radius: 5px;
    }
    
    .post-container {
    	width: 100%;
    	margin: 50px 10px 0px 10px;
     	background: white;
    }
    .post-content {
    	padding: 20px;
    	border-top: 1px solid #ccc;
        border-bottom: 1px solid #ccc;
    }
    
    .post-content .title {
        font-weight: bold;
        text-align: center;
        margin-bottom: 10px;
    }
    .post-content .date {
        text-align: right;
        color: gray;
        font-size: 0.9em;
    }
    .post-content img {
	    max-width: 100%; /* 이미지가 컨테이너를 초과하지 않도록 설정 */
	    height: auto; /* 비율에 맞게 이미지 크기 조정 */
	}
    
    .button-container {
        text-align: center;
        margin-top: 20px;
    }
    .button-container button {
        background: #ff7f9d;
        color: white;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }
</style>
</head>
<body>
<div class="container">
    <!-- 공통 -->
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
    
    <div class="body-container">
        <!-- 사이드바 -->
    	<%@ include file="/WEB-INF/views/common/support-sidebar.jsp" %>
        
        <div class="post-container">
        	<div class="post-content">
        		<h2 class="title">${notice.noticeTitle}</h2>
		       	<p class="date">작성일: <fmt:formatDate value="${notice.createdDate}" pattern="yyyy.MM.dd HH:mm" /></p>
		       	<p>${notice.noticeContent}</p>
        	</div>
	      	<div class="button-container">
	          	<button onclick="location.href='/support-center/notice'">목록</button>
	      	</div>
  		</div>
    </div>
</div>
</body>
</html>
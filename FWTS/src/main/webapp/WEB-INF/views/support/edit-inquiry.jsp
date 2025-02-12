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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript" src="/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #fff;
        color: #333;
    }
    .container {
        width: 80%;
        margin: 0 auto;
    }
    .header {
        display: flex;
        justify-content: space-between;
        align-items: flex-end;
        padding: 0px 10px;
        margin: 20px 10px 15px 10px;
        position: relative;
    }
    .header-left {
        display: flex;
        align-items: center;
    }
    .header-left h1 {
    	font-size: 36px;
    	color:#ff3366;
    	margin: 0px;
    }
    .header-right {
        display: flex;
    }
    .header-right a {
        font-size: 13px;
        text-decoration: none;
        color: #333;
        margin-left: 10px;
    }
    .search-container {
    	width: 240px;
        display: flex;
        align-items: center;
        border: 1px solid #ccc;
        border-radius: 5px;
        padding: 10px;
        font-size: 16px;
        margin-left: 110px;
        background-color: #fff;
    }
    .search-box {
        border: none;
        outline: none;
        flex-grow: 1;
    }        
    .search-button {
        background: none;
        border: none;
        cursor: pointer;
        font-size: 16px;
        color: #ff3366;
        padding: 5px;
    }
    .nav-container {
        display: flex;
        justify-content: space-between;
        border: 1px solid #ccc; /* 상단 메뉴 구분선 */
        border-radius: 10px;
        padding: 20px;
        align-items: flex-end;
    }
    .nav a {
        font-size: 20px;
        font-weight: 600;
        text-decoration: none;
        color: #333;
        margin-right: 30px;
    }
    .nav-right a {
        text-decoration: none;
        color: #FF748B;
        font-size: 16px;
        font-weight: 600;
        margin-left: 10px;
    }
    .body-container {
    	display: flex;
    	margin: 20px;
    }
    .sidebar {
    	width: 180px; /* 사이드 메뉴 너비 고정 */
        min-width: 180px;
        max-width: 180px;
        padding: 10px;
        border: 1px solid #ccc;
        background-color: #fff;
        border-radius: 10px;
        margin-right: 20px;
        align-self: flex-start; /* 내부 콘텐츠 크기만큼 높이 조정 */
    }
    .sidebar h2 {
        font-size: 18px;
        margin-bottom: 10px;
    }
    .sidebar a {
        display: block;
        padding: 10px;
        text-decoration: none;
        color: #333;
        cursor: pointer;
    }
    .sidebar .active {
    	font-weight: 600;
        background-color: #ff7f9d;
        color: #fff;
        border-radius: 5px;
    }
    .search-board-container {
    	display: flex;
     	align-items: center;
     	justify-content: end;
     	margin-bottom: 20px;
 	}
 	.search-category {
 		width: 80px;
     	padding: 10px;
     	border: 1px solid #ccc;
     	border-radius: 5px;
     	font-size: 16px;
     	background-color: #fff;
     	margin-right: 10px;
 	}
 	.search-board-box {
 		width: 280px;
     	padding: 10px;
     	border: 1px solid #ccc;
     	border-radius: 5px;
     	font-size: 16px;
     	outline: none;
 	}
 	.search-board-button {
     	padding: 10px 15px;
     	border: none;
     	border-radius: 5px;
     	background-color: #ff7f9d;
     	color: #fff;
     	font-size: 16px;
     	font-weight: 600;
     	cursor: pointer;
     	margin-left: 10px;
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
    .title {
    	width: 100%;
    	padding: 10px;
    	font-size: 24px;
    	border: 1px solid #ccc;
    	outline: none;
        font-weight: 600;
        margin-bottom: 16px;
        box-sizing: border-box;
    }
	textarea {
		width: 100%;
	}
    .section {
        background: #f0f0f0;
        padding: 10px;
        border-radius: 5px;
        margin-top: 10px;
    }
    .button-container {
	    display: flex;
	    justify-content: space-between;  /* 버튼들을 양쪽 끝에 배치 */
	    margin-top: 20px;
	    gap: 10px;  /* 버튼 사이의 간격 */
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
		   <!-- 로그인하지 않은 경우 -->
		   <sec:authorize access="isAnonymous()">
		       <a href="/login"><strong>로그인</strong></a>
		       <a href="/sign-up">회원가입</a>
		   </sec:authorize>
		
		   <!-- 로그인한 경우 -->
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
    
    <div class="body-container">
        <div class="sidebar">
            <h2>고객센터</h2>
            <a href="/support-center/notice">공지사항</a>
            <a href="/support-center/inquiry" class="active">문의사항</a>
        </div>
        
        <form class="post-container" id="post-container" action="/support-center/inquiry/edit" method="post">
        	<input type="hidden" name="inquiryId" value="${inquiry.inquiryId}">
        	
        	<div class="post-content">
        		<input class="title" name="inquiryTitle" value="${inquiry.inquiryTitle}" maxlength="64" placeholder="제목을 입력해주세요"/>
       			<div id="smarteditor">
		      		<textarea id="content" name="inquiryContent" rows="20"></textarea>
	     		</div>
        	</div>
	  		<div class="button-container">
	  			<button type="button" onclick="history.back()">뒤로</button>
	  			<button type="button" onclick="submitPostForm()">저장</button>
	      	</div>
  		</form>
    </div>
</div>
<script>
	let oEditors = [];

	smartEditor = function() {
	   	console.log("Naver SmartEditor");
	   	nhn.husky.EZCreator.createInIFrame({
	        oAppRef: oEditors,
	        elPlaceHolder: "content",
	        sSkinURI: "/smarteditor/SmartEditor2Skin.html",
	        fOnAppLoad: function() {
                const content = `${inquiry.inquiryContent}`;
                oEditors.getById["content"].exec("PASTE_HTML", [content]);
	        },
	        fCreator: "createSEditor2"
       	});
       	
     	// 유효성 검사 실패
		<c:if test="${not empty errorMessage}">
			alert("${errorMessage}");
		</c:if>
	};
	
	$(document).ready(function() {
	   	smartEditor();
	});
	
	// 스마트에디터 내용 전송
	function submitPostForm() {
	   const form = document.getElementById("post-container");
	   
	   oEditors.getById["content"].exec("UPDATE_CONTENTS_FIELD", []);
	   form.requestSubmit(); // 폼 제출 실행
   }
</script>
</body>
</html>
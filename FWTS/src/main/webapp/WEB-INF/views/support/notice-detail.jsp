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
    	font-size: 14px;
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
        font-weight: bold;
        text-align: center;
        margin-bottom: 10px;
    }
    .date {
        text-align: right;
        color: gray;
        font-size: 0.9em;
    }
    .section {
        background: #f0f0f0;
        padding: 10px;
        border-radius: 5px;
        margin-top: 10px;
    }
    .button-container {
    	justify-content: center;
        margin: 20px auto;
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
	      	
			<!-- 관리자 항목: 삭제, 수정 버튼 -->
			<sec:authorize access="hasRole('ROLE_ADMIN')">
				<div class="button-container multiple">
		    		<button class="button" onclick="deleteNotice()">삭제</button>
					<button class="button" onclick="location.href='/support-center/notices'">목록</button>
	            	<button class="button" onclick="location.href='/support-center/notices/edit?id=${notice.noticeId}'">수정</button>
            	</div>
            </sec:authorize>
			
			<!-- 비관리자 항목 -->
			<sec:authorize access="!hasRole('ROLE_ADMIN')">
				<div class="button-container">
		    		<button class="button" onclick="location.href='/support-center/notices'">목록</button>
            	</div>
            </sec:authorize>
  		</div>
    </div>
    
    <!-- 푸터 -->
    <%@ include file="/WEB-INF/views/common/footer.jsp"%>
</div>
<script>
	// 글 삭제
	function deleteNotice() {
		Swal.fire({
	        title: "정말로 삭제하시겠습니까?",
	        text: "이 작업은 되돌릴 수 없습니다!",
	        icon: "warning",
	        showCancelButton: true,
	        confirmButtonColor: "#d33",
	        cancelButtonColor: "#aaa",
	        confirmButtonText: "삭제",
	        cancelButtonText: "취소"
	    }).then((result) => {
	        if (result.isConfirmed) {
	        	const requestUrl = "/support-center/notices/delete/" + ${notice.noticeId};
	
	        	fetch(requestUrl, { method: "DELETE" })
	    	    .then(response => response.json())
	    	    .then(data => {
	    	        if (data.success) {
	    	            window.location.href = "/support-center/notices";  // 성공 시 페이지 리다이렉트
	    	        } else if (data.errorMessage) {
	    	            Swal.fire({
	    	                icon: 'error',
	    	                title: '삭제 실패',
	    	                text: data.errorMessage,
	    	                confirmButtonColor: '#d33',
	    	                confirmButtonText: '확인'
	    	            });
	    	        } else {
	    	        	throw new Error("서버 오류");
	    	        }
	    	    })
	    	    .catch(error => {
	    	        Swal.fire({
	    	            icon: 'error',
	    	            title: '삭제 실패',
	    	            text: '처리 중 오류가 발생했습니다. 다시 시도해 주세요.',
	    	            confirmButtonColor: '#d33',
	    	            confirmButtonText: '확인'
	    	        });
	    	    });
	        }
	    });
	}
</script>
</body>
</html>
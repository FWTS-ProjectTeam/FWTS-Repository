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
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
    .write-info {
    	display: flex;
	    justify-content: space-between; /* 왼쪽, 오른쪽 정렬 */
	    align-items: center; /* 수직 중앙 정렬 */
	    color: gray;
        font-size: 0.9em;
    }
    .comment-content {
    	padding: 20px;
    	border-top: 1px solid #ccc;
        border-bottom: 1px solid #ccc;
        margin-top: 50px;
    }
    .comment-content .date {
        text-align: right;
        color: gray;
        font-size: 0.9em;
    }
    .title {
        font-weight: 600;
        text-align: center;
        margin-bottom: 10px;
    }
    .comment-title {
        font-weight: 600;
        margin-bottom: 10px;
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
             <a href="#">마이페이지</a>
             <a href="/support-center/notice">고객센터</a>
         </div>
     </div>
     
	<div class="body-container">
		<!-- 사이드바 -->
    	<%@ include file="/WEB-INF/views/common/support-sidebar.jsp" %>
         
        <div class="post-container">
         	<div class="post-content">
				<h2 class="title">${inquiry.inquiryTitle}</h2>
			    <div class="write-info">
			        <p class="writer">작성자: ${inquiry.writer.username}</p>
			        <p class="date">작성일: <fmt:formatDate value="${inquiry.createdDate}" pattern="yyyy.MM.dd HH:mm" /></p>
			    </div>
			    <p>${inquiry.inquiryContent}</p>
			</div>
	
			<!-- 현재 로그인한 사용자가 작성한 글이면 버튼 표시 -->
			<sec:authorize access="isAuthenticated()">
			    <sec:authentication property="principal.username" var="currentUser"/>
			    <c:if test="${currentUser eq inquiry.writer.username}">
			        <div class="button-container">
			            <button onclick="deleteInquiry()">삭제</button>
			            <button onclick="location.href='/support-center/inquiry/edit?id=${inquiry.inquiryId}'">수정</button>
			        </div>
			    </c:if>
			</sec:authorize>
      
      		<c:if test="${not empty inquiry.reply}">
			    <div class="reply-content">
			        <h2 class="title">답변</h2>
			        <p class="date">작성일: <fmt:formatDate value="${inquiry.replyDate}" pattern="yyyy.MM.dd HH:mm" /></p>
			        <p id="old-reply">${inquiry.reply}</p>
			        
			        <!-- 관리자 항목  -->
			        <sec:authorize access="hasRole('ROLE_ADMIN')">
				        <div class="button-container">
				            <button id="update-button" class="button" onclick="toggleEditMode()">수정</button>
			            </div>
			        </sec:authorize>
			
			        <!-- 관리자 항목: 수정 폼 -->
			        <form id="edit-reply-form" class="hidden" action="/support-center/inquirys/reply/${inquiry.inquiryId}" method="post">
			            <input type="hidden" name="inquiryId" value="${inquiry.inquiryId}">
			            <textarea name="reply" id="edit-reply-textarea" rows="10" maxlength="2000" oninput="countChars(this)">${inquiry.reply}</textarea>
			            <div class="button-container multiple">
			   				<button type="button" class="button" onclick="toggleEditMode()">취소</button>
			   				<p id="char-count">0 / 1000자</p>
			                <button type="submit" class="button">저장</button>
			            </div>
			        </form>
			    </div>
			</c:if>
			
			<c:if test="${empty inquiry.reply}">
				<!-- 관리자 항목: 작성 폼 -->
				<sec:authorize access="hasRole('ROLE_ADMIN')">
				    <form class="reply-content" action="/support-center/inquirys/reply/${inquiry.inquiryId}" method="post">
				        <h2 class="title">답변</h2>
			            <input type="hidden" name="inquiryId" value="${inquiry.inquiryId}">
			            <textarea name="reply" rows="10" maxlength="2000" oninput="countChars(this)">${inquiry.reply}</textarea>
			            <div class="button-container multiple">
			            	<p id="char-count">0 / 1000자</p>
			            	<button type="submit" class="button">저장</button>
			            </div>
				    </form>
				</sec:authorize>
			</c:if>
  		</div>
    </div>
    
    <!-- 푸터 -->
    <%@ include file="/WEB-INF/views/common/footer.jsp"%>
</div>
<script>
	// 페이지 로드 시 실행
	window.onload = function () {
		<c:if test="${not empty errorMessage}">
			Swal.fire({
				icon: 'error',
				title: '저장 실패',
				text: "${errorMessage}",
				confirmButtonColor: '#d33',
				confirmButtonText: '확인'
			});
		</c:if>
	};

	// 글 삭제
	function deleteInquiry() {
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
	            const requestUrl = `/support-center/inquiry/delete/${inquiry.inquiryId}`;
	
	            fetch(requestUrl, { method: "DELETE" })
	            .then(response => response.json())
	            .then(data => {
	                if (data.success) {
	                	window.location.href = "/support-center/inquirys"; // 문의사항 페이지
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
	
	// 답변 수정 필드 활성화
	function toggleEditMode() {
		var form = document.getElementById("edit-reply-form");
	    var oldReply = document.getElementById("old-reply");
	    var updateButton = document.getElementById("update-button");

	    if (form.classList.contains("hidden")) {
	    	form.classList.remove("hidden"); // 수정 폼 표시
	        oldReply.style.display = "none"; // 기존 답변 숨김
	        updateButton.style.display = "none"; // 수정 버튼 숨김
	        
	        var textarea = document.getElementById("edit-reply-textarea");
	        countChars(textarea); // 글자 수 업데이트
	    } else {
	    	form.classList.add("hidden"); // 수정 폼 숨김
	        oldReply.style.display = "block"; // 기존 답변 표시
	        updateButton.style.display = "block"; // 수정 버튼 표시
	    }
	}
	
	// 글자 수 세기
	function countChars(textarea) {
	    var maxLength = 1000;
	    var currentLength = textarea.value.length;

	    if (currentLength > maxLength) {
	        textarea.value = textarea.value.substring(0, maxLength); // 1000자 초과 시 잘라내기
	        currentLength = maxLength;
	    }

	    document.getElementById("char-count").innerText = currentLength + " / " + maxLength + "자";
	}
</script>
</body>
</html>
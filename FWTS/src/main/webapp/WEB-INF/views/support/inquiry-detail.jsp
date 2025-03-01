<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>생화 24 - 문의사항</title>
<link rel="stylesheet" href="/resources/css/common.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<style>
    .sidebar .inquiry-active {
    	font-weight: 600;
        background-color: #ff7f9d;
        color: white;
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
    .post-content .write-info {
    	display: flex;
	    justify-content: space-between; /* 왼쪽, 오른쪽 정렬 */
	    align-items: center; /* 수직 중앙 정렬 */
    }
    .post-content img {
	    max-width: 100%; /* 이미지가 컨테이너를 초과하지 않도록 설정 */
	    height: auto; /* 비율에 맞게 이미지 크기 조정 */
	}
    
    .post-container .title {
        font-weight: 600;
        text-align: center;
        margin: 16px 0 10px 0;
    }
    .post-container .writer,
    .post-container .date {
        color: gray;
        font-size: 14px;
    }
    
    .post-content .date {
        text-align: right;
    }
    
    .reply-content {
    	padding: 20px;
    	border-top: 1px solid #ccc;
        border-bottom: 1px solid #ccc;
        margin-top: 50px;
    }
    
    .reply-content .date {
        text-align: right;
    }
    
    .button-container {
        justify-content: center;
        margin: 20px auto;
    }
    
    .reply-content textarea {
	    width: 100%;
	    padding: 12px;
	    margin: 14px 0;
	    border: 1px solid #ddd;
	    border-radius: 6px;
	    resize: none;
	    outline: none;
	    transition: border-color 0.3s;
	    box-sizing: border-box; /* 패딩을 포함해 전체 너비 100%로 설정 */
	}
    .reply-content textarea:focus {
        border-color: #ff6699;
    }
	.reply-content .button-container {
        margin: 0;
    }
    .reply-content #char-count {
    	margin: 0;
    	font-size: 14px;
    }
    
   	.hidden {
		display: none;
	}
	
	.multiple {
        justify-content: space-between; /* 버튼이 여러 개일 때 좌우 정렬 */
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
				<h2 class="title">${inquiry.inquiryTitle}</h2>
			    <div class="write-info">
			        <p class="writer">작성자: ${inquiry.writer.username}</p>
			        <p class="date">작성일: <fmt:formatDate value="${inquiry.createdDate}" pattern="yyyy.MM.dd HH:mm" /></p>
			    </div>
			    <p>${inquiry.inquiryContent}</p>
			</div>
	
			<!-- 로그인 사용자 - 작성자일 경우: 삭제, 수정 버튼 -->
			<sec:authorize access="isAuthenticated()">
			    <sec:authentication property="principal.username" var="currentUser"/>
			    <div class="button-container ${currentUser eq inquiry.writer.username ? 'multiple' : ''}">
			        <c:if test="${currentUser eq inquiry.writer.username}">
			            <button class="button" onclick="deleteInquiry()">삭제</button>
			        </c:if>
			        <button class="button" onclick="location.href='/support-center/inquirys'">목록</button>
					<c:if test="${currentUser eq inquiry.writer.username}">
			            <button class="button" onclick="location.href='/support-center/inquirys/edit?id=${inquiry.inquiryId}'">수정</button>
			        </c:if>
			    </div>
			</sec:authorize>
			
			<!-- 비로그인 사용자 -->
			<sec:authorize access="isAnonymous()">
			    <div class="button-container">
			        <button class="button" onclick="location.href='/support-center/inquirys'">목록</button>
			    </div>
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
	        	const requestUrl = "/support-center/inquirys/delete/" + ${inquiry.inquiryId};
	
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
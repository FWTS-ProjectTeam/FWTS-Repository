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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<style>
    .sidebar .inquiry-active {
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
    .post-content .write-info {
    	display: flex;
	    justify-content: space-between; /* 왼쪽, 오른쪽 정렬 */
	    align-items: center; /* 수직 중앙 정렬 */
	    color: gray;
    }
    .post-content img {
	    max-width: 100%; /* 이미지가 컨테이너를 초과하지 않도록 설정 */
	    height: auto; /* 비율에 맞게 이미지 크기 조정 */
	}
    
    .post-container .title {
        font-weight: 600;
        text-align: center;
        margin-bottom: 10px;
    }
    .post-container .date {
        text-align: right;
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
    
    .button-container {
        display: flex;
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
			            <button onclick="deleteInquiry()">삭제</button>
			        </c:if>
			        <button onclick="location.href='/support-center/inquiry'">목록</button>
					<c:if test="${currentUser eq inquiry.writer.username}">
			            <button onclick="location.href='/support-center/inquiry/edit?id=${inquiry.inquiryId}'">수정</button>
			        </c:if>
			    </div>
			</sec:authorize>
			
			<!-- 비로그인 사용자 -->
			<sec:authorize access="isAnonymous()">
			    <div class="button-container">
			        <button onclick="location.href='/support-center/inquiry'">목록</button>
			    </div>
			</sec:authorize>
      
      		<c:if test="${not empty inquiry.reply}">
			    <div class="comment-content">
			        <h2 class="title">답변</h2>
			        <p class="date">작성일: 
			            <fmt:formatDate value="${inquiry.replyDate}" pattern="yyyy.MM.dd HH:mm" />
			        </p>
			        <p>${inquiry.reply}</p>
			    </div>
			</c:if>
  		</div>
    </div>
</div>
<script>
	function deleteInquiry(inquiryId) {
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
	            .then(response => {
	                if (!response.ok) {
	                    throw new Error('서버 오류');
	                }
	                return response.json();
	            })
	            .then(data => {
	                if (data.success) {
	                	window.location.href = "/support-center/inquiry"; // 문의사항 페이지
	                } else {
	                	Swal.fire({
	    					icon: 'error',
	    					title: '삭제 실패',
	    					text: '존재하지 않거나 삭제 권한이 없는 글입니다.',
	    					confirmButtonColor: '#d33',
	    					confirmButtonText: '확인'
	    				});
	                }
	            })
	            .catch(error => {
	            	Swal.fire({
    					icon: 'error',
    					title: '오류 발생',
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
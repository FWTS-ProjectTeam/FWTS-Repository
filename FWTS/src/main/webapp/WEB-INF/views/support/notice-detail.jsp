<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    .sidebar .notice-active {
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
    .post-content .title {
        font-weight: bold;
        text-align: center;
        margin: 16px 0 10px 0;
    }
    .post-content .date {
        text-align: right;
        color: gray;
        font-size: 14px;
    }
    
    .post-content img {
	    max-width: 100%; /* 이미지가 컨테이너를 초과하지 않도록 설정 */
	    height: auto; /* 비율에 맞게 이미지 크기 조정 */
	}
    
    .button-container {
        margin: 20px auto;
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
        		<h2 class="title">${notice.noticeTitle}</h2>
		       	<p class="date">작성일: <fmt:formatDate value="${notice.createdDate}" pattern="yyyy.MM.dd HH:mm" /></p>
		       	<p>${notice.noticeContent}</p>
        	</div>
	      	
			<!-- 관리자일 경우: 삭제, 수정 버튼 -->
			<div class="button-container multiple">
	    		<sec:authorize access="hasRole('ROLE_ADMIN')">
		            <button class="button" onclick="deleteNotice()">삭제</button>
				</sec:authorize>
				
				<button class="button" onclick="location.href='/support-center/notices'">목록</button>
				
				<sec:authorize access="hasRole('ROLE_ADMIN')">
	            	<button class="button" onclick="location.href='/support-center/notices/edit?id=${notice.noticeId}'">수정</button>
            	</sec:authorize>
			</div>
  		</div>
    </div>
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
	            .then(response => {
	                if (!response.ok) {
	                    throw new Error('서버 오류');
	                }
	                return response.json();
	            })
	            .then(data => {
	                if (data.success) {
	                    window.location.href = "/support-center/notices";
	                } else {
	                    Swal.fire({
	                        icon: 'error',
	                        title: '삭제 실패',
	                        text: '존재하지 않는 글입니다.',
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
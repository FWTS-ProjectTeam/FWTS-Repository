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
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript" src="/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>
<style>
    .sidebar .notice-active {
    	font-weight: 600;
        background-color: #ff7f9d;
        color: white;
        border-radius: 5px;
    }
 	
	.post-form {
	    width: 100%;
	    margin: 50px 10px 0 10px;
	    background: white;
	    display: block;
	}
	.post-content {
	    padding: 20px;
	    border-top: 1px solid #ccc;
	    border-bottom: 1px solid #ccc;
	}
	.post-content .title {
	    width: 100%;
	    padding: 10px;
	    font-size: 24px;
	    border: 1px solid #ccc;
	    outline: none;
	    font-weight: 600;
	    margin-bottom: 16px;
	    box-sizing: border-box;
	}
	.post-content textarea {
	    width: 99.6%;
	    box-sizing: border-box; /* 패딩을 포함해 전체 너비 100%로 설정 */
	}

    .button-container {
	    justify-content: space-between;  /* 버튼들을 양쪽 끝에 배치 */
	    margin-top: 20px;
	    gap: 10px;  /* 버튼 사이의 간격 */
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
        
        <form class="post-form" id="post-form" action="/support-center/notices/edit" method="post">
        	<input type="hidden" name="noticeId" value="${notice.noticeId}">
        	
        	<div class="post-content">
        		<input class="title" name="noticeTitle" value="${notice.noticeTitle}" maxlength="64" placeholder="제목을 입력해주세요"/>
       			<div id="smarteditor">
		      		<textarea id="content" name="noticeContent" rows="30"></textarea>
	     		</div>
        	</div>
	  		<div class="button-container">
	  			<button type="button" class="button" onclick="cancelAction()">취소</button>
	  			<button type="button" class="button" onclick="submitPostForm()">저장</button>
	      	</div>
  		</form>
    </div>
    <%@ include file="/WEB-INF/views/common/footer.jsp"%>
</div>
<script>
	var oEditors = [];
	
	smartEditor = function() {
	   	console.log("Naver SmartEditor");
	   	nhn.husky.EZCreator.createInIFrame({
	        oAppRef: oEditors,
	        elPlaceHolder: "content",
	        sSkinURI: "/smarteditor/SmartEditor2Skin.html",
	        fOnAppLoad: function() {
                const content = `${notice.noticeContent}`;
                oEditors.getById["content"].exec("PASTE_HTML", [content]);
	        },
	        fCreator: "createSEditor2"
       	});
       	
	 	// 유효성 검사 실패
     	<c:if test="${not empty validMessage}">
			alert("${validMessage}");
		</c:if>
     	
		// 서버 오류
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
	
	$(document).ready(function() {
	   	smartEditor();
	});
	
	// 스마트에디터 내용 전송
	function submitPostForm() {
		const form = document.getElementById("post-form");
	   	oEditors.getById["content"].exec("UPDATE_CONTENTS_FIELD", []);
	   	form.requestSubmit(); // 폼 제출 실행
   	}
	
	// 취소 버튼 클릭 시 실행
	function cancelAction() {
		const noticeId = "${notice.noticeId}";
		
	    // 글 작성인지, 수정인지에 따라 처리
	    if (noticeId) {
            window.location.href = "/support-center/notices/" + noticeId;
        } else {
            window.location.href = "/support-center/notices";
        }
	}
</script>
</body>
</html>
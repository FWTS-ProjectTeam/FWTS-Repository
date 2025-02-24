<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    String email = (String) session.getAttribute("email");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>생화24 - 비밀번호 찾기</title>
<link rel="stylesheet" href="/resources/css/auth.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<style>
    .input-group {
	    width: 100%;
	    text-align: left;
	    margin-bottom: 20px;
	}
    
    .row-group {
	    display: flex;
	    gap: 10px; /* 입력 필드와 버튼 사이 여백 */
	}
	.row-group input {
	    flex: 1; /* 입력 필드가 남은 공간을 다 차지하도록 */
	}
	.row-group input:focus {
		border-color: var(--pink2);
	}
	
	.resend-code {
		width: 80px;
		background: white;
	    color: var(--pink3);
	    border: 1px solid var(--pink3);
	    padding: 8px 12px;
	    font-size: 12px;
	    border-radius: 8px;
	}
	.resend-code:hover {
	    background: var(--pink3);
	    color: white;
	}
</style>
</head>
<body>
<div class="container">
    <h1>이메일 인증</h1>
    <p class="description">
        <strong><%= email %></strong>으로 인증 코드를 전송했습니다.
    </p>

    <form id="code-content" action="/find-password/verify-code" method="post" onsubmit="return validateForm()">
        <div class="input-group">
		   <label for="code">인증 코드</label>
		   <div class="row-group">
		       <input id="code" name="code" placeholder="6자리 인증 코드를 입력해주세요" maxlength="6"
		       		  oninput="this.value = this.value.replace(/[^0-9]/g, '');">
		       <button type="button" class="resend-code" onclick="resendCode()">재전송</button>
		    </div>
		</div>

         <div class="button-container">
             <button type="submit">확인</button>
         </div>
     </form>

     <div class="links-container">
         <a href="/find-password">이전으로 돌아가기</a>
     </div>
</div>
<script>
	// 인증 실패 알림창
	window.onload = function() {
		<c:if test="${not empty errorMessage}">
			Swal.fire({
				icon: 'error',
				title: '인증 실패',
				text: "${errorMessage}", 
				confirmButtonColor: '#d33',
				confirmButtonText: '확인'
			});
		</c:if>
	};
	
	// 유효성 검사
	function validateForm() {
		const form = document.getElementById("code-content");
		const code = document.getElementById("code").value;
	  
		if (!code) {
			alert("인증 코드를 입력해주세요.");
			return false;
		}
	
		form.requestSubmit(); // 폼 제출 실행
	}
  
	// 인증 코드 재전송
	function resendCode() {
		const messageElement = document.querySelector(".description");
		
	    // 로딩 메시지 표시
	    Swal.fire({ title: "코드 전송 중...", didOpen: () => Swal.showLoading() });

	 	// API 요청
	    fetch("/find-password/resend-code", {
	        method: 'POST'
	    })
	    .then(response => {
	        Swal.close(); // 로딩창 닫기

	        if (response.ok) {
	        	messageElement.innerHTML = `<strong>${email}</strong>으로 인증 코드를 전송했습니다.`;
	        } else {
	        	throw new Error('서버 오류');
	        }
	    })
	    .catch(() => {
	    	Swal.close();
      	    Swal.fire({
      	        icon: 'error',
      	        title: '재전송 실패',
      	        text: '처리 중 오류가 발생했습니다. 다시 시도해 주세요.',
      	        confirmButtonColor: '#d33',
      	        confirmButtonText: '확인'
      	    });
      	    
      	  	messageElement.innerHTML = `<span style="color: red;">인증 코드 재전송에 실패했습니다.</span>`;
	    });
	}
</script>
</body>
</html>
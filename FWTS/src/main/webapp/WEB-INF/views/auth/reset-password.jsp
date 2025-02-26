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
<title>생화24 - 비밀번호 재설정</title>
<link rel="stylesheet" href="/resources/css/auth.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<style>    
    .input-group {
        width: 100%;
        text-align: left;
        margin-bottom: 20px;
    }
    .input-group label {
        font-size: 14px;
    }
    .input-group input {
        width: 100%;
    }
    
    .password-field {
	    position: relative;
	    display: flex;
	    align-items: center;
	    width: 100%;
	}
	.password-field input {
	    padding-right: 40px; /* 아이콘 공간 확보 */
	}
	.password-field i {
	    position: absolute;
	    right: 10px;
	    cursor: pointer;
	    font-size: 18px;
	    color: var(--gray4);
	}
	.password-field i:hover {
		color: var(--pink2);
	}
	
	html, body {
	    height: auto;
	    min-height: 100vh;
	    overflow: auto;
	}
</style>
</head>
<body>
<div class="container">
    <h1>비밀번호 재설정</h1>
    <p class="description">새 비밀번호를 입력해주세요.</p>

    <form id="password-content" action="/find-password/reset-password" method="post"> 
		<div class="input-group">
		   <label for="password">비밀번호</label>
		   <div class="password-field">
		       <input type="password" id="password" name="password" value="${inputData.password}" maxlength="20">
		       <i class="fa-solid fa-eye" id="toggle-password" onclick="togglePassword('password', this)"></i>
		    </div>
		</div>

		<div class="input-group">
		    <label for="confirm-password">비밀번호 확인</label>
		    <div class="password-field">
		        <input type="password" id="confirm-password" name="confirmPassword" value="${inputData.confirmPassword}" maxlength="20">
		       <i class="fa-solid fa-eye" id="toggle-confirm-password" onclick="togglePassword('confirm-password', this)"></i>
		    </div>
		</div>
	
	   <p class="error-message" id="error-message"></p>
	
	   <div class="button-container">
	       <button type="button" onclick="validateForm()">비밀번호 변경</button>
	    </div>
	</form>
</div>
<script>    
	// 재설정 실패 알림창
  	window.onload = function() {
      	<c:if test="${not empty errorMessage}">
          	Swal.fire({
              	icon: 'error',
              	title: '재설정 실패',
              	text: "${errorMessage}", 
              	confirmButtonColor: '#d33',
				confirmButtonText: '확인'
          	});
      	</c:if>
  	};
 
  	// 유효성 검사
    function validateForm() {
    	const form = document.getElementById("password-content");
      	var password = document.getElementById("password").value;
      	var confirmPassword = document.getElementById("confirm-password").value;
      	var errorMessage = document.getElementById("error-message");

      	// 비밀번호 정규식: 영문 + 숫자 + 특수문자 포함
      	var passwordRegex = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()_+=-])[A-Za-z\d!@#$%^&*()_+=-]*$/;

      	if (!password || !confirmPassword) {
      		alert("비밀번호를 입력해주세요.")
      		return false;
      	}
      	
      	if (password.length < 8) {
          	errorMessage.textContent = "비밀번호는 8~20자 이내여야 합니다.";
          	return false;
      	}

      	if (!passwordRegex.test(password)) {
          	errorMessage.textContent = "비밀번호는 영문, 숫자, 특수문자(!@#$%^&*()_+=-)를 포함해야 합니다.";
          	return false;
      	}

      	if (password !== confirmPassword) {
          	errorMessage.textContent = "비밀번호가 일치하지 않습니다.";
          	return false;
      	}

      	errorMessage.textContent = "";
      	form.submit(); // 폼 제출
  	}
  
  	// 비밀번호 표시/숨기기
    function togglePassword(fieldId, icon) {
         const input = document.getElementById(fieldId);
         if (input.type === "password") {
             input.type = "text";
             icon.classList.remove("fa-eye");
             icon.classList.add("fa-eye-slash");
         } else {
             input.type = "password";
             icon.classList.remove("fa-eye-slash");
             icon.classList.add("fa-eye");
         }
	}
</script>
</body>
</html>
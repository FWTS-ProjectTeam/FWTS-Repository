<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String email = (String) session.getAttribute("email");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>생화24 - 비밀번호 재설정</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
        background-color: #fff;
        color: #333;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
    }
    .container {
        text-align: center;
        max-width: 400px;
        width: 100%;
        background-color: #fefefe;
        border: 1px solid #ddd;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }
    .container h1 {
        color: #ff6699;
        font-weight: 600;
        margin-bottom: 15px;
    }
    .description {
        font-size: 14px;
        color: #666;
        margin-bottom: 20px;
    }
    .input-group {
        width: 100%;
        text-align: left;
        margin-bottom: 20px;
    }
    .input-group label {
        font-size: 14px;
        font-weight: 600;
        display: block;
        margin-bottom: 5px;
    }
    .input-group input {
        width: 100%;
        padding: 12px;
        border: 1px solid #ddd;
        border-radius: 6px;
        font-size: 14px;
        outline: none;
        box-sizing: border-box;
    }
    .input-group input:focus {
        border-color: #ff6699;
    }
    .password-container {
	    position: relative;
	    display: flex;
	    align-items: center;
	    width: 100%;
	}
	.password-container input {
	    width: 100%;
	    padding: 12px;
	    border: 1px solid #ddd;
	    border-radius: 6px;
	    font-size: 14px;
	    outline: none;
	    box-sizing: border-box;
	    padding-right: 40px; /* 아이콘 공간 확보 */
	}
	.password-container i {
	    position: absolute;
	    right: 10px;
	    cursor: pointer;
	    font-size: 18px;
	    color: #888;
	}
	.password-container i:hover {
		color: #ff6699;
	}
    .button-container {
        display: flex;
        flex-direction: column;
        gap: 10px;
    }
    .button-container button {
        width: 100%;
        padding: 12px;
        font-size: 16px;
        font-weight: 600;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        background-color: #ff6699;
        color: #fff;
    }
    .error-message {
        color: red;
        font-size: 12px;
        margin-bottom: 10px;
    }
</style>
</head>
<body>
<div class="container">
    <h1>비밀번호 재설정</h1>
    <p class="description">새 비밀번호를 입력하세요.</p>

    <form id="password-content" action="/find-password/reset-password" method="post"> 
		<div class="input-group">
		   <label for="password">비밀번호</label>
		   <div class="password-container">
		       <input type="password" id="password" name="password" value="${inputData.password}" maxlength="20">
		       <i class="fa-solid fa-eye" id="toggle-password" onclick="togglePassword('password', this)"></i>
		    </div>
		</div>

		<div class="input-group">
		    <label for="confirm-password">비밀번호 확인</label>
		    <div class="password-container">
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
	// 인증 실패 알림창
  	window.onload = function() {
      	<c:if test="${not empty errorMessage}">
          	Swal.fire({
              	icon: 'error',
              	title: '오류 발생',
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
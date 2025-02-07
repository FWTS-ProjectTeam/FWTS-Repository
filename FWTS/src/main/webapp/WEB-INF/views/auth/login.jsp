<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>생화24 - 로그인</title>
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
    .login-container {
        text-align: center;
        max-width: 400px;
        width: 100%;
        background-color: #fefefe;
        border: 1px solid #ddd;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }
    .login-container h1 {
        margin-bottom: 20px;
    }
    .login-container h1 a {
    	text-decoration: none;
    	color: #ff6699;
    }
    .login-container input[type="text"],
    .login-container input[type="password"] {
        width: 100%;
        padding: 10px;
        margin: 10px 0;
        border: 1px solid #ddd;
        border-radius: 5px;
        box-sizing: border-box;
        outline: none;
    }
    .login-container input[type="text"]:focus,
    .login-container input[type="password"]:focus {
		border-color: #ff6699;
	}
    .remember-me {
        display: flex;
        align-items: center;
        justify-content: flex-start;
        margin: 10px 0;
    }
    .remember-me label {
        font-size: 14px;
    }
    .login-container button {
        width: 100%;
        padding: 10px;
        background-color: #ff6699;
        color: #fff;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 16px;
        font-weight: 600;
    }
    .login-container button:hover {
        background-color: #ff5577;
    }
    .links-container {
        display: flex;
        justify-content: space-between;
        margin-top: 15px;
        font-size: 14px;
    }
    .bold-text {
        font-weight: 600;
        text-decoration: none;
        color: #333;
    }
    .no-underline {
        text-decoration: none;
        color: #333;
    }
</style>
</head>
<script>
	//로그인 페이지 로드 시 실행
	window.onload = function () {
		// 로그인 실패 알림창
		<c:if test="${not empty errorMessage}">
			Swal.fire({
				icon: 'error',
				title: '로그인 실패',
				text: "${errorMessage}",
				confirmButtonColor: '#d33',
				confirmButtonText: '확인'
			});
		</c:if>
			
		var savedUsername = getCookie("savedUsername"); // 저장된 아이디 가져오기
	    if (savedUsername) {
	        document.querySelector("input[name='username']").value = savedUsername;
	        document.getElementById("remember").checked = true; // 체크박스 활성화
	    }
	};

    // 쿠키 설정 함수 (아이디 저장)
    function setCookie(name, value, days) {
    	var date = new Date();
        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000)); // days 일 후 만료
        document.cookie = name + "=" + value + ";expires=" + date.toUTCString() + ";path=/";
    }

    // 쿠키 가져오기
    function getCookie(name) {
    	var cookies = document.cookie.split('; ');
        for (var i = 0; i < cookies.length; i++) {
        	var parts = cookies[i].split('=');
            if (parts[0] === name) {
                return parts[1];
            }
        }
        return "";
    }
    
 	// 유효성 검사
	function validateForm() {
		const form = document.getElementById("login-content");
		const username = document.getElementById("username").value;
		const password = document.getElementById("password").value;
      
		if (!username || !password) {
			alert("아이디 또는 비밀번호를 입력하세요.");
			return;
		}

		form.requestSubmit(); // 폼 제출 실행
	}
</script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<body>
    <div class="login-container">
        <h1><a href="/">생화24</a></h1>
        <form id="login-content" action="/login" method="POST">
            <input type="text" id="username" name="username" placeholder="아이디를 입력하세요">
            <input type="password" id="password" name="password" placeholder="비밀번호를 입력하세요">
            
            <div class="remember-me">
                <input type="checkbox" id="remember">
                <label for="remember">아이디 저장</label>
            </div>
            <button type="button" onclick="validateForm()">로그인</button>
        </form>
        
        <div class="links-container">
            <a href="/sign-up" class="bold-text">회원가입</a>
            <div>
                <a href="/find-id" class="no-underline">아이디 찾기</a>
                <span>|</span>
                <a href="/find-password" class="no-underline">비밀번호 찾기</a>
            </div>
        </div>
    </div>
</body>
<script>
	//폼 제출 시 실행되는 함수
	document.querySelector("form").addEventListener("submit", function () {
	    var username = document.querySelector("input[name='username']").value;
	    var rememberMe = document.getElementById("remember").checked;
	
	    if (rememberMe) {
	        setCookie("savedUsername", username, 7); // 7일 동안 저장
	    } else {
	        setCookie("savedUsername", "", -1); // 쿠키 삭제
	    }
	    
	    form.requestSubmit(); // 폼 제출 실행
	});
</script>
</html>
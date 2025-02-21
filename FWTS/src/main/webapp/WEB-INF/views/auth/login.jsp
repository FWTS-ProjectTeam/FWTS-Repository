<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>생화24 - 로그인</title>
<link rel="stylesheet" href="/resources/css/auth.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<style>
    .container h1 {
        margin-bottom: 20px;
    }
    .container h1 a {
    	text-decoration: none;
    	color: #ff6699;
    }
    
    .input-group input {
        width: 100%;
        margin: 5px 0;
        box-sizing: border-box;
        outline: none;
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
    
    .links-container {
    	justify-content: space-between;
    }
    .links-container .normal {
        font-weight: normal;
    }
</style>
</head>
<body>
<div class="container">
    <h1><a href="/">생화24</a></h1>
    <form id="login-form" action="/login" method="POST">
    	<div class="input-group">
    		<input id="username" name="username" placeholder="아이디를 입력해주세요">
        	<input type="password" id="password" name="password" placeholder="비밀번호를 입력해주세요">
    	</div>
        
        <div class="remember-me">
            <input type="checkbox" id="remember">
            <label for="remember">아이디 저장</label>
        </div>
        <button type="button" onclick="validateForm()">로그인</button>
    </form>
    
    <div class="links-container">
        <a href="/sign-up">회원가입</a>
        <div>
            <a href="/find-id" class="normal">아이디 찾기</a>
            <span>|</span>
            <a href="/find-password" class="normal">비밀번호 찾기</a>
        </div>
    </div>
</div>
<script>
	// 페이지 로드 시 실행
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
		
		// 저장된 아이디 가져오기
		var savedUsername = getCookie("savedUsername");
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
			alert("아이디 또는 비밀번호를 입력해주세요.");
			return false;
		}
	
		saveUsername(); // 아이디 저장
		form.requestSubmit(); // 폼 제출 실행
	}

	// 아이디 저장
	function saveUsername() {
		const form = document.getElementById("login-form");
		var username = document.querySelector("input[name='username']").value;
	    var rememberMe = document.getElementById("remember").checked;
	
	    if (rememberMe) {
	        setCookie("savedUsername", username, 7); // 7일 동안 저장
	    } else {
	        setCookie("savedUsername", "", -1); // 쿠키 삭제
	    }
	    
	    form.requestSubmit(); // 폼 제출 실행
	}
</script>
</body>
</html>
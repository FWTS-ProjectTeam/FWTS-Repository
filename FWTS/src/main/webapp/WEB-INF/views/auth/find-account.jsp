<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>생화24 - 계정 찾기</title>
<link rel="stylesheet" href="/resources/css/auth.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<style>
	.tabs {
	    display: flex;
	    justify-content: space-around;
	    margin-bottom: 20px;
	    border-bottom: 2px solid var(--gray6);
	}
	.tab {
	    flex: 1;
	    padding: 10px 0;
	    cursor: pointer;
	    font-weight: 600;
	    color: var(--gray5);
	}
	.tab.active {
	    color: var(--pink2);
	    border-bottom: 2px solid var(--pink2);
	}
	
	.form-content {
	    display: none;
	}
	.form-content.active {
	    display: block;
	}
	
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
	
	.button-container {
	    display: flex;
	    flex-direction: column;
	    gap: 10px;
	}
</style>
</head>
<body>
<div class="container">
	<h1><a href="/">생화24</a></h1>
	<div class="tabs">
		<div class="tab" id="username" onclick="switchTab('username')">아이디 찾기</div>
		<div class="tab" id="password" onclick="switchTab('password')">비밀번호 찾기</div>
	</div>

	<!-- 아이디 찾기 -->
	<form id="username-form" class="form-content" action="/find-id" method="post" onsubmit="return validateBeforeFindId()">
		<div class="input-group">
			<label for="email">이메일</label>
			<input type="email" id="email-id" name="email" placeholder="가입 시 등록한 이메일을 입력해주세요">
		</div>
		<div class="button-container">
			<button type="submit">확인</button>
		</div>
	</form>

	<!-- 비밀번호 찾기 -->
	<form id="password-form" class="form-content">
		<div class="input-group">
			<label for="email">이메일</label>
			<input type="email" id="email-pw" name="email" placeholder="가입 시 등록한 이메일을 입력해주세요" onkeydown="handleEnter(event)">
		</div>
		<div class="button-container">
			<button type="button" onclick="sendVerificationCode()">확인</button>
		</div>
	</form>

	<div class="links-container">
		<a href="/login">로그인으로 돌아가기</a>
	</div>
</div>
<script>
	// 페이지 로드 시 현재 URL에 따라 탭 자동 선택
	window.onload = function() {
		const path = window.location.pathname; 
		if (path.includes("/find-password")) { 
			switchTab("password"); 
      	} else { 
        	switchTab("username"); 
      	} 
	};

	// 뒤로가기/앞으로가기 이벤트 처리
	window.onpopstate = function() { 
		const path = window.location.pathname; 
		if (path.includes("/find-password")) { 
			switchTab("password"); 
		} else { 
			switchTab("username"); 
		} 
	};
 
	// 현재 탭에 따라 URL 및 제목 변경
	function switchTab(tab) { 
		document.querySelectorAll(".tab").forEach(el => el.classList.remove("active")); 
		document.querySelectorAll(".form-content").forEach(el => el.classList.remove("active")); 
		document.getElementById(tab).classList.add("active"); 
		document.getElementById(tab + "-form").classList.add("active"); 

		// URL 변경 
		const newUrl = tab === "password" ? "/find-password" : "/find-id"; 
		history.pushState(null, "", newUrl); 
	}
  
	// 아이디 찾기 요청
	function validateBeforeFindId() {
		const form = document.getElementById("username-form");
		const email = document.getElementById("email-id").value;
      
		if (!email) {
			alert("이메일을 입력해주세요.");
			return false;
		}
		
		// 기본 유효성 검사
		if (form.checkValidity()) {
	        form.requestSubmit(); // 폼 제출 실행
	    } else {
	        form.reportValidity();
	    }
	}
	
	// 엔터키를 누르면 sendVerificationCode() 호출
	function handleEnter(event) {
	    if (event.key === 'Enter') {
	        event.preventDefault(); // 기본 폼 제출 방지
	        sendVerificationCode();
	    }
	}
  
	// 비밀번호 찾기 요청
	function sendVerificationCode() {
		const form = document.getElementById("password-form");
    	const email = document.getElementById("email-pw").value;

    	if (!email) {
        	alert("이메일을 입력해주세요.");
        	return false;
      	}
    	
    	// 기본 유효성 검사
    	if (!form.checkValidity()) {
	        form.reportValidity();
	        return false;
	    }
    	
     	// 로딩 메시지 표시
      	Swal.fire({ title: "코드 전송 중...", didOpen: () => Swal.showLoading() });

		// API 요청
      	fetch("/find-password/send-code", {
      	    method: 'POST',
      	    headers: {
      	        'Content-Type': 'application/json'
      	    },
      	    body: JSON.stringify({ email }) // JSON 형식으로 변환
      	})
      	.then(response => {
      		Swal.close();
      		
      	    if (response.ok) {
      	        window.location.href = "/find-password/verify-code"; // 인증 코드 입력 페이지
      	    } else if (response.status === 400) {
      	        return response.json().catch(() => null).then(data => {
      	            if (data && data.errorMessage) {
      	                Swal.fire({
      	                    icon: 'error',
      	                    title: '전송 실패',
      	                    text: data.errorMessage,
      	                    confirmButtonColor: '#d33',
      	                    confirmButtonText: '확인'
      	                });
      	            } else {
      	                location.reload();
      	            }
      	        });
      	    } else {
      	    	throw new Error('서버 오류');
      	    }
      	})
      	.catch(() => {
      		Swal.close();
      	    Swal.fire({
      	        icon: 'error',
      	        title: '전송 실패',
      	        text: '처리 중 오류가 발생했습니다. 다시 시도해 주세요.',
      	        confirmButtonColor: '#d33',
      	        confirmButtonText: '확인'
      	    });
      	});
	}
</script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>생화24 - 계정 찾기</title>
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
        .find-container {
            text-align: center;
            max-width: 400px;
            width: 100%;
            background-color: #fefefe;
            border: 1px solid #ddd;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        .find-container h1 {
            color: #ff6699;
            font-weight: 600;
            margin-bottom: 15px;
        }
        .tabs {
            display: flex;
            justify-content: space-around;
            margin-bottom: 20px;
            border-bottom: 2px solid #ddd;
        }
        .tab {
            flex: 1;
            padding: 10px 0;
            cursor: pointer;
            font-weight: 600;
            color: #999;
            transition: color 0.3s;
        }
        .tab.active {
            color: #ff6699;
            border-bottom: 2px solid #ff6699;
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
            font-weight: 600;
            display: block;
            margin-bottom: 5px;
        }
        .input-group input {
		    width: 100%;
		    max-width: 100%; /* 부모 크기를 넘지 않도록 설정 */
		    padding: 12px;
		    border: 1px solid #ddd;
		    border-radius: 6px;
		    font-size: 14px;
		    outline: none;
		    transition: border-color 0.3s;
		    box-sizing: border-box; /* 패딩과 보더 포함하여 크기 설정 */
		}
        .input-group input:focus {
            border-color: #ff6699;
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
            transition: background-color 0.3s;
        }
        .btn-primary {
            background-color: #ff6699;
            color: #fff;
        }
        .btn-primary:hover {
            background-color: #ff5577;
        }
        .links-container {
            margin-top: 20px;
            font-size: 14px;
        }
        .links-container a {
            text-decoration: none;
            color: #555;
            font-weight: 600;
        }
    </style>
    <script>
	    function switchTab(tab) {
	        document.querySelectorAll('.tab').forEach(el => el.classList.remove('active'));
	        document.querySelectorAll('.form-content').forEach(el => el.classList.remove('active'));
	        document.getElementById(tab).classList.add('active');
	        document.getElementById(tab + '-content').classList.add('active');
	
	        // URL 변경 (새로고침 없이)
	        const newUrl = tab === "password" ? "/find-account/password" : "/find-account/id";
	        history.pushState(null, "", newUrl);
	    }
	
	    // 페이지 로드 시 현재 URL에 따라 탭 자동 선택
	    window.onload = function() {
	        const path = window.location.pathname;
	        if (path.includes("/find-account/password")) {
	            switchTab("password");
	        } else {
	            switchTab("username");
	        }
	    };
	
	    // 뒤로가기/앞으로가기 이벤트 처리
	    window.onpopstate = function() {
	        const path = window.location.pathname;
	        if (path.includes("/find-account/password")) {
	            switchTab("password");
	        } else {
	            switchTab("username");
	        }
	    };
    </script>
</head>
<body>
    <div class="find-container">
        <h1>생화24</h1>
        <div class="tabs">
            <div class="tab" id="username" onclick="switchTab('username')">아이디 찾기</div>
            <div class="tab" id="password" onclick="switchTab('password')">비밀번호 찾기</div>
        </div>

        <!-- 아이디 찾기 폼 -->
        <form id="username-content" class="form-content" action="/find-account/id" method="post">
            <div class="input-group">
                <label for="email">이메일</label>
                <input type="email" id="email" name="email" placeholder="가입 시 등록한 이메일을 입력하세요" required>
            </div>
            <div class="button-container">
                <button type="submit" class="btn-primary">확인</button>
            </div>
        </form>
        
        <!-- 비밀번호 찾기 폼 -->
        <form id="password-content" class="form-content" action="/find-account/password" method="post">
            <div class="input-group">
                <label for="email">이메일</label>
                <input type="email" id="email" name="email" placeholder="가입 시 등록한 이메일을 입력하세요" required>
            </div>
            <div class="button-container">
                <button type="submit" class="btn-primary">확인</button>
            </div>
        </form>

        <div class="links-container">
            <a href="/login">로그인으로 돌아가기</a>
        </div>
    </div>
</body>
</html>
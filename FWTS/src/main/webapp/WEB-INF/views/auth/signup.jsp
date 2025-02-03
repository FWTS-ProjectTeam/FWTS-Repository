<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>생화24 - 회원가입</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #fff;
            color: #333;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            padding: 30px;
        }
        .container {
            max-width: 650px;
            width: 100%;
            background-color: #fefefe;
            border: 1px solid #ddd;
            padding: 20px 40px 20px 40px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        h1 {
            color: #ff6699;
            font-weight: bold;
            text-align: center;
        }
        p { text-align: center; }
        label {
            font-weight: bold;
            display: block;
            margin-top: 15px;
        }
        .required { color: red; }
        .input-group {
            display: flex;
            align-items: center;
            justify-content: flex-start;
            margin-bottom: 15px;
            gap: 10px;
        }
        .input-group label {
            width: 200px;
            text-align: left;
        }
        .input-group input {
            flex: 1;
            max-width: 400px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
        }
        .input-group button {
            padding: 10px 15px;
            background-color: #ff6699;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            white-space: nowrap;
        }
        .input-group button:hover { background-color: #ff5577; }
        .full-width {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
            margin-top: 5px;
        }
        .radio-group {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
            gap: 10px;
        }
        .radio-group label { width: 200px; }
        .radio-options {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .radio-options input[type="radio"] {
            width: 16px;
            height: 16px;
            margin: 0;
            vertical-align: middle;
        }
        .radio-options label {
            font-weight: normal;
            line-height: 1;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .button-container {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }
        .button-container button {
            padding: 10px 15px;
            background-color: #ff6699;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
        }
        .button-container button:hover {
            background-color: #ff5577;
        }
    </style>
    <script>
	 	// 이메일 또는 아이디 중복 확인 함수
	    function checkDuplicate(type) {
	        const value = document.getElementById(type).value;
	
	        if (type == 'email')
	            type = '이메일';
	        else
	            type = '아이디';
	
	        // 입력값이 없으면 경고 메시지 출력 후 종료
	        if (!value) {
	            alert(type + "을(를) 입력하세요.");
	            return;
	        }
	
	        alert(type + " 중복 확인 중...");
	    }
	
	    // 사업자등록번호 확인 함수
	    function verifyBusinessNumber() {
	        const bizNumber = document.getElementById("business-number").value;
	
	        // 입력값이 없으면 경고 메시지 출력 후 종료
	        if (!bizNumber) {
	            alert("사업자등록번호을(를) 입력하세요.");
	            return;
	        }
	
	        alert("사업자등록번호 확인 중...");
	    }
	
	    // 카카오 우편번호 검색 API를 이용한 주소 검색 함수
	    function searchAddress() {
	        new daum.Postcode({
	            oncomplete: function(data) {
	                document.getElementById("postal-code").value = data.zonecode; // 우편번호 입력
	                document.getElementById("address").value = data.roadAddress; // 도로명 주소 입력
	            }
	        }).open();
	    }
	
	    // 비밀번호 확인 함수
	    function validatePassword() {
	        const password = document.getElementById("password").value;
	        const confirmPassword = document.getElementById("confirm-password").value;
	
	        // 비밀번호가 일치하지 않으면 경고 메시지 출력
	        if (password !== confirmPassword) {
	            alert("비밀번호가 일치하지 않습니다.");
	            return false;
	        }
	
	        return true;
	    }
    </script>
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>
<body>
    <div class="container">
        <h1>생화24</h1>
        <p>가입을 환영합니다!</p>
        
        <form onsubmit="return validatePassword()">
        	<div class="radio-group">
                <label>사업자 유형 <span class="required">*</span></label>
                <div class="radio-options">
                	<label><input type="radio" id="retail" name="business-type" checked> 소매업자</label>
                    <label><input type="radio" id="wholesale" name="business-type"> 도매업자</label>
                </div>
            </div>
            
            <div class="input-group">
                <label for="email">이메일 <span class="required">*</span></label>
                <input type="email" id="email" required>
                <button type="button" onclick="checkDuplicate('email')">중복 확인</button>
            </div>

            <div class="input-group">
                <label for="username">아이디 <span class="required">*</span></label>
                <input type="text" id="username" required>
                <button type="button" onclick="checkDuplicate('username')">중복 확인</button>
            </div>
            
            <div class="input-group">
                <label for="password">비밀번호 <span class="required">*</span></label>
                <input type="password" id="password" required>
            </div>
            
            <div class="input-group">
                <label for="confirm-password">비밀번호 확인 <span class="required">*</span></label>
                <input type="password" id="confirm-password" required>
            </div>

            <div class="input-group">
                <label for="business-number">사업자등록번호 <span class="required">*</span></label>
                <input type="text" id="business-number" required>
                <button type="button" onclick="verifyBusinessNumber()">확인</button>
            </div>

			<div class="input-group">
	            <label for="phone">휴대폰 번호 <span class="required">*</span></label>
	            <input type="text" id="phone" required class="full-width">
	        </div>
            
            <div class="input-group">
	            <label for="company-phone">업체 전화번호 <span class="required">*</span></label>
	            <input type="text" id="company-phone" required class="full-width">
	        </div>
	            
	        <div class="input-group">
	            <label for="company">업체명 <span class="required">*</span></label>
	            <input type="text" id="company" required class="full-width">
	        </div>
	            
	        <div class="input-group">    
	            <label for="representative">대표자명 <span class="required">*</span></label>
	            <input type="text" id="representative" required class="full-width">
            </div>
            
            <div class="input-group">
                <label for="postal-code">우편번호 <span class="required">*</span></label>
                <input type="text" id="postal-code" readonly required class="full-width">
                <button type="button" onclick="searchAddress()">주소 찾기</button>
            </div>
            
            <div class="input-group"> 
	            <label for="address">주소 <span class="required">*</span></label>
	            <input type="text" id="address" readonly required class="full-width">
            </div>
            
            <div class="input-group"> 
	            <label for="detail-address">상세 주소</label>
	            <input type="text" id="detail-address" class="full-width">
	        </div>       
            
            <div class="button-container">
                <button type="submit">가입하기</button>
            </div>
        </form>
    </div>
</body>
</html>
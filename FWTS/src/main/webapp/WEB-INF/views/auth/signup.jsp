<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>생화24 - 회원가입</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
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
        font-weight: 600;
        text-align: center;
    }
    p { text-align: center; }
    label {
        font-weight: 600;
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
    .password-container {
		position: relative;
	    display: flex;
	    align-items: center;
	}
	.password-container input {
	    width: 100%;
	    padding-right: 35px; /* 아이콘 공간 확보 */
	}
	.password-container i {
	    position: absolute;
	    right: 10px;
	    cursor: pointer;
	    font-size: 18px;
	    color: #888;
	}
	.password-container i:hover { color: #ff6699; }
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
  </style>
    <script>
		// 회원가입 실패 알림창
	    window.onload = function() {
	        <c:if test="${not empty errorMessage}">
	            Swal.fire({
	                icon: 'error',
	                title: '회원가입 실패',
	                text: "${errorMessage}", 
	                confirmButtonColor: '#d33',
	                confirmButtonText: '확인'
	            });
	        </c:if>
	    };
    
	 	// 이메일 또는 아이디 중복 확인
		function checkDuplicate(type) {
		    const value = document.getElementById(type).value;
		    let typeText = (type === 'email') ? '이메일' : '아이디';
		
		    console.log(type);
		    console.log(value);
		    
		    // 입력값이 없으면 경고 메시지 표시 후 종료
		    if (!value) {
		    	alert(typeText + "을(를) 입력하세요.");
		    	return;
		    }
		
		    // 중복 확인 로딩 메시지
		    Swal.fire({
		        title: typeText + " 중복 확인 중...",
		        text: "잠시만 기다려 주세요!",
		        allowOutsideClick: false,
		        allowEscapeKey: false,
		        showConfirmButton: false,
		        didOpen: () => {
		            Swal.showLoading(); // 로딩 애니메이션 추가
		        }
		    });

		 	// AJAX 요청
			fetch("/check-duplicate", {
				method: 'POST',
				headers: {
					'Content-Type': 'application/json'
				},
				body: JSON.stringify({ type: type, value: value }) // JSON 형식으로 변환
			})
	        .then(response => response.json()) // 서버 응답을 파싱
	        .then(isDuplicate => {
	            if (isDuplicate) {
	                // 중복된 경우
	                Swal.fire({
	                    icon: 'error',
	                    title: '중복',
	                    text: typeText + "이(가) 이미 사용 중입니다.",
	                    confirmButtonColor: '#d33',
	                    confirmButtonText: '확인'
	                });
	            } else {
	                // 사용 가능한 경우
	                Swal.fire({
	                    icon: 'success',
	                    title: '사용 가능',
	                    text: typeText + "을(를) 사용할 수 있습니다.",
	                    confirmButtonColor: '#3085d6',
	                    confirmButtonText: '확인'
	                });
	            }
	        })
	        .catch(error => {
	            // 오류 발생 시
	            console.error("Error:", error);
	            Swal.fire({
	                icon: 'error',
	                title: '오류 발생',
	                text: "서버와 연결할 수 없습니다.",
	                confirmButtonColor: '#d33',
	                confirmButtonText: '확인'
	            });
	        });
		}
	
	    // 사업자등록번호 확인
	    function verifyBusinessNumber() {
	        const businessNo = document.getElementById("business-number").value;
	
	        // 입력값이 없으면 경고 메시지 출력 후 종료
	        if (!businessNo) {
	            alert("사업자등록번호을(를) 입력하세요.");
	            return;
	        }
	
	     	// 확인 로딩 메시지
		    Swal.fire({
		        title: "사업자 등록번호 확인 중...",
		        text: "잠시만 기다려 주세요!",
		        allowOutsideClick: false,
		        allowEscapeKey: false,
		        showConfirmButton: false,
		        didOpen: () => {
		            Swal.showLoading();
		        }
		    });

		    const requestUrl = "/check-business-no?businessNo=" + encodeURIComponent(businessNo);
		    
		 	// AJAX 요청
			fetch("/check-business-no", {
				method: 'POST',
				headers: {
					'Content-Type': 'application/json'
				},
				body: JSON.stringify({ type: "businessNo", value: businessNo }) // JSON 형식으로 변환
			})
	        .then(response => response.json()) // 서버 응답(JSON)을 파싱
	        .then(isDuplicate => {
	            if (isDuplicate) {
	                // 중복된 경우
	                Swal.fire({
	                    icon: 'error',
	                    title: '중복',
	                    text: "사업자 등록번호이(가) 이미 사용 중입니다.",
	                    confirmButtonColor: '#d33',
	                    confirmButtonText: '확인'
	                });
	            } else {
	                // 사용 가능한 경우
	                Swal.fire({
	                    icon: 'success',
	                    title: '사용 가능',
	                    text: "사업자 등록번호을(를) 사용할 수 있습니다.",
	                    confirmButtonColor: '#3085d6',
	                    confirmButtonText: '확인'
	                });
	            }
	        })
	        .catch(error => {
	            // 오류 발생 시
	            console.error("Error:", error);
	            Swal.fire({
	                icon: 'error',
	                title: '오류 발생',
	                text: "서버와 연결할 수 없습니다.",
	                confirmButtonColor: '#d33',
	                confirmButtonText: '확인'
	            });
	        });
	    }
	
	    // 카카오 우편번호 검색 API를 이용한 주소 검색
	    function searchAddress() {
	        new daum.Postcode({
	            oncomplete: function(data) {
	                document.getElementById("postal-code").value = data.zonecode; // 우편번호 입력
	                document.getElementById("address").value = data.roadAddress; // 도로명 주소 입력
	            }
	        }).open();
	    }
	
	    // 비밀번호 확인
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
	    
	    // 하이븐 제거
	    function removeHyphen(target) {
	        target.value = target.value.replace(/-/g, ""); // 모든 '-' 제거
	    }

	    // 전화번호 하이븐 추가
	    function formatPhoneNumber(target) {
	        let value = target.value.replace(/[^0-9]/g, ""); // 숫자만 입력받기
	        let pass = true;

	        if (value.startsWith("010")) { // 휴대폰 번호 (11자리)
	            if (value.length === 11) {
	                value = value.replace(/^(\d{3})(\d{4})(\d{4})$/, "$1-$2-$3");
	            } else {
	            	pass = false;
	            }
	        } else if (value.startsWith("02")) { // 서울 지역번호 (9~10자리)
	            if (value.length === 9) { // 02-XXX-XXXX (9자리)
	                value = value.replace(/^(\d{2})(\d{3})(\d{4})$/, "$1-$2-$3");
	            } else if (value.length === 10) { // 02-XXXX-XXXX (10자리)
	                value = value.replace(/^(\d{2})(\d{4})(\d{4})$/, "$1-$2-$3");
	            } else {
	            	pass = false;
	            }
	        } else if (/^(0[3-9]{1}[0-9])/.test(value)) { // 일반 지역번호 (10자리 등)
	            if (value.length === 10) {
	                value = value.replace(/^(\d{3})(\d{3})(\d{4})$/, "$1-$2-$3");
	            } else {
	            	pass = false;
	            }
	        } else { // 대표번호 (8자리 등)
	            if (value.length === 8) {
	                value = value.replace(/^(\d{4})(\d{4})$/, "$1-$2");
	            } else {
	            	pass = false;
	            }
	        }
	        
	        if (!pass) {
	        	alert("잘못된 전화번호입니다.");
	        	target.value = "";
	        } else {
	        	target.value = value;
	        }
	    }
	    
	 	// 사업자등록번호 하이픈 추가
	    function formatBusinessNumber(target) {
	        let value = target.value.replace(/[^0-9]/g, ""); // 숫자만 입력받기
	        
	        if (value.length === 10) {
	            value = value.replace(/^(\d{3})(\d{2})(\d{5})$/, "$1-$2-$3");
	            target.value = value;
	        } else {
	            alert("잘못된 사업자등록번호입니다.");
	            target.value = "";
	        }
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
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>
<body>
    <div class="container">
        <h1>생화24</h1>
        <p>가입을 환영합니다!</p>
        
        <form action="/sign-up" method="post" onsubmit="return validatePassword()">
        	<div class="radio-group">
                <label>사업자 유형 <span class="required">*</span></label>
                <div class="radio-options">
                    <label><input type="radio" name="role" value="1" checked> 도매업자</label>
                    <label><input type="radio" name="role" value="2"> 소매업자</label>
                </div>
            </div>
            
            <div class="input-group">
                <label for="email">이메일 <span class="required">*</span></label>
                <input type="email" id="email" name="email" value="${inputData.email}" required maxlength="320">
                <button type="button" onclick="checkDuplicate('email')">중복 확인</button>
            </div>

            <div class="input-group">
                <label for="username">아이디 <span class="required">*</span></label>
                <input type="text" id="username" name="username" value="${inputData.username}" maxlength="20">
                <button type="button" onclick="checkDuplicate('username')">중복 확인</button>
            </div>
            
			<div class="input-group">
			    <label for="password">비밀번호 <span class="required">*</span></label>
			    <div class="password-container">
			        <input type="password" id="password" name="password" value="${inputData.password}" maxlength="20">
			        <i class="fa-solid fa-eye" id="toggle-password" onclick="togglePassword('password', this)"></i>
			    </div>
			</div>
			
			<div class="input-group">
			    <label for="confirm-password">비밀번호 확인 <span class="required">*</span></label>
			    <div class="password-container">
			        <input type="password" id="confirm-password">
			        <i class="fa-solid fa-eye" id="toggle-confirm-password" onclick="togglePassword('confirm-password', this)"></i>
			    </div>
			</div>

			<div class="input-group">
			    <label for="business-number">사업자등록번호 <span class="required">*</span></label>
			    <input type="text" id="business-number" name="businessNo" value="${inputData.businessNo}" placeholder="- 포함" maxlength="10"
			    	   onfocus="removeHyphen(this)" onblur="formatBusinessNumber(this)">
			    <button type="button" onclick="verifyBusinessNumber()">확인</button>
			</div>
			
			<div class="input-group">
			    <label for="phone">휴대폰번호 <span class="required">*</span></label>
			    <input type="text" id="phone" name="phoneNum" value="${inputData.phoneNum}" placeholder="- 포함" maxlength="13"
			           onfocus="removeHyphen(this)" onblur="formatPhoneNumber(this)">
			</div>
			
			<div class="input-group">
			    <label for="company-phone">업체전화번호</label>
			    <input type="text" id="company-phone" name="companyNum" value="${inputData.companyNum}" placeholder="- 포함" maxlength="13"
			           onfocus="removeHyphen(this)" onblur="formatPhoneNumber(this)">
			</div>
	            
	        <div class="input-group">
	            <label for="company">업체 <span class="required">*</span></label>
	            <input type="text" id="company" name="companyName" value="${inputData.companyName}" class="full-width" required>
	        </div>
	            
	        <div class="input-group">    
	            <label for="ceo">대표자 <span class="required">*</span></label>
	            <input type="text" id="ceo" name="ceoName" value="${inputData.ceoName}" class="full-width" required>
            </div>
            
            <div class="input-group">
                <label for="postal-code">우편번호 <span class="required">*</span></label>
                <input type="text" id="postal-code" name="postalCode" class="full-width" readonly required>
                <button type="button" onclick="searchAddress()">주소 찾기</button>
            </div>
            
            <div class="input-group"> 
	            <label for="address">주소 <span class="required">*</span></label>
	            <input type="text" id="address" name="address" class="full-width" readonly required>
            </div>
            
            <div class="input-group"> 
	            <label for="detail-address">상세주소</label>
	            <input type="text" id="detail-address" name="detailAddress" class="full-width" maxlength="30">
	        </div>       
            
            <div class="button-container">
                <button type="submit">가입하기</button>
            </div>
        </form>
    </div>
</body>
</html>
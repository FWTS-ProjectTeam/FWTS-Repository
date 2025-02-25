<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>생화24 - 회원가입</title>
<link rel="stylesheet" href="/resources/css/auth.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<style>
    .container {
        max-width: 720px;
        padding: 20px 40px;
        text-align: left;
        margin: 50px 0;
    }
    
    h1, p {
        text-align: center;
    }

    .required {
    	color: red;
    }

    .radio-options {
        display: flex;
        align-items: center;
        margin: 10px;
        gap: 30px;
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
        margin-top: 20px;
    }
    
    .input-group button {
    	font-size: 14px;
    	width: 96px;
    }
    
    .password-container {
        position: relative;
        display: flex;
        align-items: center;
        width: 300px;
    }
    .password-container input {
        padding-right: 40px; /* 아이콘 공간 확보 */
    }
    .password-container i {
        position: absolute;
        right: 10px;
        cursor: pointer;
        font-size: 18px;
        color: var(--gray4);
    }
    .password-container i:hover {
        color: var(--pink2);
    }
</style>
</head>
<body>
<div class="container">
    <h1><a href="/">생화24</a></h1>
    <p>가입을 환영합니다!</p>
    
    <form id="signup-form" action="/sign-up" method="post">
    	<div class="input-group">
            <label>사업자 유형 <span class="required">*</span></label>
            <div class="radio-options">
                <label for="wholesaler">
                	<input type="radio" id="wholesaler" name="role" value="1" ${inputData.role == '1' ? 'checked' : (inputData.role == null ? 'checked' : '')}> 도매업자
                </label>
                <label for="retailer">
                	<input type="radio" id="retailer" name="role" value="2" ${inputData.role == '2' ? 'checked' : ''}> 소매업자
                </label>
            </div>
        </div>
        
        <div class="input-group">
            <label for="email">이메일 <span class="required">*</span></label>
            <div class="input-field">
            	<input type="hidden" id="email-check" value="false"/>
             	<input id="email" name="email" value="${inputData.email}" maxlength="320"
					oninput="this.value = this.value.replace(/[^A-Za-z0-9._%+-@]/g, '');">
             	<button type="button" onclick="checkDuplicate('email')">중복 확인</button>
             	<p class="error-message" id="email-error"></p>
            </div>
            
            <label for="username">아이디 <span class="required">*</span></label>
            <div class="input-field">
            	<input type="hidden" id="username-check" value="false"/>
            	<input id="username" name="username" value="${inputData.username}" maxlength="15"
					 oninput="this.value = this.value.replace(/[^A-Za-z0-9]/g, '');">
            	<button type="button" onclick="checkDuplicate('username')">중복 확인</button>
            	<p class="error-message" id="username-error"></p>
            </div>
            
            <label for="password">비밀번호 <span class="required">*</span></label>
            <div class="input-field">
            	<div class="password-container">
			        <input type="password" id="password" name="password" value="${inputData.password}" maxlength="20">
			        <i class="fa-solid fa-eye" id="toggle-password" onclick="togglePassword('password', this)"></i>
			    </div>
			    <p class="error-message" id="password-error"></p>
		    </div>
   
		   	<label for="confirm-password">비밀번호 확인 <span class="required">*</span></label>
		   	<div class="input-field">
		    	<div class="password-container">
			        <input type="password" id="confirm-password" name="confirmPassword" value="${inputData.confirmPassword}">
			        <i class="fa-solid fa-eye" id="toggle-confirm-password" onclick="togglePassword('confirm-password', this)"></i>
			    </div>
			</div>
			
			<label for="company">상호명 <span class="required">*</span></label>
	   		<div class="input-field">
	   			<input id="company" name="companyName" value="${inputData.companyName}">
	   		</div>
         
         	<label for="ceo">대표자명 <span class="required">*</span></label>
         	<div class="input-field">
         		<input id="ceo" name="ceoName" value="${inputData.ceoName}">
         	</div>
   
   			<label for="opening-date">개업일자 <span class="required">*</span></label>
         	<div class="input-field">
         		<input id="opening-date" name="openingDate" value="${inputData.openingDate}" maxlength="8"
					placeholder="YYYYMMDD" oninput="this.value = this.value.replace(/[^0-9]/g, '');">
         	</div>
   
		   	<label for="business-no">사업자등록번호 <span class="required">*</span></label>
		   	<div class="input-field">
		   		<input type="hidden" id="business-no-check" value="false"/>
		   		<input id="business-no" name="businessNo" value="${inputData.businessNo}" maxlength="12"
		   	   		placeholder="- 포함" oninput="this.value = this.value.replace(/[^0-9-]/g, '');">
		   		<button type="button" onclick="verifyBusinessNo()">확인</button>
		   		<p class="error-message" id="business-no-error"></p>
		   	</div>
   
		   	<label for="phone">휴대폰번호 <span class="required">*</span></label>
		   	<div class="input-field">
	          	<input id="phone" name="phoneNum" value="${inputData.phoneNum}" maxlength="13"
		      		placeholder="- 포함" oninput="this.value = this.value.replace(/[^0-9-]/g, '');">
		       	<p class="error-message" id="phone-error"></p>
		   	</div>
          
        	<label for="company-phone">사업장 전화번호</label>
        	<div class="input-field">
        		<input id="company-phone" name="companyNum" value="${inputData.companyNum}" maxlength="13"
			    	placeholder="- 포함" oninput="this.value = this.value.replace(/[^0-9-]/g, '');">
       			<p class="error" id="company-phone-error"></p>
			</div>
         
         	<label for="postal-code">우편번호 <span class="required">*</span></label>
         	<div class="input-field">
	             <input id="postal-code" name="postalCode" value="${inputData.postalCode}" readonly>
	             <button type="button" onclick="searchAddress()">주소 찾기</button>
            </div>
            
            <label for="address">주소 <span class="required">*</span></label>
           	<div class="input-field">
          		<input id="address" name="address" value="${inputData.address}" readonly>
          		<input id="detail-address" name="detailAddress" value="${inputData.detailAddress}" maxlength="30">
       		</div>
        </div>
        
        <div class="button-container">
            <button type="button" onclick="validateBeforeSignup()">가입하기</button>
        </div>
    </form>
</div>
</body>
<script>
	// 회원가입 실패 알림창
   	window.onload = function() {
    	<c:if test="${not empty errorMessage}">
        	Swal.fire({
            	icon: 'error',
               	title: '가입 실패',
               	text: "${errorMessage}", 
               	confirmButtonColor: '#d33',
               	confirmButtonText: '확인'
           	});
       	</c:if>
   	};
   	
 	// 카카오 우편번호 검색 API를 이용한 주소 검색
    function searchAddress() {
        new daum.Postcode({
            oncomplete: function(data) {
                document.getElementById("postal-code").value = data.zonecode; // 우편번호 입력
                document.getElementById("address").value = data.roadAddress; // 도로명 주소 입력
            }
        }).open();
    }
  
 	// 회원가입 요청
    function validateBeforeSignup() {
    	const form = document.getElementById("signup-form");

 		// 유효성 검사: 1. 중복 확인
        if (document.getElementById("email-check").value !== "true") {
		    alert("이메일 중복 확인을 완료해주세요.");
		    return;
		} else if (document.getElementById("username-check").value !== "true") {
		    alert("아이디 중복 확인을 완료해주세요.");
		    return;
		} else if (document.getElementById("business-no-check").value !== "true") {
		    alert("사업자등록번호 확인을 완료해주세요.");
		    return;
		}
 		
     	// 유효성 검사: 2. 입력 여부
     	var password = document.getElementById("password").value;
       	var confirmPassword = document.getElementById("confirm-password").value;
       	var phoneNum = document.getElementById("phone").value;
	    var companyNum = document.getElementById("company-phone").value;
	    var postalCode = document.getElementById("postal-code").value;
     	
        if (!password || !confirmPassword) {
	  		alert("비밀번호를 입력해주세요.")
	  		return false;
	  	} else if (!phoneNum) {
	  		alert("휴대폰번호를 입력해주세요.")
	  		return false;
	  	} else if (!postalCode) {
	    	alert("주소를 입력해주세요.");
	    	return false;
	    }
 		
     	// 유효성 검사: 2. 입력 형식
		const phoneCheck = validatePhone(phoneNum, companyNum);
    	const passwordCheck = validatePassword(password, confirmPassword);
    	
    	if (phoneCheck && passwordCheck) {
    	    Swal.fire({ title: "회원가입 진행 중...", didOpen: () => Swal.showLoading() });
    		
    		form.requestSubmit(); // 폼 제출 실행
    	}
    }
   	
	// 이메일 또는 아이디 중복 확인
	function checkDuplicate(type) {
    	const value = document.getElementById(type).value;
    	var typeText = (type === 'email') ? '이메일' : '아이디';
    	
    	// 유효성 검사: 1. 입력 여부
	    if (!value) {
	    	if (type === 'email') {
	    		alert(typeText + "을 입력해주세요.");
	    	} else {
	    		alert(typeText + "를 입력해주세요.");
	    	}
	    	return;
	    }
    	
	 	// 유효성 검사: 2. 입력 형식
	 	var isValid = true;
	    
	 	// 오류 메시지 필드
    	const emailError = document.getElementById("email-error");
		const usernameError = document.getElementById("username-error");
	    
	 	// 오류 메시지 초기화
		emailError.textContent = "";
		usernameError.textContent = "";
	 	
	 	if (type === 'email') {
		  	const emailRegex = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
	 		if (!emailRegex.test(value)) {
	 			emailError.textContent = "올바른 이메일 형식이 아닙니다.";
    	  		isValid = false;
    	  	}
    	} else {
    		if (value.length < 4) {
    			usernameError.textContent = "아이디는 4~20자 이내여야 합니다.";
    	  		isValid = false;
    	  	}
    	}
	 	
	 	if (!isValid) {
	 		return false;
	 	}

	 	fetch("/check-duplicate", {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify({ type, value }) // JSON 형식으로 변환
		})
       .then(response => response.json()) // 서버 응답을 파싱
       .then(isDuplicate => {
           if (isDuplicate) {
               // 중복된 경우
               Swal.fire({
                   icon: 'error',
                   title: '중복',
                   text: '이미 사용 중입니다.',
                   confirmButtonColor: '#d33',
                   confirmButtonText: '확인'
               });
           } else {
               // 사용 가능한 경우
               Swal.fire({
                   icon: 'success',
                   title: '사용 가능',
                   text: '사용할 수 있습니다.',
                   confirmButtonColor: '#3085d6',
                   confirmButtonText: '확인'
               });
               
               document.getElementById(type + "-check").value = "true";
           }
       })
       .catch(error => {
           // 오류 발생 시
           console.error("Error:", error);
           Swal.fire({
               icon: 'error',
               title: '확인 실패',
               text: '처리 중 오류가 발생했습니다. 다시 시도해 주세요.',
               confirmButtonColor: '#d33',
               confirmButtonText: '확인'
           });
       });
	}

   	// 사업자등록번호 확인
   	function verifyBusinessNo() {
   		var companyName = document.getElementById("company").value.trim();
   		var ceoName = document.getElementById("ceo").value.trim();
   		var openingDate = document.getElementById("opening-date").value;
   		var businessNo = document.getElementById("business-no").value;
   		
     	// 유효성 검사: 1. 입력 여부
     	if (!companyName) {
	  		alert("상호명을 입력해주세요.")
	  		return false;
	  	} else if (!ceoName) {
	    	alert("대표자명을 입력해주세요.");
	    	return false;
	    } else if (!openingDate) {
	    	alert("개업일자를 입력해주세요.");
	    	return false;
	    } else if (!businessNo) {
           	alert("사업자등록번호를 입력해주세요.");
           	return false;
       	}
       	
     	// 유효성 검사: 2. 입력 형식
     	var isValid = true;
       	
     	// 오류 메시지 필드
    	const businessNoError = document.getElementById("business-no-error");
     	
    	// 오류 메시지 초기화
		businessNoError.textContent = "";
       	
     	const businessNoRegex = /^\d{3}-\d{2}-\d{5}$/;
 		if (!businessNoRegex.test(businessNo)) {
 			businessNoError.textContent = "올바른 사업자등록번호 형식이 아닙니다.";
   	  		return false;
   	  	}

     	// 확인 요청
	    Swal.fire({ title: "사업자 등록번호 확인 중...", didOpen: () => Swal.showLoading() });

	 	fetch("/check-business-no", {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify({ businessNo, ceoName, openingDate }) // JSON 형식으로 변환
		})
       	.then(response => response.json()) // 서버 응답을 파싱
       	.then(isDuplicate => {
           	if (isDuplicate) {
               	// 사용 불가능한 경우
               	Swal.fire({
                   	icon: 'error',
                   	title: '사용 불가능',
                   	text: '사용할 수 없습니다.',
                   	confirmButtonColor: '#d33',
                   	confirmButtonText: '확인'
               	});
           	} else {
               	// 사용 가능한 경우
               	Swal.fire({
                   	icon: 'success',
                   	title: '사용 가능',
                   	text: '사용할 수 있습니다.',
                   	confirmButtonColor: '#3085d6',
                   	confirmButtonText: '확인'
               	});
               
               	document.getElementById("business-no-check").value = "true";
               	
             	// 입력 필드 고정
               	document.getElementById("company").readonly = true;
               	document.getElementById("ceo").readonly = true;
               	document.getElementById("opening-date").readonly = true;
               	document.getElementById("business-no").readonly = true;
           	}
       	})
       	.catch(error => {
           	// 오류 발생 시
           	console.error("Error:", error);
           	Swal.fire({
               	icon: 'error',
               	title: '확인 실패',
               	text: '처리 중 오류가 발생했습니다. 다시 시도해 주세요.',
               	confirmButtonColor: '#d33',
               	confirmButtonText: '확인'
           	});
       	});
   	}
	
	// 중복 확인 결과 초기화
    document.getElementById("username").addEventListener("keyup", function() {
	    document.getElementById("username-check").value = "false";
	});
	
	document.getElementById("email").addEventListener("keyup", function() {
	    document.getElementById("email-check").value = "false";
	});
   	
	// 전화번호 확인
	function validatePhone(phoneNum, companyNum) {
		var isValid = true;
		
		const phoneError = document.getElementById("phone-error");
		const companyPhoneError = document.getElementById("company-phone-error");
		
		// 오류 메시지 초기화
	    phoneError.textContent = "";
	    companyPhoneError.textContent = "";
		
		// 전화번호 정규식
	  	const phoneRegex = /^(010)-\d{4}-\d{4}$/;
	  	const companyPhoneRegex = /^(\d{2,3}-\d{3,4}-\d{4}|\d{4}-\d{4})$/;
		
		if (!phoneRegex.test(phoneNum)) {
			phoneError.textContent = "올바른 핸드폰번호 형식이 아닙니다.";
	        isValid = false;
	    }

	    if (companyNum && !companyPhoneRegex.test(companyNum)) {
	    	companyPhoneError.textContent = "올바른 업체전화번호 형식이 아닙니다.";
	        isValid = false;
	    }
	    
	    return isValid;
	}
	
   	// 비밀번호 확인
   	function validatePassword(password, confirmPassword) {
       	const passwordError = document.getElementById("password-error");
       	
     	// 오류 메시지 초기화
	    passwordError.textContent = "";

    	// 비밀번호 정규식
	  	const passwordRegex = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()_+=-])[A-Za-z\d!@#$%^&*()_+=-]*$/;
	  	
	  	if (password.length < 8) {
	  		passwordError.textContent = "비밀번호는 8~20자 이내여야 합니다.";
	  		return false;
	  	}
	
	  	if (!passwordRegex.test(password)) {
	  		passwordError.textContent = "비밀번호는 영문, 숫자, 특수문자(!@#$%^&*()_+=-)를 포함해야 합니다.";
	  		return false;
	  	}
	
	  	if (password !== confirmPassword) {
	  		passwordError.textContent = "비밀번호가 일치하지 않습니다.";
	  		return false;
	  	}

	  	return true;
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
</html>
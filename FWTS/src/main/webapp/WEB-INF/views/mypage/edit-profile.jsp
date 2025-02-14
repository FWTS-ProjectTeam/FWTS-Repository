<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>생화 24 - 마이페이지</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #fff;
        color: #333;
    }
    .container {
        width: 80%;
        margin: 0 auto;
    }
    .header {
        display: flex;
        justify-content: space-between;
        align-items: flex-end;
        padding: 0px 10px;
        margin: 20px 10px 15px 10px;
        position: relative;
    }
    .header-left {
        display: flex;
        align-items: center;
    }
    .header-left h1 {
        font-size: 36px;
        color: #ff3366;
        margin: 0px;
    }
    .header-right {
        display: flex;
    }
    .header-right a {
        font-size: 13px;
        text-decoration: none;
        color: #333;
        margin-left: 10px;
    }
    .search-container {
        width: 240px;
        display: flex;
        align-items: center;
        border: 1px solid #ccc;
        border-radius: 5px;
        padding: 10px;
        margin-left: 110px;
        background-color: #fff;
    }
    .search-box {
        font-size: 14px;
        border: none;
        outline: none;
        flex-grow: 1;
    }
    .search-button {
        background: none;
        border: none;
        cursor: pointer;
        font-size: 16px;
        color: #ff3366;
        padding: 5px;
    }
    .nav-container {
        display: flex;
        justify-content: space-between;
        border: 1px solid #ccc; /* 상단 메뉴 구분선 */
        border-radius: 10px;
        padding: 20px;
        align-items: flex-end;
    }
    .nav a {
        font-size: 20px;
        font-weight: 600;
        text-decoration: none;
        color: #333;
        margin-right: 30px;
    }
    .nav-right a {
        text-decoration: none;
        color: #FF748B;
        font-size: 16px;
        font-weight: 600;
        margin-left: 10px;
    }
    .body-container {
        display: flex;
        margin: 20px;
    }
    .sidebar {
        width: 180px; /* 사이드 메뉴 너비 고정 */
        min-width: 180px;
        max-width: 180px;
        padding: 10px;
        border: 1px solid #ccc;
        background-color: #fff;
        border-radius: 10px;
        margin-right: 20px;
        align-self: flex-start; /* 내부 콘텐츠 크기만큼 높이 조정 */
    }
    .sidebar h2 {
        font-size: 18px;
        margin-bottom: 10px;
    }
    .sidebar a {
        display: block;
        padding: 10px;
        text-decoration: none;
        color: #333;
        cursor: pointer;
    }
    .sidebar .active {
        font-weight: 600;
        background-color: #ff7f9d;
        color: #fff;
        border-radius: 5px;
    }
    .profile-container {
        width: 100%;
        margin: 0px 10px;
    }
    .profile-content, .password-content {
        padding: 5px 20px;
    }
    .input-group {
        display: flex;
        flex-direction: column;
    }
    .input-group label {
        font-size: 15px;
        font-weight: 600;
        margin-bottom: 5px;
    }
    .input-group input {
        width: 300px;
        padding: 12px;
        border: 1px solid #ddd;
        border-radius: 6px;
        font-size: 14px;
        outline: none;
        transition: border-color 0.3s;
        box-sizing: border-box;
    }
    .input-group input:focus {
        border-color: #ff6699;
    }
    .input-group #postal-code {
    	width: 192px;
    }
    .button-group {
        display: flex;
        justify-content: space-between;
        padding-top: 10px;
    }
    .update-button, .address-button {
        background: #ff7f9d;
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 5px;
        cursor: pointer;
    }
    .delete-button {
	    background-color: #fff;
	    color: #ff6666;
	    border: 1px solid #ff6666;
	    padding: 6px 12px;
	    font-size: 12px;
	    border-radius: 4px;
	    cursor: pointer;
	}
	.delete-button:hover {
	    background: #ff6666;
	    color: #fff;
	}
    .password-container {
        position: relative;
        display: flex;
        align-items: center;
        width: 300px;
    }
    .password-container input {
        width: 300px;
        padding: 12px;
        border: 1px solid #ddd;
        border-radius: 6px;
        font-size: 14px;
        outline: none;
        transition: border-color 0.3s;
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
    .input-field {
	    display: flex;
	    align-items: center;
	    gap: 10px;
	    margin-bottom: 10px;
	}
	.error {
	    color: red;
	    font-size: 12px;
	    white-space: nowrap;
	}
    hr {
        margin: 20px 0;
        border: none;
        border-top: 1px solid #ccc;
    }
</style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="header-left">
                <h1>생화24</h1>
                <div class="search-container">
                    <input class="search-box" type="text" placeholder="찾으시는 꽃을 입력해주세요!">
                    <button class="search-button">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
            </div>
            <div class="header-right">
			    <!-- 로그인하지 않은 경우 -->
			    <sec:authorize access="isAnonymous()">
			        <a href="/login"><strong>로그인</strong></a>
			        <a href="/sign-up">회원가입</a>
			    </sec:authorize>
			
			    <!-- 로그인한 경우 -->
			    <sec:authorize access="isAuthenticated()">
			        <a href="/logout">로그아웃</a>
			    </sec:authorize>
			</div>
        </div>
        <div class="nav-container">
            <div class="nav">
                <a href="#">절화</a>
                <a href="#">난</a>
                <a href="#">관엽</a>
                <a href="#">기타</a>
            </div>
            <div class="nav-right">
                <a href="/mypage/edit-profile">마이페이지</a>
                <a href="/support-center/notice">고객센터</a>
            </div>
        </div>
        
        <div class="body-container">
            <div class="sidebar">
                <h2>마이페이지</h2>
                <a href="/mypage/edit-profile" class="active">내 정보 관리</a>
                <a href="#">장바구니</a>
                <a href="#">주문 내역</a>
                <a href="/mypage/inquiry-history">문의 내역</a>
            </div>
            
            <div class="profile-container">
                <h2>회원정보 수정</h2>
                    <form class="profile-content" id="profile-content">
					    <div class="input-group">
					        <label for="company">업체명</label>
					        <div class="input-field">
					            <input type="text" id="company" name="companyName" value="${userDetails.companyName}" maxlength="30">
					        </div>
					        
					        <label for="ceo">대표자명</label>
					        <div class="input-field">
					            <input type="text" id="ceo" name="ceoName" value="${userDetails.ceoName}" maxlength="30">
					        </div>
					        
					        <label for="phone">핸드폰번호</label>
					        <div class="input-field">
					            <input type="text" id="phone" name="phoneNum" value="${userDetails.phoneNum}" maxlength="13"
					            	placeholder="02-1234-5678 (- 포함)" oninput="this.value = this.value.replace(/[^0-9-]/g, '');">
					            <p class="error" id="phone-error"></p>
					        </div>
					        
					        <label for="company-phone">업체 전화번호</label>
					        <div class="input-field">
					            <input type="text" id="company-phone" name="companyNum" value="${userDetails.companyNum}" maxlength="13"
					            	 placeholder="010-1234-5678 (- 포함)" oninput="this.value = this.value.replace(/[^0-9-]/g, '');">
					            <p class="error" id="company-phone-error"></p>
					        </div>
					        
			                <label for="postal-code">우편번호</label>
			                <div class="input-field">
				                <input type="text" id="postal-code" name="postalCode" value="${userDetails.postalCode}" readonly>
				                <button type="button" class="address-button" onclick="searchAddress()">주소 찾기</button>
				            </div>
				            
				            <label for="address">주소</label>
			            	<div class="input-field">
				            	<input type="text" id="address" name="address" value="${userDetails.address}" readonly>
				            	<input type="text" id="detail-address" name="detailAddress" value="${userDetails.detailAddress}" maxlength="30"
				            		placeholder="상세 주소 (선택)" > 
				            </div>
					    </div>
					
					    <div class="button-group">
					        <button type="button" class="update-button" onclick="editProfile()">저장</button>
					        <button type="button" class="delete-button">회원탈퇴</button>
					    </div>
					</form>
                
                <hr>
                
                <h2>비밀번호 재설정</h2>
                <form class="password-content" id="password-content">
                    <div class="input-group">
                        <label for="current-password">현재 비밀번호</label>
                        <div class="input-field">
	                        <div class="password-container">
	                            <input type="password" id="current-password" value="${inputData.currentPassword}" maxlength="20">
	                            <i class="fa-solid fa-eye" id="toggle-password" onclick="togglePassword('current-password', this)"></i>
	                        </div>
	                        <p class="error" id="current-password-error"></p>
                        </div>
                        
                        <label for="password">비밀번호</label>
                        <div class="input-field">
	                        <div class="password-container">
	                            <input type="password" id="password" value="${inputData.password}" maxlength="20">
	                            <i class="fa-solid fa-eye" id="toggle-password" onclick="togglePassword('password', this)"></i>
	                        </div>
	                        <p class="error" id="password-error"></p>
                        </div>
                        
                        <label for="confirm-password">비밀번호 확인</label>
                        <div class="password-container input-field">
                            <input type="password" id="confirm-password" value="${inputData.confirmPassword}" maxlength="20">
                            <i class="fa-solid fa-eye" id="toggle-confirm-password" onclick="togglePassword('confirm-password', this)"></i>
                        </div>
                    </div>
                
                    <div class="button-group">
                    	<button type="button" class="update-button" onclick="resetPassword()">저장</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
<script>
	//카카오 우편번호 검색 API를 이용한 주소 검색
	function searchAddress() {
	    new daum.Postcode({
	        oncomplete: function(data) {
	            document.getElementById("postal-code").value = data.zonecode; // 우편번호 입력
	            document.getElementById("address").value = data.roadAddress; // 도로명 주소 입력
	        }
	    }).open();
	}
	
	// 회원정보 수정 요청
	function editProfile() {
		const form = document.getElementById("profile-content");
		
		// 입력 필드
	    var companyName = document.getElementById("company").value.trim();
	    var ceoName = document.getElementById("ceo").value.trim();
	    var phoneNum = document.getElementById("phone").value.trim();
	    var companyNum = document.getElementById("company-phone").value.trim();
	    var postalCode = document.getElementById("postal-code").value.trim();
	    var address = document.getElementById("address").value.trim();
	    var detailAddress = document.getElementById("detail-address").value.trim();
	    
	 	// 오류 메시지 필드
	    var errorFields = {
            companyName: document.getElementById("company-error"),
            ceoName: document.getElementById("ceo-error"),
            phoneNum: document.getElementById("phone-error"),
            companyNum: document.getElementById("company-phone-error"),
            postalCode: document.getElementById("postal-code-error"),
            address: document.getElementById("address-error"),
            detailAddress: document.getElementById("detail-address-error")
        };
	    
		// 유효성 검사: 1. 입력 여부   
	    if (!companyName) {
	    	alert("업체명을 입력하세요.");
	    	return false;
	    } else if (!ceoName) {
	    	alert("대표자명을 입력하세요.");
	    	return false;
	    } else if (!phoneNum) {
	    	alert("핸드폰 번호를 입력하세요.");
	    	return false;
	    } else if (!postalCode) {
	    	alert("주소를 입력하세요.");
	    	return false;
	    }
	 	
	    // 유효성 검사: 2. 입력 형식
	    var isValid = true;
	 	
	 	// 오류 메시지 초기화
	    Object.values(errorFields).forEach(el => { if (el) el.textContent = ""; });
	    
	    if (!/^(010)-\d{4}-\d{4}$/.test(phoneNum)) {
	        errorFields.phoneNum.textContent = "올바른 핸드폰 번호 형식이 아닙니다.";
	        isValid = false;
	    }

	    if (companyNum && !/^(\d{2,3}-\d{3,4}-\d{4}|\d{4}-\d{4})$/.test(companyNum)) {
	        errorFields.companyNum.textContent = "올바른 업체 전화번호 형식이 아닙니다.";
	        isValid = false;
	    }

	    if (!isValid) {
	        return false;
	    }

	    // API 요청
	    fetch("/mypage/edit-profile", {
	        method: "POST",
	        headers: { "Content-Type": "application/json" },
	        body: JSON.stringify({
	            companyName, ceoName, phoneNum, companyNum, postalCode, address, detailAddress
	        })
	    })
	    .then(response => {
	        if (response.ok) {
	            Swal.fire({
	                icon: "success",
	                title: "수정 완료",
	                text: "회원 정보가 성공적으로 수정되었습니다.",
	                confirmButtonColor: "#3085d6",
	                confirmButtonText: "확인"
	            }).then(() => location.reload());
	        } else {
	            return response.json().then(data => {
	                throw new Error(data.errorMessage || "회원 정보 수정 실패");
	            });
	        }
	    })
	    .catch(error => {
	  	    Swal.fire({
	  	        icon: 'error',
	  	        title: '오류 발생',
	  	        text: '처리 중 오류가 발생했습니다. 다시 시도해 주세요.',
	  	        confirmButtonColor: '#d33',
	  	        confirmButtonText: '확인'
	  	    });
	  	});
	}

	// 비밀번호 재설정 요청
	function resetPassword() {
		const form = document.getElementById("password-content");
		
		// 입력 필드
	  	var currentPassword = document.getElementById("current-password").value;
	  	var password = document.getElementById("password").value;
	  	var confirmPassword = document.getElementById("confirm-password").value;
	  	
	  	// 오류 메시지 필드
	    var errorFields = {
	    	currentPassword: document.getElementById("current-password-error"),
	    	password: document.getElementById("password-error")
	    }
	
	  	// 비밀번호 정규식: 영문 + 숫자 + 특수문자 포함
	  	var passwordRegex = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()_+=-])[A-Za-z\d!@#$%^&*()_+=-]*$/;

	  	if (!currentPassword || !password || !confirmPassword) {
	  		alert("비밀번호를 입력해주세요.")
	  		return false;
	  	}
	  	
	 	// 오류 메시지 초기화
	    Object.values(errorFields).forEach(el => { if (el) el.textContent = ""; });
	  	
	  	
	  	if (password.length < 8) {
	  		errorFields.password.textContent = "비밀번호는 8~20자 이내여야 합니다.";
	      	return false;
	  	}
	
	  	if (!passwordRegex.test(password)) {
	  		errorFields.password.textContent = "비밀번호는 영문, 숫자, 특수문자(!@#$%^&*()_+=-)를 포함해야 합니다.";
	      	return false;
	  	}
	
	  	if (password !== confirmPassword) {
	  		errorFields.password.textContent = "비밀번호가 일치하지 않습니다.";
	      	return false;
	  	}

	 	// API 요청
	  	fetch("/mypage/reset-password", {
	  	    method: "POST",
	  	    headers: {
	  	        "Content-Type": "application/json"
	  	    },
	  	    body: JSON.stringify({ 
	  	    	currentPassword, password, confirmPassword
			})
	  	})
	  	.then(response => {
	  	    if (response.ok) {
	  	    	Swal.fire({
	                icon: "success",
	                title: "재설정 완료",
	                text: "비밀번호가 성공적으로 재설정되었습니다.",
	                confirmButtonColor: "#3085d6",
	                confirmButtonText: "확인"
	            });
	  	    	
	  	   		// 입력 필드 초기화
	  	    	document.querySelectorAll("#password-content input")
	  	    		.forEach(input => input.value = "");
	  	    } else if (response.status === 400) {
	  	    	return response.json().catch(() => null).then(data => {
      	            if (data && data.errorMessage) {
      	            	errorFields.currentPassword.textContent = data.errorMessage; // 현재 비밀번호 불일치
      	            } else {
      	                location.reload();
      	            }
      	        });
	  	    } else {
	  	        throw new Error("서버 오류 발생");
	  	    }
	  	})
	  	.catch(error => {
	  	    Swal.fire({
	  	        icon: 'error',
	  	        title: '오류 발생',
	  	        text: '처리 중 오류가 발생했습니다. 다시 시도해 주세요.',
	  	        confirmButtonColor: '#d33',
	  	        confirmButtonText: '확인'
	  	    });
	  	});
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
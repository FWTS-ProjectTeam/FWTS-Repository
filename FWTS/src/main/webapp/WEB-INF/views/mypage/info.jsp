<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>생화 24 - 마이페이지</title>
<link rel="stylesheet" href="/resources/css/common.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<style>
    .sidebar .profile-active {
        font-weight: 600;
        background-color: #ff7f9d;
        color: white;
        border-radius: 5px;
    }
    
    .profile-container {
        width: 100%;
        margin: 0 10px;
    }
    .profile-form, .password-form {
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
    .input-field {
	    display: flex;
	    align-items: center;
	    gap: 10px;
	    margin-bottom: 10px;
	}
    
    .button-container {
        justify-content: space-between;
        padding-top: 10px;
	}
    .delete-button {
	    background-color: white;
	    color: #ff6666;
	    border: 1px solid #ff6666;
	    padding: 6px 12px;
	    font-size: 12px;
	    border-radius: 4px;
	    cursor: pointer;
	}
	.delete-button:hover {
	    background: #ff6666;
	    color: white;
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
    
	.required {
		color: red;
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
	<!-- 공통 -->
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
    
    <div class="body-container">
        <!-- 사이드바 -->
    	<%@ include file="/WEB-INF/views/common/mypage-sidebar.jsp" %>
        
        <div class="profile-container">
            <h2>회원정보 수정</h2>
               <form class="profile-form" id="profile-form">
    			<div class="input-group">
			        <label for="company">상호명 <span class="required">*</span></label>
			        <div class="input-field">
			            <input id="company" name="companyName" value="${userDetails.companyName}" maxlength="30">
			        </div>
        
			        <label for="ceo">대표자명 <span class="required">*</span></label>
			        <div class="input-field">
			            <input id="ceo" name="ceoName" value="${userDetails.ceoName}" maxlength="30">
			        </div>
        
			        <label for="phone">핸드폰번호 <span class="required">*</span></label>
			        <div class="input-field">
			            <input id="phone" name="phoneNum" value="${userDetails.phoneNum}" maxlength="13"
			            	placeholder="- 포함" oninput="this.value = this.value.replace(/[^0-9-]/g, '');">
			            <p class="error" id="phone-error"></p>
			        </div>
        
			        <label for="company-phone">사업장 전화번호</label>
			        <div class="input-field">
			            <input id="company-phone" name="companyNum" value="${userDetails.companyNum}" maxlength="13"
			            	 placeholder="- 포함" oninput="this.value = this.value.replace(/[^0-9-]/g, '');">
			            <p class="error" id="company-phone-error"></p>
			        </div>
        
	               <label for="postal-code">우편번호 <span class="required">*</span></label>
	               <div class="input-field">
		                <input id="postal-code" name="postalCode" value="${userDetails.postalCode}" readonly>
		                <button type="button" class="button" onclick="searchAddress()">주소 찾기</button>
		            </div>
           
		            <label for="address">주소 <span class="required">*</span></label>
		           	<div class="input-field">
		            	<input id="address" name="address" value="${userDetails.address}" readonly>
		            	<input id="detail-address" name="detailAddress" value="${userDetails.detailAddress}" maxlength="30">
            		</div>
           		
            		<!-- 도매업자 항목 -->
					<sec:authorize access="hasRole('ROLE_WHOLESALER')">
						<label for="bank">은행명 <span class="required">*</span></label>
			           	<div class="input-field">
			            	<input id="bank" name="bankName" value="${account.bankName}" maxlength="10">
	            		</div>
	            		
	            		<label for="account">계좌번호 <span class="required">*</span></label>
			           	<div class="input-field">
			            	<input id="account" name="accountNum" value="${account.accountNum}" maxlength="17"
			            		placeholder="- 포함" oninput="this.value = this.value.replace(/[^0-9-]/g, '');">
			            	<p class="error" id="account-error"></p>
	            		</div>
					</sec:authorize>
	    		</div>
	
			    <div class="button-container">
			        <button type="button" class="button" onclick="editProfile()">저장</button>
			        <button type="button" class="delete-button" onclick="deleteUser()">회원탈퇴</button>
			    </div>
			</form>
            
            <hr>
            
            <h2>비밀번호 재설정</h2>
            <form class="password-form" id="password-form">
                <div class="input-group">
                    <label for="current-password">현재 비밀번호</label>
                    <div class="input-field">
	                	<div class="password-container">
	                    	<input type="password" id="current-password" maxlength="20">
	                    	<i class="fa-solid fa-eye" id="toggle-password" onclick="togglePassword('current-password', this)"></i>
	                	</div>
	                	<p class="error" id="current-password-error"></p>
                    </div>
                    
                    <label for="password">비밀번호</label>
                    <div class="input-field">
                     	<div class="password-container">
                         	<input type="password" id="password" maxlength="20">
                         	<i class="fa-solid fa-eye" id="toggle-password" onclick="togglePassword('password', this)"></i>
                     	</div>
                     	<p class="error" id="password-error"></p>
                    </div>
                    
                    <label for="confirm-password">비밀번호 확인</label>
                    <div class="input-field password-container">
                        <input type="password" id="confirm-password" maxlength="20">
                        <i class="fa-solid fa-eye" id="toggle-confirm-password" onclick="togglePassword('confirm-password', this)"></i>
                    </div>
                </div>
                
            	<div class="button-container">
            		<button type="button" class="button" onclick="resetPassword()">저장</button>
            	</div>
            </form>
        </div>
    </div>
    
    <!-- 푸터 -->
    <%@ include file="/WEB-INF/views/common/footer.jsp"%>
</div>
</body>
<script>
	//카카오 우편번호 검색 API를 이용한 주소 검색
	function searchAddress() {
	    new daum.Postcode({
	        oncomplete: function(data) {
	            document.getElementById("postal-code").value = data.zonecode; // 우편번호 입력
	            document.getElementById("address").value = data.roadAddress; // 도로명 주소 입력
	            document.getElementById("detail-address").focus();
	        }
	    }).open();
	}
	
	// 회원정보 수정 요청
	function editProfile() {
	    var companyName = document.getElementById("company").value.trim();
	    var ceoName = document.getElementById("ceo").value.trim();
	    var phoneNum = document.getElementById("phone").value;
	    var companyNum = document.getElementById("company-phone").value;
	    var postalCode = document.getElementById("postal-code").value;
	    var address = document.getElementById("address").value;
	    var detailAddress = document.getElementById("detail-address").value.trim();

	    // 도매업자일 경우
	    const bankNameField = document.getElementById("bank");
	    const accountNumField = document.getElementById("account");
	    const isWholesaler = bankNameField !== null && accountNumField !== null;
	    
	    var bankName = isWholesaler ? bankNameField.value.trim() : "";
	    var accountNum = isWholesaler ? accountNumField.value.trim() : "";
	    
		// 유효성 검사: 1. 입력 여부   
	    if (!companyName) {
	    	alert("상호명을 입력해주세요.");
	    	return false;
	    } else if (!ceoName) {
	    	alert("대표자명을 입력해주세요.");
	    	return false;
	    } else if (!phoneNum) {
	    	alert("핸드폰번호를 입력해주세요.");
	    	return false;
	    } else if (!postalCode) {
	    	alert("주소를 입력해주세요.");
	    	return false;
	    }
	 	
	 	if (isWholesaler) {
	 		if (!bankName) {
	 			alert("은행명을 입력해주세요.");
		    	return false;
		    } else if (!accountNum) {
		    	alert("계좌번호를 입력해주세요.");
		    	return false;
		    }
	 	}
	 	
	    // 유효성 검사: 2. 입력 형식
	    var isValid = true;
	 	
	    var errorFields = {
            phoneNum: document.getElementById("phone-error"),
            companyNum: document.getElementById("company-phone-error")
        };
	 	
	    if (isWholesaler) {
	        errorFields.accountNum = document.getElementById("account-error");
	    }
	 	
	 	// 오류 메시지 초기화
	    Object.values(errorFields).forEach(el => { if (el) el.textContent = ""; });
	 	
	 	// 전화번호 정규식
	  	const phoneRegex = /^(010)-\d{4}-\d{4}$/;
	  	const companyPhoneRegex = /^(\d{2,3}-\d{3,4}-\d{4}|\d{4}-\d{4})$/;
	    
	    if (!phoneRegex.test(phoneNum)) {
	        errorFields.phoneNum.textContent = "올바른 핸드폰번호 형식이 아닙니다.";
	        isValid = false;
	    }

	    if (companyNum && !companyPhoneRegex.test(companyNum)) {
	        errorFields.companyNum.textContent = "올바른 사업장 전화번호 형식이 아닙니다.";
	        isValid = false;
	    }
	    
	    if (accountNum && (!/^\d[\d-]*\d$/.test(accountNum) || /--/.test(accountNum))) {
	    	errorFields.accountNum.textContent = "올바른 계좌번호 형식이 아닙니다.";
	    	isValid = false;
	    }

	    if (!isValid) {
	        return false;
	    }

	    // API 요청
	    fetch("/my-page/info/edit-profile", {
	        method: "POST",
	        headers: { "Content-Type": "application/json" },
	        body: JSON.stringify({
	        	companyName, ceoName, phoneNum, companyNum, postalCode, address, detailAddress,
	            ...(isWholesaler ? { bankName, accountNum } : {}) // 도매업자일 경우 은행 정보 추가
	        })
	    })
	    .then(response => {
	        if (response.ok) {
	            Swal.fire({
	                icon: 'success',
	                title: '수정 완료',
	                text: '회원 정보가 성공적으로 수정되었습니다.',
	                confirmButtonColor: '#3085d6',
	                confirmButtonText: "확인"
	            });
	        } else if (response.status === 400) {
	        	location.reload();
	        } else {
	        	throw new Error("서버 오류");
	        }
	    })	    
	    .catch(error => {
	  	    Swal.fire({
	  	        icon: 'error',
	  	        title: '수정 실패',
	  	        text: '처리 중 오류가 발생했습니다. 다시 시도해 주세요.',
	  	        confirmButtonColor: '#d33',
	  	        confirmButtonText: '확인'
	  	    });
	  	});
	}
	
	// 회원탈퇴 요청
	function deleteUser() {
		Swal.fire({
	        title: "정말로 탈퇴하시겠습니까?",
	        text: "이 작업은 되돌릴 수 없습니다!",
	        icon: "warning",
	        showCancelButton: true,
	        confirmButtonColor: "#d33",
	        cancelButtonColor: "#aaa",
	        confirmButtonText: "탈퇴",
	        cancelButtonText: "취소"
	    }).then((result) => {
	    	if (result.isConfirmed) {
	    	    const requestUrl = "/my-page/info/delete";

	    	    fetch(requestUrl, { method: "DELETE" })
    	        .then(response => response.json())
    	        .then(data => {
    	            if (data.success) {
    	                window.location.href = "/"; // 메인 페이지
    	            } else {
    	                throw new Error(data.message || '처리 중 오류가 발생했습니다. 다시 시도해 주세요.');
    	            }
    	        })
    	        .catch(error => {
    	            Swal.fire({
    	                icon: 'error',
    	                title: '탈퇴 실패',
    	                text: error.message,
    	                confirmButtonColor: '#d33',
    	                confirmButtonText: '확인'
    	            });
    	        });
	    	}
	    });
	}

	// 비밀번호 재설정 요청
	function resetPassword() {
	  	var currentPassword = document.getElementById("current-password").value;
	  	var password = document.getElementById("password").value;
	  	var confirmPassword = document.getElementById("confirm-password").value;
	  	
	  	// 유효성 검사: 1. 입력 여부
	  	if (!currentPassword || !password || !confirmPassword) {
	  		alert("비밀번호를 입력해주세요.")
	  		return false;
	  	}
	  	
	 	// 유효성 검사: 2. 입력 형식
	 	var errorFields = {
	    	currentPassword: document.getElementById("current-password-error"),
	    	password: document.getElementById("password-error")
	    }
	  	
	 	// 오류 메시지 초기화
	    Object.values(errorFields).forEach(el => { if (el) el.textContent = ""; });
	
	  	// 비밀번호 정규식: 영문 + 숫자 + 특수문자 포함
	  	var passwordRegex = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()_+=-])[A-Za-z\d!@#$%^&*()_+=-]*$/;
	  	
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
	  	fetch("/my-page/info/reset-password", {
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
	                icon: 'success',
	                title: '재설정 완료',
	                text: '비밀번호가 성공적으로 재설정되었습니다.',
	                confirmButtonColor: '#3085d6',
	                confirmButtonText: '확인'
	            });
	  	    	
	  	   		// 입력 필드 초기화
	  	    	document.querySelectorAll("#password-form input").forEach(input => input.value = "");
	  	    } else if (response.status === 400) {
	  	    	return response.json().catch(() => null).then(data => {
      	            if (data && data.errorMessage) {
      	            	errorFields.currentPassword.textContent = data.errorMessage; // 현재 비밀번호 불일치
      	            } else {
      	                location.reload();
      	            }
      	        });
	  	    } else {
	  	        throw new Error("서버 오류");
	  	    }
	  	})
	  	.catch(error => {
	  	    Swal.fire({
	  	        icon: 'error',
	  	        title: '재설정 실패',
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
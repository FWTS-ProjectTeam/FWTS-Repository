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
<title>생화24 - 인증 코드 입력</title>
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
          position: relative;
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
	.input-container {
	    display: flex;
	    align-items: center;
	    gap: 10px; /* 입력 필드와 버튼 사이 여백 */
	}
	.input-container input {
	    flex: 1; /* 입력 필드가 남은 공간을 다 차지하도록 */
	    padding: 12px;
	    border: 1px solid #ddd;
	    border-radius: 6px;
	    font-size: 14px;
	    outline: none;
	    transition: border-color 0.3s;
	    box-sizing: border-box;
	}
	.input-container input:focus {
		border-color: #ff6699;
	}
	.resend-code {
	    padding: 8px 12px;
	    font-size: 12px;
	    font-weight: 600;
	    color: #fff;
	    background-color: #ffb6c1;
	    cursor: pointer;
	    border: none;
	    border-radius: 6px;
	    white-space: nowrap;
	    transition: background-color 0.3s;
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
        background-color: #ff6699;
        color: #fff;
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
    /* SweetAlert2 모달이 떠도 레이아웃이 깨지지 않도록 설정 */
	html, body {
	    height: auto;
	    min-height: 100vh;
	    overflow: auto;
	}
</style>
</head>
<body>
<div class="container">
    <h1>이메일 인증</h1>
    <p class="description">
        <strong><%= email %></strong>으로 인증 코드를 전송했습니다.<br>
        해당 인증 코드는 5분간 유효합니다.
    </p>

    <form action="/find-password/verify-code" method="post">
        <div class="input-group">
		   <label for="code">인증 코드</label>
		   <div class="input-container">
		       <input type="text" id="code" name="code" required placeholder="6자리 인증 코드를 입력하세요">
		       <button type="button" class="resend-code" onclick="resendCode()">재전송</button>
		    </div>
		</div>

         <div class="button-container">
             <button type="submit" class="btn">확인</button>
         </div>
     </form>

     <div class="links-container">
         <a href="/find-password">이전으로 돌아가기</a>
     </div>
</div>
<script>
	// 인증 실패 알림창
	window.onload = function() {
		<c:if test="${not empty errorMessage}">
			Swal.fire({
				icon: 'error',
				title: '인증 실패',
				text: "${errorMessage}", 
				confirmButtonColor: '#d33',
				confirmButtonText: '확인'
			});
		</c:if>
	};
  
	function resendCode() {
		// 로딩 메시지 표시
	    Swal.fire({ title: "코드 전송 중...", didOpen: () => Swal.showLoading() });

	    // 이메일 인증 코드 요청
	    fetch("/find-password/resend-code", {
	        method: 'POST'
	    })
	    .then(response => response.json())
	    .then(data => {
	        Swal.close(); // 로딩창 닫기

	        if (data.errorMessage) {
	            Swal.fire({
	                icon: 'error',
	                title: '코드 전송 실패',
	                text: data.errorMessage,
	                confirmButtonColor: '#d33',
					confirmButtonText: '확인'
	            });
	        }
	    })
	    .catch(error => {
	        Swal.close();
	        Swal.fire({
	            icon: 'error',
	            title: '오류 발생',
	            text: '인증 코드를 전송할 수 없습니다. 다시 시도해 주세요.',
	            confirmButtonColor: '#d33',
				confirmButtonText: '확인'
	        });
	    });
	}
</script>
</body>
</html>
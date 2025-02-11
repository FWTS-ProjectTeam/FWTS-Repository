<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
		align-items: center;
		height: 100vh;
	}
	.container {
		max-width: 500px;
		width: 100%;
		background-color: #fefefe;
		border: 1px solid #ddd;
		padding: 20px;
		border-radius: 10px;
		box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
		text-align: left;
	}
	p {
		text-align: center;
	}
	h1 {
		color: #ff6699;
		font-weight: 600;
		text-align: center;
	}
	label {
		font-weight: 600;
		display: block;
		margin-top: 5px;
	}
	.terms-box {
		width: 100%;
		padding: 10px;
		margin: 5px 0;
		border: 1px solid #ddd;
		border-radius: 5px;
		box-sizing: border-box;
		height: 150px;
		overflow-y: auto;
		background-color: #f9f9f9;
		white-space: pre-line;
		font-size: 12.5px;
		line-height: 1.4;
	}
	.checkbox-container {
		display: flex;
		align-items: center;
		justify-content: center;
		margin-top: 5px;
		font-size: 14px;
		gap: 4px;
	}
	.checkbox-container input[type="checkbox"] {
		width: 18px;
		height: 18px;
		vertical-align: middle;
	}
	.checkbox-container label { line-height: 18px; }
	.button {
		width: 100%;
		padding: 10px;
		background-color: #ffb6c1;
		color: #fff;
		border: none;
		border-radius: 5px;
		cursor: not-allowed;
		font-size: 16px;
		margin-top: 20px;
	}
	.button.enabled {
		background-color: #ff6699;
		cursor: pointer;
	}
</style>
</head>
<body>
<div class="container">
	<h1><a href="/">생화24</a></h1>
	<p>가입을 환영합니다!</p>

	<label for="terms">약관 동의</label>
	<div class="terms-box" id="terms"><strong>제1조 (목적)</strong>
		본 약관은 생화24(이하 "회사")가 제공하는 생화 도매 거래 서비스(이하 "서비스")의 이용과 관련하여, 회사와 회원 간의 권리, 의무 및 책임 사항을 규정함을 목적으로 합니다.
		
		<strong>제2조 (수집하는 개인정보 항목 및 이용 목적)</strong>
		회사는 원활한 서비스 제공을 위해 아래와 같은 개인정보를 수집합니다.
		
		- 이메일 주소: 회원 식별
		- 사업자등록번호: 사업자 확인
		- 휴대폰 번호: 주문·거래 관련 연락
		- 업체 전화번호: 사업장 연락처 확인
		- 업체명: 사업장 정보 확인
		- 대표자명: 사업장 대표 확인
		- 우편주소: 상품 배송 및 청구서 발송

		<strong>제3조 (개인정보 보관 및 이용 기간)</strong>
		회원의 개인정보는 원칙적으로 회원 탈퇴 시 즉시 파기됩니다.
		단, 전자상거래법 및 세법 등에 따라 일정 기간 보관될 수 있습니다.
	</div>
	<div class="checkbox-container">
		<input type="checkbox" id="agree" name="privacy-consent" onclick="toggleButton()"> <label for="agree">개인정보 수집에 동의합니다.</label>
	</div>

	<button id="nextButton" class="button" disabled>다음</button>
</div>
</body>
<script>
	// 체크박스를 체크하면 버튼 활성화
	function toggleButton() {
		var checkbox = document.getElementById("agree");
		var button = document.getElementById("nextButton");
		if (checkbox.checked) {
			button.classList.add("enabled");
			button.disabled = false;
		} else {
			button.classList.remove("enabled");
			button.disabled = true;
		}
	}

	//다음 페이지 이동
	document.getElementById("nextButton").addEventListener("click", function() {
		fetch("/sign-up?step=2") // 서버에서 다음 단계로 변경된 JSP를 요청
	        .then(response => response.text())
	        .then(html => {
	            history.pushState(null, "", "/sign-up"); // URL 유지
	            document.open(); // 기존 문서 비우기
	            document.write(html); // 서버에서 받은 새로운 JSP 내용 삽입
	            document.close();
	        })
	        .catch(error => console.error("페이지 로드 중 오류 발생:", error));
	});
</script>
</html>
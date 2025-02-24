<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>생화 24 - 고객센터</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<style>
    /* 기존 body 스타일을 외부로 이동 */
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
    .info-container {
        width: 100%;
        margin: 0px 10px;
    }
    .info-content {
        padding: 5px 20px;
    }
    .input-group {
        display: flex;
        flex-direction: column;
        margin-bottom: 20px;
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
    .full-width {
        display: flex;
        align-items: left;
        justify-content: space-between;
    }
    .button-group {
        display: flex;
        justify-content: space-between;
        padding-top: 10px;
    }
    .address-button {
        width: 120px;
        background: #666;
        color: white;
        border: none;
        padding: 8px 12px;
        border-radius: 5px;
        cursor: pointer;
    }
    .update-button {
        background: #ff7f9d;
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 5px;
        cursor: pointer;
    }
    .delete-button {
        background: #fff;
        color: #ff6666;
        border: 1px solid #ff6666;
        padding: 10px 20px;
        border-radius: 5px;
        cursor: pointer;
    }
    .password-container {
        position: relative;
        display: flex;
        align-items: center;
        width: 300px;
    }
    .password-container input {
        width: 100%;
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

    /* hr 스타일 */
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
                <a href="/login"><strong>로그인</strong></a>
                <a href="/sign-up">회원가입</a>
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
                <a href="#">마이페이지</a>
                <a href="#">고객센터</a>
            </div>
        </div>
        
        <div class="body-container">
            <div class="sidebar">
                <h2>마이페이지</h2>
                <a href="#" class="active">내 정보 관리</a>
                <a href="#">장바구니</a>
                <a href="#">주문 내역</a>
                <a href="#">문의 내역</a>
            </div>
            
            <div class="info-container">
                <h2>회원정보 수정</h2>
                    <form class="info-content">
                        <div class="input-group">
                            <label for="company">업체명</label>
                            <input type="text" id="company" name="company" value="우리 꽃집">
                        </div>
                        <div class="input-group">
                            <label for="ceo">대표자명</label>
                            <input type="text" id="ceo" name="ceo" value="김대표">
                        </div>
                
                        <div class="input-group">
                            <label for="phone">핸드폰번호</label>
                            <input type="text" id="phone" name="phone" value="010-1234-5678">
                        </div>
                        <div class="input-group">
                            <label for="company-phone">업체 전화번호</label>
                            <input type="text" id="company-phone" name="company-phone" value="02-123-4567">
                        </div>
                
                        <div class="input-group">
                            <label for="address">주소</label>
                            <button type="button" class="address-button"><i class="fas fa-map-marker-alt"></i> 배송지 관리</button>
                        </div>
                
                        <div class="button-group">
                            <button type="submit" class="update-button">저장</button>
                            <button type="button" class="delete-button">회원탈퇴</button>
                        </div>
                    </form>
                
                <hr>
                
                <h2>비밀번호 재설정</h2>
                <form class="info-content" id="password-content" action="/find-password/reset-password" method="post"> 
                    <div class="input-group">
                        <label for="current-password">현재 비밀번호</label>
                        <div class="password-container">
                            <input type="password" id="password" name="password" value="${inputData.password}" maxlength="20">
                            <i class="fa-solid fa-eye" id="toggle-password" onclick="togglePassword('password', this)"></i>
                        </div>
                    </div>
                    
                    <div class="input-group">
                        <label for="password">비밀번호</label>
                        <div class="password-container">
                            <input type="password" id="new-password" name="newPassword" value="${inputData.password}" maxlength="20">
                            <i class="fa-solid fa-eye" id="toggle-password" onclick="togglePassword('password', this)"></i>
                        </div>
                    </div>
                    
                    <div class="input-group">
                        <label for="confirm-password">비밀번호 확인</label>
                        <div class="password-container">
                            <input type="password" id="confirm-password" name="confirmPassword" value="${inputData.confirmPassword}" maxlength="20">
                            <i class="fa-solid fa-eye" id="toggle-confirm-password" onclick="togglePassword('confirm-password', this)"></i>
                        </div>
                    </div>
                
                    <p class="error-message" id="error-message"></p>
                    <div class="button-group">
                    	<button type="button" class="update-button" onclick="validateForm()">저장</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
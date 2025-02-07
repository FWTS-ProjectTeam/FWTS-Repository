<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>생화24 - 비밀번호 재설정</title>
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
   .result-message {
       font-size: 14px;
       margin-bottom: 20px;
       color: #666;
   }
   .username {
       font-size: 18px;
       font-weight: 600;
       color: #ff6699;
       margin-bottom: 20px;
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
       box-sizing: border-box;
   }
   .btn {
       background-color: #ff6699;
       color: #fff;
   }
   .btn:hover { background-color: #ff5577; }
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
</head>
<body>
    <div class="find-container">
        <h1>비밀번호 재설정 성공</h1>
        <p class="result-message">비밀번호가 재설정되었습니다.</p>

        <div class="button-container">
            <button class="btn" onclick="location.href='/login'">로그인 하기</button>
        </div>

        <div class="links-container">
            <a href="/find-id">계속 찾으러 가기</a>
        </div>
    </div>
</body>
</html>
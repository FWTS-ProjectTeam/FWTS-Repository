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
        max-width: 600px;
        width: 100%;
        background-color: #fefefe;
        border: 1px solid #ddd;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        text-align: center;
    }
    h1 {
        color: #ff6699;
        font-weight: bold;
    }
    p {
        font-size: 16px;
        margin: 15px 0;
    }
    .button-container { margin-top: 30px; }
    .button-container a {
        display: inline-block;
        padding: 10px 20px;
        background-color: #ff6699;
        color: #fff;
        border-radius: 5px;
        text-decoration: none;
        font-weight: bold;
    }
    .button-container a:hover { background-color: #ff5577; }
</style>
</head>
<body>
    <div class="container">
        <h1>가입 완료!</h1>
        <p>가입을 축하합니다. 이제 다양한 서비스를 이용해보세요.</p>
        <div class="button-container">
            <a href="/login">로그인 하기</a>
        </div>
    </div>
</body>
</html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>주문 완료</title>
    <style>
        .container {
            text-align: center;
            margin-top: 100px;
        }
        .message {
            font-size: 20px;
            font-weight: bold;
            color: #ff6080;
        }
        .home-button {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #ff6080;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        .home-button:hover {
            background-color: #ff4060;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>✅ 주문이 완료되었습니다!</h1>
    <p class="message">${message}</p> <!-- 주문 성공/실패 메시지 출력 -->
    <a href="/buyer/orderList" class="home-button">내 주문 내역 보기</a>
</div>

</body>
</html>

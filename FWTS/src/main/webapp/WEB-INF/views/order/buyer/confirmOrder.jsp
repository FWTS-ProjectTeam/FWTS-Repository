<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>주문 확인</title>
    <style>
        .container {
            text-align: center;
            padding: 50px;
        }
        .info-box {
            border: 1px solid #ddd;
            padding: 15px;
            margin-bottom: 20px;
            text-align: left;
            display: inline-block;
        }
        .button {
            display: inline-block;
            padding: 10px 20px;
            background-color: #ff6080;
            color: white;
            border-radius: 5px;
            text-decoration: none;
            margin: 10px;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>🛒 주문 확인</h1>

    <div class="info-box">
        <h3>구매자 정보</h3>
        <p><strong>대표자명:</strong> ${orderNow.ceoName}</p>
        <p><strong>연락처:</strong> ${orderNow.phoneNum}</p>
        <p><strong>배송지:</strong> ${orderNow.deliveryAddress}</p>
    </div>

    <div class="info-box">
        <h3>상품 정보</h3>
        <p><strong>상품 아이디:</strong> ${orderNow.proId}</p>
        <p><strong>상품명:</strong> ${orderNow.proName}</p>
    </div>

    <div class="info-box">
        <h3>입금 계좌</h3>
        <p><strong>계좌 번호:</strong> ${orderNow.accountNum}</p>
    </div>

    <form action="/buyer/placeOrder" method="post">
        <input type="hidden" name="proId" value="${orderNow.proId}">
        <button type="submit" class="button">✅ 주문 확정</button>
    </form>

    <a href="/productList" class="button" style="background-color: gray;">❌ 취소</a>
</div>

</body>
</html>

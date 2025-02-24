<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>주문 상세</title>
    <style>
        .container {
            display: flex;
            align-items: flex-start;
            max-width: 1200px;
            margin: 20px auto;
        }
        .mypage-menu {
            width: 200px;
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.1);
            margin-right: 20px;
        }
        .mypage-menu ul li.active {
            background-color: #ff6080;
            color: white;
            border-radius: 5px;
        }
        .content {
            flex-grow: 1;
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.1);
        }
        .section {
            margin-bottom: 20px;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
    </style>
</head>
<body>

    <div class="container">
        <div class="mypage-menu">
            <h2>마이페이지</h2>
            <ul>
                <li><a href="/mypage/profile">내 정보 관리</a></li>
                <li><a href="/buyer/cartList">장바구니</a></li>
                <li class="active"><a href="/buyer/orderList">주문 내역</a></li>
                <li><a href="/mypage/inquiries">문의 내역</a></li>
            </ul>
        </div>

        <div class="content">
            <h1>📦 주문 상세</h1>

            <div class="section">
                <h2>주문 정보</h2>
                <p><strong>상품 아이디:</strong> ${order.proId}</p>
                <p><strong>상품명:</strong> ${order.proName}</p>
                <p><strong>주문번호:</strong> ${order.orderNum}</p>
                <p><strong>주문일:</strong> ${order.orderDate}</p>
                <p><strong>수량:</strong> ${order.purchaseQuantity}개</p>
                <p><strong>가격:</strong> ${order.totalPrice}원</p>
                <p><strong>상태:</strong> 
                    <c:choose>
                        <c:when test="${order.orderState == 0}">상품 준비중</c:when>
                        <c:when test="${order.orderState == 1}">배송중</c:when>
                        <c:when test="${order.orderState == 2}">배송 완료</c:when>
                        <c:otherwise>상태 미확인</c:otherwise>
                    </c:choose>
                </p>
            </div>

            <div class="section">
                <h2>판매자 정보</h2>
                <p><strong>업체명:</strong> ${order.companyName}</p>
                <p><strong>대표자명:</strong> ${order.ceoName}</p>
                <p><strong>연락처:</strong> ${order.phoneNum}</p>
            </div>

            <div class="section">
                <h2>배송 정보</h2>
                <p><strong>주소:</strong> ${order.deliveryAddress}</p>
                <p><strong>택배사:</strong> ${order.courier}</p>
                <p><strong>운송장번호:</strong> ${order.shipmentNum}</p>
            </div>
            
        </div>
    </div>

</body>
</html>

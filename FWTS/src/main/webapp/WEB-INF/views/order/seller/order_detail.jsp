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
        .status {
            font-weight: bold;
            padding: 5px 10px;
            border-radius: 5px;
        }
        .status-red { color: red; }       /* 입금확인전 */
        .status-yellow { color: orange; } /* 배송준비중 */
        .status-green { color: green; }   /* 배송중 */
        .status-blue { color: blue; }     /* 배송완료 */
        
        .input-box {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .save-button {
            background-color: #ff6080;
            color: white;
            padding: 10px 15px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            font-size: 16px;
            margin-top: 10px;
            width: 100%;
        }
    </style>
</head>
<body>

    <div class="container">
        <div class="mypage-menu">
            <h2>마이페이지</h2>
            <ul>
                <li><a href="/mypage/profile">내 정보 관리</a></li>
                <li><a href="/mypage/products">상품 관리</a></li>
                <li class="active"><a href="/seller/orderList">주문 · 배송 관리</a></li>
                <li><a href="/mypage/statistics">통계</a></li>
            </ul>
        </div>

        <div class="content">
            <h1>📦 주문 상세</h1>

            <!-- ✅ 주문 정보 -->
            <div class="section">
                <h2>주문 정보</h2>
                <p><strong>상품 아이디:</strong> ${order.proId}</p>
                <p><strong>상품명:</strong> ${order.proName}</p>
                <p><strong>주문번호:</strong> ${order.orderNum}</p>
                <p><strong>주문일:</strong> ${order.orderDate}</p>
                <p><strong>수량:</strong> ${order.purchaseQuantity}개</p>
                <p><strong>가격:</strong> ${order.totalPrice}원</p>
                
                <p><strong>상태:</strong> 
                    <span id="orderStatus" class="status 
                        <c:choose>
                            <c:when test="${order.orderState == 0}">status-red">입금확인중</c:when>
                            <c:when test="${order.orderState == 1}">status-yellow">배송준비중</c:when>
                            <c:when test="${order.orderState == 2}">status-green">배송중</c:when>
                            <c:when test="${order.orderState == 3}">status-blue">배송완료</c:when>
                            <c:otherwise>상태 미확인</c:otherwise>
                        </c:choose>
                    </span>
                </p>

                <label for="orderState">주문 상태 변경:</label>
                <select id="orderState" class="input-box">
                    <option value="1" ${order.orderState == 1 ? 'selected' : ''}>배송준비중</option>
                    <option value="2" ${order.orderState == 2 ? 'selected' : ''}>배송중</option>
                    <option value="3" ${order.orderState == 3 ? 'selected' : ''}>배송완료</option>
                </select>
            </div>

            <!-- ✅ 구매자 정보 -->
            <div class="section">
                <h2>구매자 정보</h2>
                <p><strong>업체명:</strong> ${order.companyName}</p>
                <p><strong>대표자명:</strong> ${order.ceoName}</p>
                <p><strong>휴대폰 번호:</strong> ${order.phoneNum}</p>
                <p><strong>업체 전화번호:</strong> ${order.companyNum}</p>
                <p><strong>주소:</strong> ${order.deliveryAddress}</p>
            </div>

            <!-- ✅ 운송장 정보 -->
            <div class="section">
                <h2>운송장 정보</h2>
                <label for="courier">택배사:</label>
                <input type="text" id="courier" class="input-box" value="${order.courier}">

                <label for="shipmentNum">운송번호:</label>
                <input type="text" id="shipmentNum" class="input-box" value="${order.shipmentNum}">
            </div>

            <!-- ✅ 모든 변경 사항을 저장하는 하나의 버튼 -->
            <button class="save-button" onclick="saveOrderInfo()">✅ 저장</button>

        </div>
    </div>

<script>
    function saveOrderInfo() {
        const orderNum = "${order.orderNum}";
        const orderState = document.getElementById("orderState").value;
        const courier = document.getElementById("courier").value;
        const shipmentNum = document.getElementById("shipmentNum").value;

        // 🚨 유효성 검사
        if (courier.trim() === "" || shipmentNum.trim() === "") {
            if (!confirm("택배사와 운송번호가 비어 있습니다. 상태만 변경하시겠습니까?")) {
                return;
            }
        }

        const formData = new URLSearchParams();
        formData.append("orderNum", orderNum);
        formData.append("orderState", orderState);
        formData.append("courier", courier);
        formData.append("shipmentNum", shipmentNum);

        fetch('/seller/updateOrderInfo', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: formData.toString()
        })
        .then(response => response.text())
        .then(data => {
            alert(data);
            location.reload(); // ✅ 업데이트 후 새로고침
        })
        .catch(error => console.error("Error:", error));
    }
</script>

</body>
</html>

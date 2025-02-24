<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>상품 상세</title>
    <style>
        .container {
            max-width: 600px;
            margin: 30px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 10px;
            text-align: center;
            background-color: #fff;
        }
        .info-box {
            text-align: left;
            border: 1px solid #ddd;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            background-color: #f9f9f9;
        }
        .input-box {
            width: 60px;
            padding: 5px;
            text-align: center;
            margin: 5px;
        }
        .button {
            display: inline-block;
            padding: 10px 15px;
            margin: 10px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            font-size: 16px;
        }
        .order-button {
            background-color: #ff6080;
            color: white;
        }
        .cart-button {
            background-color: #ffcc00;
            color: black;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>🛍 상품 상세</h1>

    <!-- ✅ 상품 정보 -->
    <div class="info-box">
        <h3>상품 정보</h3>
        <p><strong>상품 아이디:</strong> ${product.proId}</p>
        <p><strong>상품명:</strong> ${product.proName}</p>
        <p><strong>상품 단가:</strong> <span id="unitPriceText">${product.unitPrice}</span>원</p>
        <p><strong>배송비:</strong> <span id="deliveryFeeText">${product.deliveryFee}</span>원</p>
    </div>

    <!-- ✅ 주문 정보 -->
    <div class="info-box">
        <h3>주문 정보</h3>
        
        <label>수량:</label>
        <input type="number" id="quantity" class="input-box" value="1" min="1" onchange="updateTotalPrice()">
        
        <!-- 총 결제액 -->
        <p><strong>총 결제액:</strong> <span id="totalPrice">${product.unitPrice + product.deliveryFee}원</span></p>
        <input type="hidden" id="totalPriceInput" value="${product.unitPrice + product.deliveryFee}">

        <!-- ✅ 주문 및 장바구니 버튼 -->
        <form action="/buyer/orderNow" method="post" onsubmit="syncTotalPrice()">
            <input type="hidden" name="proId" value="${product.proId}">
            <input type="hidden" name="unitPrice" id="unitPrice" value="${product.unitPrice}">
            <input type="hidden" name="deliveryFee" id="deliveryFee" value="${product.deliveryFee}">
            <input type="hidden" name="purchaseQuantity" id="orderQuantity" value="1">
            <input type="hidden" name="totalPrice" id="orderTotalPrice" value="${product.unitPrice + product.deliveryFee}">
            <button type="submit" class="order-button">🛒 주문하기</button>
        </form>

        <form action="/buyer/addToCart" method="post" onsubmit="syncTotalPrice()">
            <input type="hidden" name="proId" value="${product.proId}">
            <input type="hidden" name="selectedQuantity" id="cartQuantity" value="1">
            <button type="submit" class="button cart-button">🛒 장바구니 추가</button>
        </form>
    </div>
</div>

<script>
    function updateTotalPrice() {
        let quantity = parseInt(document.getElementById("quantity").value);
        let unitPrice = parseInt(document.getElementById("unitPrice").value);
        let deliveryFee = parseInt(document.getElementById("deliveryFee").value);

        if (quantity < 1) {
            alert("최소 1개 이상 주문해야 합니다.");
            document.getElementById("quantity").value = 1;
            quantity = 1;
        }

        let totalPrice = (unitPrice * quantity) + deliveryFee;
        document.getElementById("totalPrice").innerText = totalPrice.toLocaleString() + "원";
        document.getElementById("totalPriceInput").value = totalPrice;

        // ✅ 주문 및 장바구니 값 업데이트
        document.getElementById("orderQuantity").value = quantity;
        document.getElementById("cartQuantity").value = quantity;
        document.getElementById("orderTotalPrice").value = totalPrice;
    }

    // ✅ 주문 또는 장바구니 추가 시 최신 가격을 반영
    function syncTotalPrice() {
        updateTotalPrice();
    }
</script>

</body>
</html>

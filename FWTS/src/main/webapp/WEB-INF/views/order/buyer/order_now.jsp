<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>상품 주문</title>
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <style>
        .container {
            max-width: 500px;
            margin: 30px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 10px;
            background-color: #fff;
        }
        h1 {
            font-size: 24px;
            text-align: center;
        }
        .info-section {
            margin-bottom: 15px;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            background-color: #f9f9f9;
        }
        .info-section h2 {
            font-size: 18px;
        }
        .submit-button {
            background-color: #ff6080;
            color: white;
            padding: 12px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            font-size: 18px;
            width: 100%;
            text-align: center;
            margin-top: 15px;
        }
        .submit-button:hover {
            background-color: #e05570;
        }
        .success-message {
            text-align: center;
            background-color: #dff0d8;
            color: #3c763d;
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 5px;
            font-weight: bold;
            display: none;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>📦 상품 주문</h1>

    <!-- ✅ 주문 완료 메시지 -->
    <c:if test="${not empty orderSuccessMessage}">
        <div id="orderSuccessMessage" class="success-message">${orderSuccessMessage}</div>
    </c:if>

    <!-- ✅ 구매자 정보 -->
    <div class="info-section">
        <h2>구매자 정보</h2>
        <p><strong>대표자명:</strong> ${orderNow.ceoName}</p>
        <p><strong>연락처:</strong> ${orderNow.phoneNum}</p>
        
        <p><strong>기존 배송지:</strong> 
            <c:choose>
                <c:when test="${not empty orderNow.address}">
                    (${orderNow.postalCode}) ${orderNow.address}, ${orderNow.addressDetail}
                </c:when>
                <c:otherwise>
                    <span style="color: red;">배송지 정보 없음</span>
                </c:otherwise>
            </c:choose>
        </p>

        <!-- ✅ 주소 검색 (기존 배송지 유지 또는 새로 입력 가능) -->
        <label>우편번호:</label>
        <input type="text" id="postalCode" name="postalCode" value="${orderNow.postalCode}" readonly>
        <button type="button" onclick="openAddressPopup()">🔍 검색</button>

        <label>주소:</label>
        <input type="text" id="address" name="address" value="${orderNow.address}" readonly>

        <label>상세 주소:</label>
        <input type="text" id="addressDetail" name="addressDetail" value="${orderNow.addressDetail}">
    </div>

    <!-- ✅ 주문 상품 정보 -->
    <div class="info-section">
        <h2>상품 정보</h2>
        <p><strong>상품 아이디:</strong> ${orderNow.proId}</p>
        <p><strong>상품명:</strong> ${orderNow.proName}</p>
        <p><strong>상품 단가:</strong> ${param.unitPrice}원</p>
        <p><strong>배송비:</strong> ${param.deliveryFee}원</p>
        <p><strong>주문 수량:</strong> ${param.purchaseQuantity}개</p>
        <p><strong>총 결제액:</strong> ${param.totalPrice}원</p>
    </div>

    <!-- ✅ 판매자 계좌 정보 -->
    <div class="info-section">
        <h2>판매자 정보</h2>
        <p><strong>판매 업체:</strong> ${orderNow.companyName}</p>
        <p><strong>계좌 이름:</strong> ${orderNow.bankName}</p>
        <p><strong>입금 계좌:</strong> ${orderNow.accountNum}</p>
    </div>

    <!-- ✅ 주문 확정 버튼 (맨 아래로 이동) -->
    <form action="/buyer/placeOrder" method="post">
		<!-- ✅ cartId 값이 없으면 기본값 0으로 설정 -->
		<input type="hidden" name="cartId" value="${param.cartId != null ? param.cartId : 0}">
        <input type="hidden" name="proId" value="${param.proId}">
        <input type="hidden" name="purchaseQuantity" value="${param.purchaseQuantity}">
        <input type="hidden" name="totalPrice" value="${param.totalPrice}">
        <input type="hidden" name="postalCode" id="hiddenPostalCode">
        <input type="hidden" name="address" id="hiddenAddress">
        <input type="hidden" name="addressDetail" id="hiddenAddressDetail">
        
        <button type="submit" class="submit-button">✅ 주문 확정</button>
    </form>
</div>

<script>
    function openAddressPopup() {
        new daum.Postcode({
            oncomplete: function(data) {
                document.getElementById("postalCode").value = data.zonecode;
                document.getElementById("address").value = data.roadAddress;
                document.getElementById("addressDetail").focus();

                // ✅ 숨겨진 input 값도 함께 업데이트 (폼 전송 시 사용)
                document.getElementById("hiddenPostalCode").value = data.zonecode;
                document.getElementById("hiddenAddress").value = data.roadAddress;
            }
        }).open();
    }

    // ✅ 상세 주소 입력 시 hidden input에 반영
    document.getElementById("addressDetail").addEventListener("input", function() {
        document.getElementById("hiddenAddressDetail").value = this.value;
    });

    // ✅ 폼 제출 시 hidden input 값 동기화
    document.querySelector("form").addEventListener("submit", function() {
        document.getElementById("hiddenPostalCode").value = document.getElementById("postalCode").value;
        document.getElementById("hiddenAddress").value = document.getElementById("address").value;
        document.getElementById("hiddenAddressDetail").value = document.getElementById("addressDetail").value;
    });
</script>

</body>
</html>
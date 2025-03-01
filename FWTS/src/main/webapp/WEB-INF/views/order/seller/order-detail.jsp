<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>생화24 - 주문 상세</title>
<link rel="stylesheet" href="/resources/css/common.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<style>
	.sidebar .order-active {
        font-weight: 600;
        background-color: #ff7f9d;
        color: white;
        border-radius: 5px;
    }
    
    .order-container {
    	width: 100%;
        background-color: #fff;
        margin: 0 10px;
        padding: 20px;
        border-radius: 10px;
        border: 1px solid #ddd;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }
    
    .section {
        margin-bottom: 20px;
        margin: 20px 10px;
        padding: 0 15px;
        border: 1px solid #ddd;
        border-radius: 5px;
        background-color: #f9f9f9;
    }
    
    .status-group {
	    display: flex;
	    align-items: center; /* 수직 중앙 정렬 (필요하면 추가) */
	    width: 100%; /* 부모 요소의 전체 너비 사용 */
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
    
    .status-box {
        width: 20%;
        padding: 8px;
        margin-left: 10px;
        border: 1px solid #ddd;
        border-radius: 5px;
    }
    
    .input-group {
        display: flex;
        flex-direction: column;
    }
    .input-group label {
        font-size: 15px;
        font-weight: 600;
        margin-bottom: 5px;
    }
    .input-group input {
        width: 50%;
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
    .input-group #postal-code {
    	width: 192px;
    }
    .input-field {
	    display: flex;
	    align-items: center;
	    gap: 10px;
	    margin-bottom: 10px;
	}
    
    .save-button {
        width: 100%;
        margin: 10px 0 0 0;
        font-size: 18px;
    }
    .save-button:hover {
        background-color: #ff6080;
    }
    .save-button i {
    	margin-right: 10px;
    }
</style>
</head>
<body>
<div class="container">
    <!-- 공통 -->
   	<%@ include file="/WEB-INF/views/common/header.jsp" %>
     
	<div class="body-container">
		<!-- 사이드바 -->
    	<%@ include file="/WEB-INF/views/common/mypage-sidebar.jsp" %>

        <div class="order-container">
            <h1>주문 상세</h1>

            <!-- 주문 정보 -->
            <div class="section">
                <h2>주문 정보</h2>
                <p><strong>상품 ID:</strong> ${order.proId}</p>
                <p><strong>상품명:</strong> ${order.proName}</p>
                <p><strong>주문번호:</strong> ${order.orderNum}</p>
                <p><strong>주문일:</strong> ${order.orderDate}</p>
                <p><strong>수량:</strong> ${order.purchaseQuantity} 개</p>
                <p><strong>가격:</strong> <fmt:formatNumber value="${order.totalPrice}" type="number" /> 원</p>
                
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

				<p class="status-group">
					<label for="orderState"><strong>상태 변경:</strong></label>
	                <select id="orderState" class="status-box">
	                    <option value="1" ${order.orderState == 1 ? 'selected' : ''}>배송준비중</option>
	                    <option value="2" ${order.orderState == 2 ? 'selected' : ''}>배송중</option>
	                    <option value="3" ${order.orderState == 3 ? 'selected' : ''}>배송완료</option>
	                </select>
				</p>
            </div>

            <!-- 구매자 정보 -->
            <div class="section">
                <h2>구매자 정보</h2>
                <p><strong>업체명:</strong> ${order.companyName}</p>
                <p><strong>대표자명:</strong> ${order.ceoName}</p>
                <p><strong>휴대폰 번호:</strong> ${order.phoneNum}</p>
                <p><strong>업체 전화번호:</strong> ${order.companyNum}</p>
                <p><strong>배송지:</strong> ${order.deliveryAddress}</p>
            </div>

            <!-- 운송장 정보 -->
            <div class="section input-group">
                <h2>운송장 정보</h2>
                <label for="courier">택배사</label>
                <div class="input-field">
                	<input type="text" id="courier" value="${order.courier}">
				</div>
                <label for="shipmentNum">운송장 번호</label>
                <div class="input-field">
                	<input type="text" id="shipmentNum" value="${order.shipmentNum}">
                </div>
            </div>

            <!-- 모든 변경 사항을 저장하는 하나의 버튼 -->
            <button class="save-button button" onclick="saveOrderInfo()">
            	<i class="fa-solid fa-check"></i>저장
            </button>
        </div>
    </div>
    
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</div>
<script>
    function saveOrderInfo() {
        const orderNum = "${order.orderNum}";
        const orderState = document.getElementById("orderState").value;
        const courier = document.getElementById("courier").value;
        const shipmentNum = document.getElementById("shipmentNum").value;

        // 유효성 검사
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
            location.href="/seller/orders"; // 주문 목록 페이지
        })
        .catch(error => console.error("Error:", error));
    }
</script>
</body>
</html>
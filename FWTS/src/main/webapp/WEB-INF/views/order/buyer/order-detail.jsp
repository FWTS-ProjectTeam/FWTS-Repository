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
    
    .status {
        font-weight: bold;
        padding: 5px 10px;
        border-radius: 5px;
    }
    .status-red { color: red; }       /* 입금확인전 */
    .status-yellow { color: orange; } /* 배송준비중 */
    .status-green { color: green; }   /* 배송중 */
    .status-blue { color: blue; }     /* 배송완료 */
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
    
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</div>
</body>
</html>
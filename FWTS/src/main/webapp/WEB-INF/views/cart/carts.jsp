<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>장바구니</title>
<link rel="stylesheet" href="/resources/css/common.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<style>
	.sidebar .cart-active {
        font-weight: 600;
        background-color: #ff7f9d;
        color: white;
        border-radius: 5px;
    }
	
    .cart-container {
        width: 100%;
        margin: 30px 20px;
    }
    
    .cart-item {
        padding: 15px;
        margin-bottom: 15px;
        border: 1px solid #ddd;
        border-radius: 10px;
        background-color: #fefefe;
        position: relative;
    }
    .cart-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-size: 18px;
        font-weight: bold;
        padding-bottom: 8px;
    }
    .cart-controls {
        display: flex;
        gap: 8px;
    }
    .input-box {
        width: 50px;
        padding: 5px;
        text-align: center;
        font-size: 16px;
    }
    .button {
        padding: 8px 12px;
        border: none;
        cursor: pointer;
        border-radius: 5px;
        font-size: 14px;
    }
    .delete-button {
        background-color: #ff4d4d;
        color: white;
    }
    .checkout-button {
        background-color: #ff6080;
        color: white;
    }
    .price-info {
        display: flex;
        justify-content: space-between;
        font-size: 16px;
        padding: 5px 0;
    }
    .total-price {
        font-size: 18px;
        font-weight: bold;
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
    	
    	<div class="cart-container">
		    <c:forEach var="cartItem" items="${cartList}">
		        <div class="cart-item" id="cart-${cartItem.cartId}">
		            <div class="cart-header">
		                ${cartItem.proName}
		                <div class="cart-controls">
		                    <!-- 삭제 버튼 -->
		                    <button class="button delete-button" onclick="deleteCartItem(${cartItem.cartId})">삭제</button>
		                    
		                    <!-- 결제 버튼 -->
		                    <button class="button checkout-button" onclick="orderNow(${cartItem.cartId}, ${cartItem.proId})">결제</button>
		                </div>
		            </div>
		            
		            <p>상품 ID: ${cartItem.proId}</p>
		
		            <!-- 단가 표시 -->
		            <div class="price-info">
		                <span>단가:</span> 
		                <strong>
		                	<input id="unitPrice-${cartItem.cartId}" hidden="hidden" value="${cartItem.unitPrice}">
		                	<fmt:formatNumber value="${cartItem.unitPrice}" type="number" /> 원
		                </strong>
		            </div>
		
		            <!-- 수량 변경 -->
		            <div class="price-info">
		                <span>수량:</span>
		                <input type="number" id="quantity-${cartItem.cartId}" class="input-box"
		                       value="${cartItem.selectedQuantity}" min="1"
		                       oninput="updateTotal(${cartItem.cartId})">
		            </div>
		
		            <!-- 상품 가격 -->
		            <div class="price-info">
		                <span>상품 가격:</span>
		                <strong>
		                	<span id="productTotal-${cartItem.cartId}">
		                		<fmt:formatNumber value="${cartItem.unitPrice * cartItem.selectedQuantity}" type="number" />
		                	</span>원
		                </strong>
		            </div>
		
		            <!-- 배송비 -->
		            <div class="price-info">
		                <span>배송비:</span>
		                <strong>
		                	<span id="deliveryFee-${cartItem.cartId}">
		                		<fmt:formatNumber value="${cartItem.deliveryFee}" type="number" />
		                	</span>원
		                </strong>
		            </div>
		
		            <!-- 총 결제액 -->
		            <div class="price-info total-price">
		                <span>총 결제액:</span>
		                <strong>
		                	<span id="totalPriceDisplay-${cartItem.cartId}">
		                		<fmt:formatNumber value="${(cartItem.unitPrice * cartItem.selectedQuantity) + cartItem.deliveryFee}" type="number" />
		                	</span>원
		                </strong>
		            </div>
		        </div>
		    </c:forEach>
		
		    <c:if test="${empty cartList}">
		        <p style="text-align: center; color: gray;">장바구니가 비어 있습니다.</p>
		    </c:if>
		
		    <!-- 페이징 처리 -->
		    <div class="pagination">
		        <c:if test="${currentPage > 1}">
		            <a href="?page=${currentPage - 1}">« 이전</a>
		        </c:if>
		        
		        <c:set var="startPage" value="${currentPage - 2 > 0 ? currentPage - 2 : 1}" />
		        <c:set var="endPage" value="${startPage + 4 < totalPages ? startPage + 4 : totalPages}" />
			            
	            <c:forEach var="i" begin="${startPage}" end="${endPage}">
			        <a href="?page=${i}" class="${i == currentPage ? 'active' : ''}">${i}</a>
			    </c:forEach>
			    
		        <c:if test="${currentPage < totalPages}">
		            <a href="?page=${currentPage + 1}">다음 »</a>
		        </c:if>
		    </div>
	    </div>
	</div>
	
	<!-- 푸터 -->
    <%@ include file="/WEB-INF/views/common/footer.jsp"%>
</div>
<script>
	function orderNow(cartId, proId) {
		var quantity = document.getElementById(`quantity-\${cartId}`).value;
	    location.href = "/buyer/orderNow?proId=" + proId + "&quantity=" + quantity;
	}

    function updateTotal(cartId) {
    	var quantityInput = document.getElementById(`quantity-\${cartId}`);
    	var unitPrice = parseInt(document.getElementById(`unitPrice-\${cartId}`).value);
    	var deliveryFee = parseInt(document.getElementById(`deliveryFee-\${cartId}`).innerText);
    	var productTotalDisplay = document.getElementById(`productTotal-\${cartId}`);
    	var totalPriceDisplay = document.getElementById(`totalPriceDisplay-\${cartId}`);
        
    	var quantity = parseInt(quantityInput.value);
    	console.log(unitPrice+":   " +quantity)
        var productTotal = unitPrice * quantity;
        var totalPrice = productTotal + deliveryFee;

        productTotalDisplay.innerText = productTotal.toLocaleString();
        totalPriceDisplay.innerText = totalPrice.toLocaleString();
    }
    
    function deleteCartItem(cartId) {
        if (!confirm("정말 삭제하시겠습니까?")) return;

        fetch(`/buyer/removeFromCart?cartId=\${cartId}`, { method: "POST" })
            .then(response => response.json())
            .then(data => {
                alert(data.message);
                if (data.status === "success") {
                    document.getElementById(`cart-\${cartId}`).remove();
                    location.reload();
                }
            })
            .catch(error => console.error("🚨 삭제 에러:", error));
    }
</script>
</body>
</html>
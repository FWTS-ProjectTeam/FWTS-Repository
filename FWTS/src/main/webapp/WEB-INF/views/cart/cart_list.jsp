<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
        border: 2px solid #ddd;
        border-radius: 10px;
        background-color: #f9f9f9;
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
		                    <!-- ✅ 삭제 버튼 -->
		                    <button class="button delete-button" onclick="deleteCartItem(${cartItem.cartId})">삭제</button>
		                    
		                    <!-- ✅ 결제 버튼 -->
		                    <form id="orderForm-${cartItem.cartId}" action="/buyer/orderNow" method="post">
		                        <input type="hidden" name="cartId" value="${cartItem.cartId}">
		                        <input type="hidden" name="proId" value="${cartItem.proId}">
		                        <input type="hidden" name="unitPrice" id="unitPrice-${cartItem.cartId}" value="${cartItem.unitPrice}">
		                        <input type="hidden" name="deliveryFee" id="deliveryFee-${cartItem.cartId}" value="${cartItem.deliveryFee}">
		                        <input type="hidden" name="purchaseQuantity" id="purchaseQuantity-${cartItem.cartId}" value="${cartItem.selectedQuantity}">
		                        <input type="hidden" name="totalPrice" id="totalPrice-${cartItem.cartId}" value="${(cartItem.unitPrice * cartItem.selectedQuantity) + cartItem.deliveryFee}">
		                        <button type="submit" class="button checkout-button">결제</button>
		                    </form>
		                </div>
		            </div>
		            
		            <p>상품 번호: ${cartItem.proId}</p>
		
		            <!-- ✅ 단가 표시 -->
		            <div class="price-info">
		                <span>단가:</span> 
		                <strong><span id="unitPriceDisplay-${cartItem.cartId}">${cartItem.unitPrice}</span> 원</strong>
		            </div>
		
		            <!-- ✅ 수량 변경 -->
		            <div class="price-info">
		                <span>수량:</span>
		                <input type="number" id="quantity-${cartItem.cartId}" class="input-box"
		                       value="${cartItem.selectedQuantity}" min="1"
		                       oninput="updateTotal(${cartItem.cartId})">
		            </div>
		
		            <!-- ✅ 상품 가격 -->
		            <div class="price-info">
		                <span>상품 가격:</span>
		                <strong><span id="productTotal-${cartItem.cartId}">${cartItem.unitPrice * cartItem.selectedQuantity}</span> 원</strong>
		            </div>
		
		            <!-- ✅ 배송비 -->
		            <div class="price-info">
		                <span>배송비:</span>
		                <strong><span id="deliveryFeeDisplay-${cartItem.cartId}">${cartItem.deliveryFee}</span> 원</strong>
		            </div>
		
		            <!-- ✅ 총 결제액 -->
		            <div class="price-info total-price">
		                <span>총 결제액:</span>
		                <strong><span id="totalPriceDisplay-${cartItem.cartId}">${(cartItem.unitPrice * cartItem.selectedQuantity) + cartItem.deliveryFee}</span> 원</strong>
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
</div>

<script>
    function updateTotal(cartId) {
        console.log("✅ updateTotal 호출 - cartId:", cartId);

        let quantityInput = document.getElementById(`quantity-\${cartId}`);
        let unitPrice = parseInt(document.getElementById(`unitPrice-\${cartId}`).value);
        let deliveryFee = parseInt(document.getElementById(`deliveryFee-\${cartId}`).value);
        let productTotalDisplay = document.getElementById(`productTotal-\${cartId}`);
        let totalPriceDisplay = document.getElementById(`totalPriceDisplay-\${cartId}`);

        let quantity = parseInt(quantityInput.value);
        let productTotal = unitPrice * quantity;
        let totalPrice = productTotal + deliveryFee;

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
                }
            })
            .catch(error => console.error("🚨 삭제 에러:", error));
    }
</script>

</body>
</html>

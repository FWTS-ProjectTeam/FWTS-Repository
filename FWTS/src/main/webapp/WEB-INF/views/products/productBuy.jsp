<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>생화24 - 상품 상세</title>
<link rel="stylesheet" href="/resources/css/common.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<style>
.body-container {
	display: flex;
	flex-direction: column;
	width: 90%;
	margin: 0 auto;
	padding-top: 30px;
}

.pro-info1 {
	display: flex;
	flex-direction: row;
	width: 100%;
	margin: 0 auto;
}

.img-container {
	width: 30%;
	height: 300px;
	display: flex;
	justify-content: center;
	align-items: center;
	background-color: #f0f0f0; /* 이미지가 없을 때 '이미지가 없습니다' 텍스트 표시용 */
	overflow: hidden;
	position: relative; /* :before를 중앙에 배치하려면 필요 */
	margin-top: 30px;
}

.img-container:before {
	content: "이미지가\A없습니다";
	color: #666;
	font-size: 16px;
	font-weight: bold;
	position: absolute; /* 부모 중앙에 텍스트 배치 */
	text-align: center;
	margin-top: 30px;
	white-space: pre;
	z-index: 1;
}

img {
	width: 100%;
	height: 100%;
	object-fit: cover; /* 이미지 비율 유지하며 크기에 맞게 자르기 */
	z-index: 2;
}

.pro-detail {
	display: flex;
	flex-direction: column;
	justify-content: space-between;
	width: 70%;
	height: 70%;
	margin: 0px 0px 0px 40px;
}

.pro-detail1 {
	display: flex;
	flex-direction: row;
	justify-content: space-between;
	align-items: center;
	width: 100%;
	margin: 0px 300px 0px 0px;
}

.pro-detail1 a {
	color: var(--main4);
	font-size: 16px;
	font-weight: bold;
	text-decoration: none;
}

.pro-detail2 {
	display: flex;
	flex-direction: column;
	width: 100%;
}

.status {
	display: inline;
	padding: 5px 10px;
	border: 2px solid var(--main4);
	border-radius: 12px;
	color: var(--main4);
	font-weight: bold;
	text-align: center;
}

.status.available {
	background-color: var(--main5);
}

.status.sold-out {
	background-color: transparent; /* 배경색 없앰 */
	color: #999; /* 텍스트 색상 변경 */
}

.pro-info2 {
	width: 100%;
	margin-top: 50px;
	margin-bottom: 100px;
}

.description-title {
	background-color: var(--main5);
	padding: 20px 10px;
	color: black;
	font-weight: bold;
}

.button-container {
	width: 100%;
	display: flex;
	justify-content: center; /* 버튼 중앙 정렬 */
	gap: 20px; /* 버튼 간격을 설정 */
	margin: 10px 0;
}

.button-container .btn1 {
	width: 100%;
	background-color: var(--main3);
	color: #fff;
	padding: 10px 40px;
	border: 1px solid var(--main3);
	border-radius: 5px;
	cursor: pointer;
}

.button-container .btn2 {
	width: 100%;
	background-color: #fff;
	color: var(--main4);
	padding: 10px 40px;
	border: 1px solid var(--main4);
	border-radius: 5px;
	cursor: pointer;
}

.button-container .btn1:hover {
	width: 100%;
	background-color: var(--main4);
	color: #fff;
	padding: 10px 40px;
	border: 1px solid var(--main4);
	border-radius: 5px;
	cursor: pointer;
}

.button-container .btn2:hover {
	width: 100%;
	background-color: var(--main4);
	color: #fff;
	padding: 10px 40px;
	border: 1px solid var(--main4);
	border-radius: 5px;
	cursor: pointer;
}

.highlight-line {
	border: 0;
	height: 3px;
	background-color: var(--main4);
	margin: 0 0; /* 위아래 여백 */
}

.solid-line {
	border: 0;
	height: 1px;
	background-color: #ccc;
	margin: 0 0; /* 위아래 여백 */
}

.sum {
	display: flex;
	flex-direction: row;
	justify-content: space-between;
	width: 100%;
}

.sum>div:last-child {
	text-align: right; /* 오른쪽 정렬 */
}
</style>

</head>
<body>
	<div class="container">
		<!-- 공통 -->
		<%@ include file="/WEB-INF/views/common/header.jsp"%>
		<div class="body-container">
			<h1>상품 상세</h1>
			<div class="pro-info1">
				<div class="img-container">
					<img src="${product.imgPath}">
				</div>
				<div class="pro-detail">
					<div class="pro-detail1">
						<a href="/products/shop/${product.sellerId}">${userDetails.companyName}</a>
						<p>상품 ID: ${product.proId}</p>
					</div>
					<div class="pro-detail2">
						<h3>${product.proName}</h3>
						<hr class="highlight-line">
						<p>단일가격: ${product.unitPrice}원</p>
						<hr class="solid-line">
						<p>구매 가능 수량: ${product.minPossible}~${product.maxPossible}개</p>
						<hr class="solid-line">
						<div>
							<div>
								<p>구매 수량:</p>
							</div>
							<div class="sum">
								<div>
									<button type="button" id="decrease"
										onclick="updateQuantity(false)">-</button>
									<input type="number" id="quantity" name="quantity"
										value="${product.minPossible}" min="${product.minPossible}"
										max="${product.inventory}" onchange="validateQuantity()">
									<button type="button" id="increase"
										onclick="updateQuantity(true)">+</button>
								</div>
								<div>
									<p>
										상품금액: <span id="Price">${product.unitPrice}</span>원
									</p>
									<p>배송비: ${product.deliveryFee}원</p>
									<p>
										총 주문 금액: <span id="totalPrice">${product.unitPrice + product.deliveryFee}</span>원
									</p>
								</div>
							</div>
						</div>
					</div>
					<hr class="solid-line">
					<!-- 비로그인 또는 소매업자 -->
					<sec:authorize
						access="!(hasRole('ROLE_WHOLESALER') or hasRole('ROLE_ADMIN'))">
						<div class="button-container">
							<button class="btn1" onclick="addToCart(${product.proId})">장바구니</button>
							<button class="btn2" onclick="orderNow(${product.proId})">바로구매</button>
						</div>
					</sec:authorize>
				</div>
			</div>
			<div class="pro-info2">
				<p class="description-title">상품 설명</p>
				<p>
					<c:choose>
						<c:when test="${empty product.description}">
                		등록된 상품 설명이 없습니다.
            			</c:when>
						<c:otherwise>
							<pre>${product.description}</pre>
						</c:otherwise>
					</c:choose>
				</p>
			</div>
		</div>
		<%@ include file="/WEB-INF/views/common/footer.jsp"%>
	</div>

	<script>
		//페이지 로드 시 실행
		window.onload = function () {
			<c:if test="${not empty message}">
				alert("${message}");
			</c:if>
		};
	
		function addToCart(proId) {
	        var quantity = document.getElementById('quantity').value;
	        location.href = "/buyer/addToCart?proId=" + proId + "&quantity=" + quantity;
	    }
	    
	    function orderNow(proId) {
	    	var quantity = document.getElementById('quantity').value;
	        location.href = "/buyer/orderNow?proId=" + proId + "&quantity=" + quantity;
	    }
	
        const maxStock = ${product.inventory};
        const unitPrice = ${product.unitPrice};
        const deliveryFee = ${product.deliveryFee};
        const minPossible = ${product.minPossible};
        const maxPossible = ${product.maxPossible};
		// 구매 수량 제한 (버튼으로 수량 선택 시)
        function updateQuantity(increase) {
            const quantityInput = document.getElementById('quantity');
            let currentQuantity = parseInt(quantityInput.value);
            if (increase) {
                if (currentQuantity < maxPossible) {
                    quantityInput.value = currentQuantity + 1;
                } else {
                    alert(`1인당 ${product.maxPossible}개 이상 구매하실 수 없습니다.`);
                }
            } else {
                if (currentQuantity > minPossible) {
                    quantityInput.value = currentQuantity - 1;
                } else {
                    alert(`1인당 ${product.minPossible}개 이상 구매 시 주문 가능합니다.`);
                }
            }
            updateTotal();
        }
		// 구매 수량 제한 (직접 입력 시)
        function validateQuantity() {
            const quantityInput = document.getElementById('quantity');
            let currentQuantity = parseInt(quantityInput.value);
            if (currentQuantity < minPossible) {
                alert(`1인당 ${product.minPossible}개 이상 구매 시 주문 가능합니다.`);
                quantityInput.value = minPossible;
            } else if (currentQuantity > maxPossible) {
                alert(`1인당 ${product.maxPossible}개 이상 구매하실 수 없습니다.`);
                quantityInput.value = maxPossible;
            }
            updateTotal();
        }

		// 총 액 계산
        function updateTotal() {
            const quantityInput = document.getElementById('quantity');
            let currentQuantity = parseInt(quantityInput.value);
            const Price = (unitPrice * currentQuantity);
            const totalPrice = (unitPrice * currentQuantity) + deliveryFee;
            document.getElementById('Price').textContent = Price;
            document.getElementById('totalPrice').textContent = totalPrice;
        }

        updateTotal();
    </script>
</body>
</html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>상품 주문</title>
<link rel="stylesheet" href="/resources/css/common.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<style>
    .order-container {
    	width: 100%;
        max-width: 600px;
        margin: 20px auto;
        padding: 20px;
        border: 1px solid #ddd;
        border-radius: 10px;
        background-color: #fff;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }
    
    h1 {
        font-size: 24px;
        text-align: center;
    }
    
    .info-section {
        margin-bottom: 15px;
        padding: 14px;
        border: 1px solid #ccc;
        border-radius: 5px;
        background-color: #f9f9f9;
    }
    .info-section h2 {
        font-size: 18px;
    }
    
    .submit-button {
        width: 100%;
        margin: 10px 0 0 0;
        font-size: 18px;
    }
    .submit-button:hover {
        background-color: #ff6080;
    }
    .submit-button i {
    	margin-right: 10px;
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
    
    hr {
	  	border: 0;
	  	height: 1px;
	  	background-color: #ccc;
	  	margin: 10px 0;
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
    .input-group button {
        width: 22%;
        font-size: 14px;
        flex-direction: column;
    }
    .input-group input {
        width: 100%;
        height: 40px;
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
    	width: 24%;
    }
    .input-field {
	    display: flex;
	    align-items: center;
	    gap: 10px;
	    margin-bottom: 10px;
	}
</style>
</head>
<body>
<div class="container">
	<!-- 공통 -->
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
    
    <div class="body-container">
		<div class="order-container">
		    <h1>📦 상품 주문</h1>
		
		    <!-- 주문 완료 메시지 -->
		    <c:if test="${not empty orderSuccessMessage}">
		        <div id="orderSuccessMessage" class="success-message">${orderSuccessMessage}</div>
		    </c:if>
		
		    <!-- 구매자 정보 -->
		    <div class="info-section">
		        <h2>구매자 정보</h2>
		        <p><strong>대표자명:</strong> ${orderNow.ceoName}</p>
		        <p><strong>연락처:</strong> ${orderNow.phoneNum}</p>
		        
		        <p><strong>배송지:</strong> 
		            <c:choose>
		                <c:when test="${not empty orderNow.address}">
		                    (${orderNow.postalCode}) ${orderNow.address}<c:if test="${not empty orderNow.detailAddress}">, ${orderNow.detailAddress}</c:if>
		                </c:when>
		                <c:otherwise>
		                    <span style="color: red;">배송지 정보 없음</span>
		                </c:otherwise>
		            </c:choose>
		        </p>
		
				<hr>
		
		        <!-- 주소 검색 (기존 배송지 유지 또는 새로 입력 가능) -->
		        <h2>배송지 변경</h2>
		        <div class="input-group">
			        <label for="postal-code">우편번호</label>
	               	<div class="input-field">
		                <input id="postal-code" name="postalCode" value="${orderNow.postalCode}" readonly>
		                <button type="button" class="button" onclick="searchAddress()">주소 찾기</button>
		            </div>
	          
		            <label for="address">주소</label>
		           	<div class="input-field">
		            	<input id="address" name="address" value="${orderNow.address}" readonly>
		            	<input id="detail-address" name="detailAddress" value="${orderNow.detailAddress}" maxlength="30">
	           		</div>
           		</div>
		    </div>
		
		    <!-- 주문 상품 정보 -->
		    <div class="info-section">
		        <h2>상품 정보</h2>
		        <p><strong>상품 ID:</strong> ${orderNow.proId}</p>
		        <p><strong>상품명:</strong> ${orderNow.proName}</p>
		        <p>
		        	<strong>상품 단가:</strong>
		        	<fmt:formatNumber value="${orderNow.unitPrice}" type="number" /> 원
		        </p>
		        <p>
		        	<strong>배송비:</strong>
		        	<fmt:formatNumber value="${orderNow.deliveryFee}" type="number" /> 원
		        </p>
		        <p><strong>주문 수량:</strong> ${orderNow.purchaseQuantity} 개</p>
		        <p>
		        	<strong>총 결제액:</strong>
		        	<fmt:formatNumber value="${orderNow.purchaseQuantity * orderNow.unitPrice + orderNow.deliveryFee}" type="number" /> 원
		        </p>
		    </div>
		
		    <!-- 판매자 계좌 정보 -->
		    <div class="info-section">
		        <h2>판매자 정보</h2>
		        <p><strong>판매 업체:</strong> ${orderNow.companyName}</p>
		        <p><strong>계좌 이름:</strong> ${orderNow.bankName}</p>
		        <p><strong>입금 계좌:</strong> ${orderNow.accountNum}</p>
		    </div>
		
		    <!-- 주문 확정 버튼 (맨 아래로 이동) -->
		    <form action="/buyer/placeOrder" method="post">
				<!-- cartId 값이 없으면 기본값 0으로 설정 -->
				<input type="hidden" name="cartId" value="${orderNow.cartId != null ? orderNow.cartId : 0}">
		        <input type="hidden" name="proId" value="${orderNow.proId}">
		        <input type="hidden" name="purchaseQuantity" value="${orderNow.purchaseQuantity}">
		        <input type="hidden" name="totalPrice" value="${orderNow.purchaseQuantity * orderNow.unitPrice + orderNow.deliveryFee}">
		        <input type="hidden" name="postalCode" id="hiddenPostalCode" value="${orderNow.postalCode}">
		        <input type="hidden" name="address" id="hiddenAddress" value="${orderNow.address}">
		        <input type="hidden" name="detailAddress" id="hiddenDetailAddress"  value="${orderNow.detailAddress}">
		        
		        <button type="submit" class="submit-button button">
		        	<i class="fa-solid fa-check"></i>주문 확정
		        </button>
		    </form>
		</div>
	</div>
	
	<!-- 푸터 -->
    <%@ include file="/WEB-INF/views/common/footer.jsp"%>
</div>
<script>
	//카카오 우편번호 검색 API를 이용한 주소 검색
	function searchAddress() {
	    new daum.Postcode({
	        oncomplete: function(data) {
	            document.getElementById("postal-code").value = data.zonecode; // 우편번호 입력
	            document.getElementById("address").value = data.roadAddress; // 도로명 주소 입력
	            document.getElementById("detail-address").focus();
	            
	         	// 숨겨진 input 값도 함께 업데이트 (폼 전송 시 사용)
                document.getElementById("hiddenPostalCode").value = data.zonecode;
                document.getElementById("hiddenAddress").value = data.roadAddress;
	        }
	    }).open();
	}

    // 상세 주소 입력 시 hidden input에 반영
    document.getElementById("detail-address").addEventListener("input", function() {
        document.getElementById("hiddenDetailAddress").value = this.value;
    });

    // 폼 제출 시 hidden input 값 동기화
    document.querySelector("form").addEventListener("submit", function() {
        document.getElementById("hiddenPostalCode").value = document.getElementById("postalCode").value;
        document.getElementById("hiddenAddress").value = document.getElementById("address").value;
        document.getElementById("hiddenDetailAddress").value = document.getElementById("detailAddress").value;
    });
</script>
</body>
</html>
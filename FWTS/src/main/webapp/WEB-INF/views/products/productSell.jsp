<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>생화24 - 판매자의 상품 상세</title>
<link rel="stylesheet" href="/resources/css/common.css">
<link rel="stylesheet" href="/resources/css/sidebar.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<style>
.sidebar .product-active {
	background-color: #ff7f9d;
	color: #fff;
	border-radius: 5px;
}

.table-container {
	width: 100%;
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
}

.img-container:before {
	content: "이미지가 없습니다";
	color: #666;
	font-size: 16px;
	font-weight: bold;
	position: absolute; /* 부모 중앙에 텍스트 배치 */
	text-align: center;
	width: 30%;
	height: 300px;
	display: flex;
	justify-content: center;
	align-items: center;
	margin-top: 30px;
}

img {
	width: 100%;
	height: 100%;
	object-fit: cover; /* 이미지 비율 유지하며 크기에 맞게 자르기 */
}

.detail-container {
	display: flex;
	flex-direction: column;
	justify-content: space-between;
	width: 70%;
	height: 70%;
	margin: 0px 0px 0px 40px;
}

.detail1 {
	display: flex;
	flex-direction: row;
	justify-content: space-between;
	width: 100%;
	border-bottom: 3px solid var(--main4);
}

.detail2 {
	display: flex;
	flex-direction: row;
	justify-content: space-between;
	width: 70%;
}

.status {
	width: 80px;
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
	background-color: var(--main4);
	padding: 5px 10px;
	color: white; /* 텍스트 색상 */
	font-weight: bold;
}

.button-container {
	width: 100%;
	display: flex;
	justify-content: center; /* 버튼 중앙 정렬 */
	gap: 20px; /* 버튼 간격을 설정 */
	margin: 50px 0;
}

.button-container .btn1 {
	background-color: var(--main3);
	color: #fff;
	padding: 10px 40px;
	border: 1px solid var(--main3);
	border-radius: 5px;
	cursor: pointer;
}

.button-container .btn2 {
	background-color: #fff;
	color: var(--main4);
	padding: 10px 40px;
	border: 1px solid var(--main4);
	border-radius: 5px;
	cursor: pointer;
}

.button-container .btn1:hover, .button-container .btn2:hover {
	background-color: var(--main4);
	color: #fff;
	padding: 10px 40px;
	border: 1px solid var(--main4);
	border-radius: 5px;
	cursor: pointer;
}

.tabs {
	display: flex;
	border-bottom: 1px solid var(--main4);
}

.tab-button {
	background-color: white;
	padding: 10px 20px;
	border: none;
	cursor: pointer;
	flex: 1;
	text-align: center;
	font-size: 16px;
	font-weight: bold;
	border-bottom: 1px solid var(--main4);
	transition: background-color 0.3s ease-in-out, color 0.3s ease-in-out;
}

/* hover 상태 */
.tab-button:hover {
	background-color: var(--main4);
	color: white
}

/* 선택된 탭 */
.tab-button.active {
	background-color: var(--main4);
	color: white
}

.tab-content {
	display: none;
}

.tab-content.active {
	display: block;
}

/* 기타 스타일들 */
table {
	width: 100%;
	border-collapse: collapse;
}

table th, table td {
	padding: 8px;
	border: 1px solid #ccc;
	text-align: left;
}
</style>

</head>
<body>
	<div class="container">
		<!-- 공통 -->
		<%@ include file="/WEB-INF/views/common/header.jsp"%>
		<div class="body-container">
			<!-- 사이드바 -->
			<%@ include file="/WEB-INF/views/common/mypage-sidebar.jsp"%>
			<div class="table-container">
				<h1>상품 관리</h1>
				<div class="pro-info1">
					<div class="img-container">
						<img src="${product.imgPath}">
					</div>
					<div class="detail-container">
						<div class="detail1">
							<h3>${product.proName}</h3>
							<p>상품 ID: ${product.proId}</p>
						</div>
						<p
							class="status
							<c:choose>
            					<c:when test="${not product.isSales()}"> sold-out</c:when>
            					<c:otherwise> available</c:otherwise>
        					</c:choose>">
							<c:choose>
								<c:when test="${not product.isSales()}">판매 중지</c:when>
								<c:otherwise>판매 중</c:otherwise>
							</c:choose>
						</p>
						<div class="detail2">
							<div>
								<p>최소 구매 가능 수량: ${product.minPossible}</p>
								<p>최대 구매 가능 수량: ${product.maxPossible}</p>
								<p>재고: ${product.inventory}</p>
								<p>가격: ${product.unitPrice}</p>
							</div>
							<div>
								<p>
									카테고리:
									<c:choose>
										<c:when test="${product.categoryId == '1'}">절화</c:when>
										<c:when test="${product.categoryId == '2'}">관엽</c:when>
										<c:when test="${product.categoryId == '3'}">난</c:when>
										<c:when test="${product.categoryId == '4'}">기타</c:when>
									</c:choose>
								</p>
								<p>
									등록일:
									<fmt:formatDate value="${product.formattedDate}"
										pattern="yyyy-MM-dd" />
								</p>
								<p>누적 판매량: ${product.totalSales}</p>
							</div>
						</div>
					</div>
				</div>
				<div class="pro-info2">
					<div class="tabs">
						<button class="tab-button active" onclick="showTab('description')">상품
							설명</button>
						<button class="tab-button" onclick="showTab('orderHistory')">거래
							내역</button>
					</div>

					<!-- 상품 설명 -->
					<div id="description" class="tab-content active">
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

					<!-- 거래 내역 -->
					<div id="orderHistory" class="tab-content">
						<h3>최근 거래 내역</h3>

					</div>
				</div>

				<div class="button-container">
					<button class="btn1"
						onclick="location.href='/products/edit/${product.proId}/${product.sellerId}'">수정</button>
					<button class="btn2"
						onclick="confirmDelete(${product.proId}, '${product.proName}', '${product.sellerId}')">삭제</button>
				</div>
			</div>
		</div>
		<%@ include file="/WEB-INF/views/common/footer.jsp"%>
	</div>
	<script>
      // 탭 전환 기능
      function showTab(tabName) {
       	const tabs = document.querySelectorAll('.tab-content');
    	const buttons = document.querySelectorAll('.tab-button');

    	// 모든 탭 콘텐츠 숨기기
    	tabs.forEach(tab => tab.classList.remove('active'));
    	// 모든 버튼에서 active 클래스 제거
    	buttons.forEach(button => button.classList.remove('active'));

    	// 클릭한 탭만 활성화
    	document.getElementById(tabName).classList.add('active');

    	// 해당하는 버튼 찾기
    	buttons.forEach(button => {
        	if (button.textContent.trim() === (tabName === 'description' ? '상품 설명' : '거래 내역')) {
            	button.classList.add('active');
        	}
    	});
	}
      // 상품 삭제
      function confirmDelete(id, proName, sellerId) {
    	const isConfirmed = confirm(`${product.proName} 상품을 삭제하시겠습니까?`);
    
    	if (isConfirmed) {
        	fetch(`/products/delete/${product.proId}`, { 
            	method: 'PUT'
        	})
        	.then(response => {
            	if (!response.ok) {
                	throw new Error("삭제에 실패했습니다.");
            	}
            	return response.json();
        	})
        	.then(data => {
            	alert(`${product.proName} 상품이 삭제되었습니다.`);
            	location.href = `/products/shopM/${product.sellerId}`; // 삭제 후 해당 판매자의 페이지로 이동
        	})
        	.catch(error => {
            	console.error("삭제 중 오류 발생:", error);
            	alert("삭제에 실패했습니다.");
        	});
    	}
	}

// 페이지 로드 시 기본 탭 설정
window.onload = function () {
    showTab('description');
};
    </script>
</body>
</html>

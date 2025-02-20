<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>생화24-샵의 상품 리스트</title>
<link rel="stylesheet" href="/resources/css/common.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<style>
.array-container {
	display: flex;
	justify-content: space-between;
	border-bottom: 1px solid #ccc;
	margin-bottom: 20px;
	align-items: center;
}

.array-notice {
	font-size: 20px;
	font-weight: bold;
	text-decoration: none;
	color: #333;
}

.body-container {
	display: flex;
	margin: 20px 20px 0px 20px;
}

.sidebar {
	display:flex;
	width: 220px;
	padding: 10px 0 10px 0;
	border: 1px solid #ccc;
	background-color: #fff;
	border-radius: 10px;
	margin-right: 20px;
    flex-direction: column; /* 세로 정렬 */
    align-items: center; /* 가운데 정렬 */
    text-align: center; /* 텍스트 가운데 정렬 */
}

.sidebar h2 {
	font-size: 18px;
	margin-bottom: 10px;
}

.sidebar a {
	display: block;
	padding: 10px;
	text-decoration: none;
	color: #333;
	cursor: pointer;
}

.sidebar p {
	display: block;
	font-size: 14px;
	margin-bottom: 10px;
}

.sidebar-img {
	width: 100px; /* 이미지 크기 */
	height: 100px;
	border-radius: 50%; /* 동그랗게 만들기 */
	object-fit: cover; /* 이미지 비율 유지하면서 잘 맞추기 */
	margin-bottom: 10px; /* 제목과 간격 */
	border: 2px solid #ccc; /* 테두리 추가 */
}

.table-container {
	width: 100%;
	margin: 20px 10px 0px 10px;
}

.product-list {
	display: grid;
	grid-template-columns: repeat(4, 1fr); /* 4개씩 가로로 나열 */
	grid-gap: 20px; /* 각 상품 간격 */
}

.product-item {
	border: 1px solid #ccc;
	border-radius: 10px;
	padding: 10px;
	box-sizing: border-box;
	cursor: pointer;
	transition: transform 0.3s ease-in-out;
}

.product-item:hover {
	transform: scale(1.05);
	border: 1px solid var(--main4);
}

.product-image {
	width: 200px;
	height: 200px;
	border-radius: 5px;
	background-color: #f2f2f2; /* 기본 배경 색상 */
	display: block;
	object-fit: cover; /* 이미지를 덮어 씌우는 방식 */
}

.product-image[alt]:empty {
	background-color: #f2f2f2; /* 이미지가 없을 때 배경색 */
	color: #999; /* 텍스트 색상 */
	display: flex;
	justify-content: center;
	align-items: center;
	font-size: 14px;
}

.product-details {
	display: flex;
	flex-direction: row;
	justify-content: space-between;
	align-items: center;
	padding-top:10px;
}

.pagination {
	text-align: center;
	margin: 100px 0px 50px 0px;
}

.pagination span {
	background-color: #ff7f9d;
	padding: 5px 10px;
	border-radius: 5px;
	color: #fff;
}

.header-right a {
	font-size: 13px;
	text-decoration: none;
	color: #333;
	margin-left: 10px;
}

.sort-option.active {
	font-weight: bold;
}

.product-list, .sidebar a {
	list-style-type: none; /* 목록 앞의 점을 없앰 */
	padding-left: 0; /* 기본적으로 나오는 패딩도 없애기 */
}
</style>
</head>
<body>
	<div class="container">
		<!-- 공통 -->
		<%@ include file="/WEB-INF/views/common/header.jsp"%>
		<div class="body-container">
			<div class="sidebar">
				<img src="/resources/smarteditor/img/userimg.jpg" class="sidebar-img">
				<h2>${userDetails.ceoName} 대표님</h2>
				<p>${userDetails.phoneNum}</p>
			</div>
			<div class="table-container">
				<div class="array-container">
					<div class="array-notice">
						<p>
							<span style="color: var(--main4); font-size: 30px;">${userDetails.companyName}</span>
						</p>
					</div>
				</div>

				<ul class="product-list">
				<c:choose>
					<c:when test="${empty products}">
						<li class="no-products">"${category == '0' ? 'ALL' : (category == '1' ? '절화' : (category == '2' ? '난' : (category == '3' ? '관엽' : '기타')))}"에
							해당하는 상품이 없습니다.</li>
					</c:when>
					<c:otherwise>
						<c:forEach var="product" items="${products}">
							<li class="product-item" data-category="${product.categoryId}"
								onclick="window.location='/products/buy/${product.proId}/${product.sellerId}'">
								<h3>
									<c:choose>
										<c:when test="${fn:length(product.proName) > 15}">
                                ${fn:substring(product.proName, 0, 15)}...
                            </c:when>
										<c:otherwise>
                                ${product.proName}
                            </c:otherwise>
									</c:choose>
								</h3>
								<img src="${product.imgPath}" alt="이미지가 없습니다"
								class="product-image">
								<span style="font-size:12px;">
									<c:choose>
										<c:when test="${fn:length(product.description) > 25}">
                                ${fn:substring(product.description, 0, 25)}...
                            </c:when>
										<c:otherwise>
                                ${product.description}
                            </c:otherwise>
									</c:choose>
								</span>
								<div class="product-details">
									<span style="font-weight: bold; color:var(--main4);">${product.unitPrice}원</span>
									<span style="color:#999; font-size:12px;">배송비: ${product.deliveryFee}원</span>
								</div>
							</li>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</ul>
				<!-- 페이지네이션 -->
				<div class="pagination">
					<c:choose>
						<c:when test="${count > 0}">
							<!-- 이전 페이지 -->
							<c:choose>
								<c:when test="${currentPage > 1}">
									<a href="?page=${currentPage - 1}&sort=${sort}">◀</a>
								</c:when>
								<c:otherwise>
									<a>◀</a>
								</c:otherwise>
							</c:choose>

							<!-- 현재 페이지 / 전체 페이지 -->
							<span>${currentPage} / ${totalPages}</span>

							<!-- 다음 페이지 -->
							<c:choose>
								<c:when test="${currentPage < totalPages}">
									<a href="?page=${currentPage + 1}&sort=${sort}">▶</a>
								</c:when>
								<c:otherwise>
									<a>▶</a>
								</c:otherwise>
							</c:choose>
						</c:when>
						<c:otherwise>
							<p>등록된 상품이 없습니다.</p>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>
		<%@ include file="/WEB-INF/views/common/footer.jsp"%>
	</div>
</body>
</html>

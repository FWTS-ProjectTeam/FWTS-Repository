<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>내 상품 관리</title>
<link rel="stylesheet" href="/resources/css/common.css">
<link rel="stylesheet" href="/resources/css/sidebar.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<style>
.body-container {
	display: flex;
	margin: 20px 20px 0px 20px;
}
.sidebar .product-active {
    font-weight: 600;
    background-color: #ff7f9d;
    color: #fff;
    border-radius: 5px;
}

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
}

.pagination {
	text-align: center;
	margin:100px 0px 50px 0px;
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

.sidebar a {
	display: block; /* 링크를 블록 요소로 만들어서 클릭 영역 확장 */
	text-decoration: none;
	color: #333;
	cursor: pointer;
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
			<div class="table-container">
				<div class="array-container">
					<div class="array-notice">
						<p>
							<span style="color: var(--main4); font-size: 30px;">A플라워샵(수정필요)</span> 의 판매 상품 목록
						</p>
					</div>
				</div>

				<ul class="product-list">
					<c:forEach var="product" items="${products}">
						<li class="product-item" data-category="${product.categoryId}"
							onclick="window.location='/products/sell/${product.proId}'">
							<p class="status
							<c:choose>
            					<c:when test="${not product.isSales()}"> sold-out</c:when>
            					<c:otherwise> available</c:otherwise>
        					</c:choose>">
        					<c:choose>
            					<c:when test="${not product.isSales()}">판매 중지</c:when>
            				<c:otherwise>판매 중</c:otherwise>
        					</c:choose>
    					</p>
							<img src="${product.imgPath}" alt="이미지가 없습니다" class="product-image">
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
							<div class="product-details">
								<p>${product.unitPrice}원</p>
								<p>등록일: <fmt:formatDate value="${product.formattedDate}" pattern="yyyy-MM-dd" /></p>

							</div>
							<div>
							<p>누적 판매량: ${product.totalSales}</p>
							</div>
						</li>
					</c:forEach>
				</ul>
            
			<!-- 페이지네이션 -->
			<div class="pagination">
			    <c:choose>
			        <c:when test="${count > 0}">
			            <c:set var="queryString">
						    <c:if test="${category == 'all' || category == 'title' || category == 'content'}">
						        <c:set var="queryString" value="&category=${fn:escapeXml(category)}&keyword=${fn:escapeXml(keyword)}" />
						    </c:if>
						</c:set>
			
			            <!-- 이전 페이지 버튼 -->
			            <c:choose>
			                <c:when test="${currentPage > 1}">
			                    <a href="${sellerId}?page=${currentPage - 1}${queryString}">◀</a>
			                </c:when>
			                <c:otherwise>
			                    <a>◀</a>
			                </c:otherwise>
			            </c:choose>
			
			            <!-- 현재 페이지 / 전체 페이지 표시 -->
			            <span>${currentPage} / ${totalPages}</span>
			
			            <!-- 다음 페이지 버튼 -->
			            <c:choose>
			                <c:when test="${currentPage < totalPages}">
			                    <a href="${sellerId}?page=${currentPage + 1}${queryString}">▶</a>
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
</div>
	
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>생화24 - 상품 리스트</title>
<link rel="stylesheet" href="/resources/css/common.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<style>
.body-container {
	display: flex;
	flex-direction: column;
	width:90%;
    margin: 0 auto; /* 중앙 정렬 */
}

.array-container {
	display: flex;
	flex-direction: row;
	width:100%;
	justify-content: space-between;
	border-bottom: 1px solid #ccc;
	margin-top: 30px;
	margin-bottom: 20px;
	align-items: center;
}

.array-notice {
	font-size: 20px;
	font-weight: bold;
	text-decoration: none;
	color: #333;
}

.product-list {
	display: grid;
	grid-template-columns: repeat(5, 1fr); /* 4개씩 가로로 나열 */
	grid-gap: 20px; /* 각 상품 간격 */
	justify-content: center;
	list-style-type: none; /* 목록 앞의 점을 없앰 */
	padding-left: 0; /* 기본적으로 나오는 패딩도 없애기 */
	width:100%;
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
	border: 1px solid var(--main4);
	transform: scale(1.05);
}

.no-products {
	width: 100%;
	text-align: center;
	white-space: nowrap;
	display: inline-block;
}

.product-image {
   width: 100%; /* 부모 크기에 맞게 자동 조정 */
   height: 200px; /* 비율 유지 */
   border-radius: 5px;
   background-color: #f2f2f2; 
   display: block;
   object-fit: cover;
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

.ftws-info{
}
.solid-line {
        border: 0;
        height: 1px;
        background-color: #ccc;
        margin: 0 0;  /* 위아래 여백 */
    }
</style>
</head>
<body>
	<div class="container">
		<!-- 공통 -->
		<%@ include file="/WEB-INF/views/common/header.jsp"%>
		<div class="body-container">
			<div class="array-container">
				<div class="array-notice">
					<p>
						<span id="category-title" style="color: var(--main4); font-size: 30px;">
							<c:choose>
								<c:when test="${category == '0'}">ALL</c:when>
								<c:when test="${category == '1'}">절화</c:when>
								<c:when test="${category == '2'}">관엽</c:when>
								<c:when test="${category == '3'}">난</c:when>
								<c:when test="${category == '4'}">기타</c:when>
								<c:otherwise>ALL</c:otherwise>
							</c:choose>
						</span> 에 대한 상품
					</p>
				</div>
				<div class="header-right">
					<a
						href="?page=${currentPage}&category=${category}&keyword=${keyword}&sort=default"
						class="sort-option ${sort == 'default' ? 'active' : ''}">인기순</a> <a
						href="?page=${currentPage}&category=${category}&keyword=${keyword}&sort=price_high"
						class="sort-option ${sort == 'price_high' ? 'active' : ''}">가격높은순</a>
					<a
						href="?page=${currentPage}&category=${category}&keyword=${keyword}&sort=price_low"
						class="sort-option ${sort == 'price_low' ? 'active' : ''}">가격낮은순</a>
				</div>
			</div>

			<ul class="product-list">
				<c:choose>
					<c:when test="${empty products}">
						<li class="no-products">"${category == '0' ? 'ALL' : (category == '1' ? '절화' : (category == '2' ? '관엽' : (category == '3' ? '난' : '기타')))}"에
							해당하는 상품이 없습니다.</li>
					</c:when>
					<c:otherwise>
						<c:forEach var="product" items="${products}">
							<li class="product-item" data-category="${product.categoryId}"
								onclick="window.location='/products/buy/${product.proId}'">
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
								<img src="${product.imgPath}" alt="이미지가 없습니다" class="product-image">
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

			<!-- 페이징 처리 -->
          <div class="pagination">
             <c:set var="queryString" value="" />
               <c:if test="${category == '1' || category == '2' || category == '3' || category == '4'}">
                   <c:set var="queryString" value="${queryString}&category=${fn:escapeXml(category)}&keyword=${fn:escapeXml(keyword)}" />
               </c:if>
          
              <c:if test="${currentPage > 1}">
                  <a href="?page=${currentPage - 1}${queryString}">« 이전</a>
              </c:if>
              
              <c:set var="startPage" value="${currentPage - 2 > 0 ? currentPage - 2 : 1}" />
              <c:set var="endPage" value="${startPage + 4 < totalPages ? startPage + 4 : totalPages}" />
               <c:forEach var="i" begin="${startPage}" end="${endPage}">
                 <a href="?page=${i}${queryString}" class="${i == currentPage ? 'active' : ''}">${i}</a>
             </c:forEach>
             
              <c:if test="${currentPage < totalPages}">
                  <a href="?page=${currentPage + 1}${queryString}">다음 »</a>
              </c:if>
          </div>
		</div>
		<%@ include file="/WEB-INF/views/common/footer.jsp"%>
	</div>
</body>
</html>
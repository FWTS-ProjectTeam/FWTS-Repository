<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>주문 내역</title>
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
    margin: 30px 20px;
    display: flex;
    align-items: flex-start;
}
.mypage-menu {
    width: 200px;
    padding: 20px;
    background-color: #fff;
    border-radius: 10px;
    box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.1);
    margin-right: 20px;
}
.mypage-menu ul li.active {
    background-color: #ff6080;
    color: white;
    border-radius: 5px;
}
.content {
    flex-grow: 1;
    background-color: #fff;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.1);
}
table {
    width: 100%;
    border-collapse: collapse;
}
th, td {
    border: 1px solid #ddd;
    padding: 10px;
    text-align: center;
}
.detail-button {
    padding: 5px 10px;
    background-color: #ff4081;
    color: white;
    border: none;
    cursor: pointer;
    border-radius: 5px;
    font-size: 14px;
}
/* ✅ 상태별 텍스트 색상 적용 */
.status-red { color: red; } /* 입금확인중 */
.status-orange { color: orange; } /* 배송준비중 */
.status-green { color: green; } /* 배송중 */
.status-blue { color: blue; } /* 배송완료 */
/* ✅ 페이징 스타일 */
.pagination {
    text-align: center;
    margin-top: 20px;
}
.pagination a {
    display: inline-block;
    padding: 8px 12px;
    margin: 0 5px;
    border: 1px solid #ddd;
    border-radius: 5px;
    text-decoration: none;
    color: black;
}
.pagination a.active {
    background-color: #ff6080;
    color: white;
    border: 1px solid #ff6080;
}
/* ✅ 엑셀 다운로드 버튼 스타일 */
.excel-download {
    background-color: #4CAF50;
    color: white;
    padding: 10px 15px;
    border: none;
    cursor: pointer;
    border-radius: 5px;
    font-size: 14px;
    float: right;
    margin-top: 15px;
}
.excel-download:hover {
    background-color: #45a049;
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
	        <!-- ✅ 주문 내역 페이지 -->
	        <div class="content">
	            <!-- ✅ 검색 폼 -->
	            <form action="/buyer/orderList" method="get" style="text-align: right; margin-bottom: 10px;">
	                <input type="text" name="searchKeyword" placeholder="상품명 검색" value="${searchKeyword}">
	                <button type="submit">🔍 검색</button>
	            </form>
	
	            <h1>📦 주문 내역</h1>
	            <p>현재까지 주문한 내역을 확인하세요.</p>
	
	            <table>
	                <tr>
	                    <th>주문번호</th>
	                    <th>상품명</th>
	                    <th>수량</th>
	                    <th>가격</th>
	                    <th>상태</th>
	                    <th>상세보기</th>
	                </tr>
	
	                <c:forEach var="order" items="${orderList}">
	                    <tr>
	                        <td>${order.orderNum}</td>
	                        <td>${order.proName}</td>
	                        <td>${order.purchaseQuantity}</td>
	                        <td>${order.totalPrice}원</td>
	                        <td>
	                            <c:choose>
	                                <c:when test="${order.orderState == 0}">
	                                    <span class="status-red">입금확인중</span>
	                                </c:when>
	                                <c:when test="${order.orderState == 1}">
	                                    <span class="status-orange">배송준비중</span>
	                                </c:when>
	                                <c:when test="${order.orderState == 2}">
	                                    <span class="status-green">배송중</span>
	                                </c:when>
	                                <c:when test="${order.orderState == 3}">
	                                    <span class="status-blue">배송완료</span>
	                                </c:when>
	                                <c:otherwise>
	                                    <span>상태 미확인</span>
	                                </c:otherwise>
	                            </c:choose>
	                        </td>
	                        <td>
	                            <button class="detail-button" onclick="location.href='/buyer/orderDetail?orderNum=${order.orderNum}'">
	                                상세
	                            </button>
	                        </td>
	                    </tr>
	                </c:forEach>
	
	                <c:if test="${empty orderList}">
	                    <tr>
	                        <td colspan="6" style="text-align: center; color: gray;">
	                            현재 주문 내역이 없습니다.
	                        </td>
	                    </tr>
	                </c:if>
	            </table>
	
	            <!-- ✅ 페이징 네비게이션 (검색어 유지) -->
	            <div class="pagination">
	                <c:if test="${currentPage > 1}">
	                    <a href="?page=${currentPage - 1}&searchKeyword=${searchKeyword}">« 이전</a>
	                </c:if>
	
	                <c:forEach var="i" begin="1" end="${totalPages}">
	                    <a href="?page=${i}&searchKeyword=${searchKeyword}" class="${i == currentPage ? 'active' : ''}">${i}</a>
	                </c:forEach>
	
	                <c:if test="${currentPage < totalPages}">
	                    <a href="?page=${currentPage + 1}&searchKeyword=${searchKeyword}">다음 »</a>
	                </c:if>
	            </div>
	
	            <!-- ✅ 엑셀 다운로드 버튼 -->
	            <div>
	                <form action="/buyer/downloadExcel" method="get">
	                    <button type="submit" class="excel-download">📥 엑셀 다운로드</button>
	                </form>
	            </div>
	        </div>
	    </div>
    </div>
</div>
</body>
</html>

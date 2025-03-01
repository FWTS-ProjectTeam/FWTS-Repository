<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>생화24 - 주문 내역</title>
<link rel="stylesheet" href="/resources/css/common.css">
<link rel="stylesheet" href="/resources/css/table.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<style>
	.sidebar .order-active {
        font-weight: 600;
        background-color: #ff7f9d;
        color: white;
        border-radius: 5px;
    }
    
	/* 검색 입력창 크기 조절 */
	.search-table-box {
	    width: 150px;  /* 기존보다 폭을 줄임 */
	    margin-left: 5px;
	}
	
	/* 날짜 입력창 크기 조절 */
	.search-table-box[type="date"] {
	    width: 100px;  /* 날짜 선택 칸도 폭을 줄임 */
	}
    
	
	th:nth-child(1), td:nth-child(1) { width: 70px; }
	th:nth-child(3), td:nth-child(3) { width: 50px; }
	th:nth-child(4), td:nth-child(4) { width: 100px; }
	th:nth-child(5), td:nth-child(5) { width: 80px; }
	th:nth-child(6), td:nth-child(6) { width: 64px; }

	/* 상세보기 버튼 */
	.detail-button {
	    background-color: transparent;
	    border: none;
	    font-size: 18px;
	    cursor: pointer;
	    transition: background-color 0.3s, color 0.3s;
	}
	.detail-button i.fas { color: var(--main2); }
	.detail-button:hover { background-color: #f0f0f0; }

	/* 상태별 텍스트 색상 */
	.status-red { color: red; }
	.status-orange { color: orange; }
	.status-green { color: green; }
	.status-blue { color: blue; }

	/* 엑셀 다운로드 버튼 */
	.excel-download {
	    background-color: #4CAF50;
	    color: white;
	    padding: 10px 15px;
	    border: none;
	    cursor: pointer;
	    border-radius: 5px;
	    float: right;
	}
	.excel-download i { margin-right: 10px; }
	.excel-download:hover { background-color: #45a049; }
</style>
</head>
<body>
<div class="container">
	<!-- 공통 -->
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
    
    <div class="body-container">
        <!-- 사이드바 -->
    	<%@ include file="/WEB-INF/views/common/mypage-sidebar.jsp" %>

		<!-- 주문 내역 페이지 -->
    	<div class="table-container">
            <div class="table-top-container">
            	<!-- 엑셀 다운로드 버튼 -->
	            <form action="/buyer/downloadExcel" method="get">
	                <button type="submit" class="excel-download">
	                	<i class="fa-solid fa-file-arrow-down"></i>
	                	엑셀 다운로드
	                </button>
	            </form>
            
            	<!-- ✅ 검색 (상품명 + 날짜 검색 추가됨) -->
			    <form class="search-table-form" id="search-table-form" action="/buyer/orders">
			        <!-- ✅ 주문 날짜 검색 추가 -->
			        <input class="search-table-box" type="date" id="startDate" name="startDate" value="${startDate}">
			        <input class="search-table-box" type="date" id="endDate" name="endDate" value="${endDate}">
			        
			        <input class="search-table-box" id="keyword" name="keyword" value="${tKeyword}" placeholder="상품명을 입력해주세요">
			        
			        <button type="submit" class="button">검색</button>
			    </form>
			</div>

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
                        <td title="${order.proName}">${order.proName}</td>
                        <td>${order.purchaseQuantity}</td>
                        <td><fmt:formatNumber value="${order.totalPrice}" type="number" /></td>
                        <td>
                            <c:choose>
                                <c:when test="${order.orderState == 0}"><span class="status-red">입금확인중</span></c:when>
                                <c:when test="${order.orderState == 1}"><span class="status-orange">배송준비중</span></c:when>
                                <c:when test="${order.orderState == 2}"><span class="status-green">배송중</span></c:when>
                                <c:when test="${order.orderState == 3}"><span class="status-blue">배송완료</span></c:when>
                                <c:otherwise><span>상태 미확인</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <button class="detail-button" onclick="location.href='/buyer/orderDetail?orderNum=${order.orderNum}'">
                                <i class="fas fa-info-circle"></i>
                            </button>
                        </td>
                    </tr>
                </c:forEach>
            </table>

            <!-- ✅ 페이징 (검색어 + 날짜 유지) -->
            <div class="pagination">
            	<c:choose>
			        <c:when test="${not empty orderList}">
		            	<c:set var="queryString" value="" />
			            <c:if test="${not empty tKeyword}">
			                <c:set var="queryString" value="${queryString}&keyword=${fn:escapeXml(tKeyword)}" />
			            </c:if>
			            <c:if test="${not empty startDate}">
			                <c:set var="queryString" value="${queryString}&startDate=${startDate}" />
			            </c:if>
			            <c:if test="${not empty endDate}">
			                <c:set var="queryString" value="${queryString}&endDate=${endDate}" />
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
		             </c:when>
			        <c:otherwise><p>조회된 주문이 없습니다.</p></c:otherwise>
			    </c:choose>
            </div>
        </div>
    </div>
    
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</div>
</body>
</html>

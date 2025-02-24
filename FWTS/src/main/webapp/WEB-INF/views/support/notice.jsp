<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>생화 24 - 고객센터</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #fff;
        color: #333;
    }
    .container {
        width: 80%;
        margin: 0 auto;
    }
    .header {
        display: flex;
        justify-content: space-between;
        align-items: flex-end;
        padding: 0px 10px;
        margin: 20px 10px 15px 10px;
        position: relative;
    }
    .header-left {
        display: flex;
        align-items: center;
    }
    .header-left h1 {
    	font-size: 36px;
    	color:#ff3366;
    	margin: 0px;
    }
    .header-right {
        display: flex;
    }
    .header-right a {
        font-size: 13px;
        text-decoration: none;
        color: #333;
        margin-left: 10px;
    }
    .search-container {
    	width: 240px;
        display: flex;
        align-items: center;
        border: 1px solid #ccc;
        border-radius: 5px;
        padding: 10px;
        margin-left: 110px;
        background-color: #fff;
    }
    .search-box {
    	font-size: 14px;
        border: none;
        outline: none;
        flex-grow: 1;
    }        
    .search-button {
        background: none;
        border: none;
        cursor: pointer;
        font-size: 16px;
        color: #ff3366;
        padding: 5px;
    }
    .nav-container {
        display: flex;
        justify-content: space-between;
        border: 1px solid #ccc; /* 상단 메뉴 구분선 */
        border-radius: 10px;
        padding: 20px;
        align-items: flex-end;
    }
    .nav a {
        font-size: 20px;
        font-weight: 600;
        text-decoration: none;
        color: #333;
        margin-right: 30px;
    }
    .nav-right a {
        text-decoration: none;
        color: #FF748B;
        font-size: 16px;
        font-weight: 600;
        margin-left: 10px;
    }
    .body-container {
    	display: flex;
    	margin: 20px;
    }
    .sidebar {
        width: 180px; /* 사이드 메뉴 너비 고정 */
        min-width: 180px;
       	max-width: 180px;
        padding: 10px;
        border: 1px solid #ccc;
        background-color: #fff;
        border-radius: 10px;
        margin-right: 20px;
        align-self: flex-start; /* 내부 콘텐츠 크기만큼 높이 조정 */
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
    .sidebar .active {
    	font-weight: 600;
        background-color: #ff7f9d;
        color: #fff;
        border-radius: 5px;
    }
    
    th:nth-child(1), td:nth-child(1) { 
	    width: 60px;  /* 번호 열의 너비 고정 */
	    min-width: 60px;
	    max-width: 60px;
	}
	td:nth-child(2) {
   		text-align: left; /* 제목만 왼쪽 정렬 */
   	}
	th:nth-child(3), td:nth-child(3),
	th:nth-child(4), td:nth-child(4) { 
	    width: 96px; /* 작성자, 작성일 열의 너비 고정 */
	    min-width: 96px;
	    max-width: 96px;
	}
    .pagination {
    	white-space: nowrap;
        text-align: center;
        margin-top: 20px;
    }
    .pagination a {
       	font-size: 12px;
        text-decoration: none;
        color: #333;
        margin-left: 10px;
    }
    .pagination a:first-child {
	    margin-right: 5px; /* 화살표와 숫자 사이 간격 조절 */
	}
    .pagination span {
        background-color: #ff7f9d;
        padding: 5px 10px;
        border-radius: 5px;
        color: #fff;
    }
</style>
</head>
<body>
<div class="container">
	<!-- 공통 -->
   	<%@ include file="/WEB-INF/views/common/header.jsp" %>
        
    <div class="body-container">
        <!-- 사이드바 -->
    	<%@ include file="/WEB-INF/views/common/support-sidebar.jsp" %>
        
        <div class="table-container">
        	<div class="table-top-container">
        		<!-- 관리자 항목 -->
		    	<sec:authorize access="hasRole('ROLE_ADMIN')">
		        	<div class="button-container">
			        	<button class="button" onclick="location.href='/support-center/notices/edit'">작성</button>
		   			</div>
	        	</sec:authorize>
        	</div>
        
            <table>
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>제목</th>
                        <th>작성자</th>
                        <th>작성일</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="notice" items="${notices}">
			            <tr>
			                <td>${notice.noticeId}</td>
			                <td title="${notice.noticeTitle}"><a href="/support-center/notices/${notice.noticeId}">${notice.noticeTitle}</a></td>
			                <td>생화24</td>
			                <td><fmt:formatDate value="${notice.createdDate}" pattern="yyyy.MM.dd" /></td>
			            </tr>
			        </c:forEach>
				</tbody>
            </table>
           
            <!-- 페이지네이션 -->
            <div class="pagination">			        
		       	<c:choose>
			        <c:when test="${count > 0}">
			        	<c:choose>
						    <c:when test="${currentPage > 1}">
						        <a href="/support-center/notices?page=${currentPage - 1}">◀</a>
						    </c:when>
						    <c:otherwise><a>◀</a></c:otherwise>
				        </c:choose>
		        
		       			<span>${currentPage} / ${totalPages}</span>
		       		
			       		<c:choose>
						    <c:when test="${currentPage < totalPages}">
						        <a href="/support-center/notices?page=${currentPage + 1}">▶</a>
						    </c:when>
						    <c:otherwise><a>▶</a></c:otherwise>
						</c:choose>
	       			</c:when>
       				<c:otherwise><p>조회된 글이 없습니다.</p></c:otherwise>
		       	</c:choose>
			</div>
		</div>
	</div>
	
	<!-- 푸터 -->
	<%@ include file="/WEB-INF/views/common/footer.jsp"%>
</div>
</body>
</html>
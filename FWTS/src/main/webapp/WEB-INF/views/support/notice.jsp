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
<link rel="stylesheet" href="/resources/css/common.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<style>
    .sidebar .notice-active {
    	font-weight: 600;
        background-color: #ff7f9d;
        color: #fff;
        border-radius: 5px;
    }
    
    .button-container button {
	    background: #ff7f9d;
	    color: white;
	    padding: 10px 20px;
	    border: none;
	    border-radius: 5px;
	    cursor: pointer;
	}
    
    .table-top-container {
    	width: 100%;
	    height: 40px;
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	    margin-bottom: 20px;
	}
	
    .table-container {
        width: 100%;
        margin: 20px 10px 0px 10px;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        background-color: #fff;
    }    
    th, td {
        padding: 10px;
        border-bottom: 1px solid #ccc;
    }
    th {
        background-color: #ff7f9d;
        color: #fff;
        text-align: center;
    }
    td:nth-child(2) {
	    text-align: left; /* 제목만 왼쪽 정렬 */
	}
    td a {
        text-decoration: none;
        color: #333;
        display: block;
        text-align: left;
    }
    th:nth-child(1), td:nth-child(1) { 
    	width: 60px;  /* 번호 열의 너비 고정 */
	    min-width: 60px;
	    max-width: 60px;
	    text-align: center;
	}
	th:nth-child(3), td:nth-child(3) { 
		width: 100px; /* 작성자 열의 너비 고정 */
	    min-width: 100px;
	    max-width: 100px;
	    text-align: center;
	}
	th:nth-child(4), td:nth-child(4) { 
		width: 100px; /* 작성일 열의 너비 고정 */
	    min-width: 100px;
	    max-width: 100px;
	    text-align: center;
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
			        	<button onclick="location.href='/support-center/notice/edit'">작성</button>
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
			                <td><a href="/support-center/notice/${notice.noticeId}">${notice.noticeTitle}</a></td>
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
						        <a href="/support-center/notice?page=${currentPage - 1}">◀</a>
						    </c:when>
						    <c:otherwise><a>◀</a></c:otherwise>
				        </c:choose>
		        
		       			<span>${currentPage} / ${totalPages}</span>
		       		
			       		<c:choose>
						    <c:when test="${currentPage < totalPages}">
						        <a href="/support-center/notice?page=${currentPage + 1}">▶</a>
						    </c:when>
						    <c:otherwise><a>▶</a></c:otherwise>
						</c:choose>
	       			</c:when>
       				<c:otherwise><p>조회된 글이 없습니다.</p></c:otherwise>
		       	</c:choose>
			</div>
		</div>
	</div>
</div>
</body>
</html>
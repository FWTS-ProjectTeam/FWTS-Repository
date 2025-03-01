<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>생화 24 - 공지사항</title>
<link rel="stylesheet" href="/resources/css/common.css">
<link rel="stylesheet" href="/resources/css/table.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<style>
    .sidebar .notice-active {
    	font-weight: 600;
        background-color: #ff7f9d;
        color: white;
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
			            <c:if test="${currentPage > 1}">
			                <a href="?page=${currentPage - 1}">« 이전</a>
			            </c:if>
			            
			            <c:set var="startPage" value="${currentPage - 2 > 0 ? currentPage - 2 : 1}" />
    					<c:set var="endPage" value="${startPage + 4 < totalPages ? startPage + 4 : totalPages}" />
			            <c:forEach var="i" begin="${startPage}" end="${endPage}">
					        <a href="?page=${i}" class="${i == currentPage ? 'active' : ''}">${i}</a>
					    </c:forEach>
			            
			            <c:if test="${currentPage < totalPages}">
			                <a href="?page=${currentPage + 1}">다음 »</a>
			            </c:if>
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
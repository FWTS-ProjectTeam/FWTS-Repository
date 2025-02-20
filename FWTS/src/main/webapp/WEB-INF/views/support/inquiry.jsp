<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>생화 24 - 고객센터</title>
<link rel="stylesheet" href="/resources/css/common.css">
<link rel="stylesheet" href="/resources/css/table.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<style>
    .sidebar .inquiry-active {
    	font-weight: 600;
        background-color: #ff7f9d;
        color: white;
        border-radius: 5px;
    }
   	
    td:nth-child(2) {
   		text-align: left; /* 제목만 왼쪽 정렬 */
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
    
	.hidden {
		visibility: hidden;
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
        		<div class="button-container">
	        		<!-- 관리자 항목 -->
			    	<sec:authorize access="hasRole('ROLE_ADMIN')">
			        	<button class="button hidden">작성</button>
					</sec:authorize>
					
					<!-- 비관리자 항목 -->
					<sec:authorize access="!hasRole('ROLE_ADMIN')">
			        	<button class="button" onclick="location.href='/support-center/inquirys/edit'">작성</button>
					</sec:authorize>
				</div>
	         
	         	<!-- 게시글 검색 -->
	         	<form class="search-board-form" action="/support-center/inquirys">
				    <select class="search-category" name="category">
				        <option value="all" ${category == 'all' ? 'selected' : ''}>전체</option>
				        <option value="title" ${category == 'title' ? 'selected' : ''}>제목</option>
				        <option value="content" ${category == 'content' ? 'selected' : ''}>내용</option>
				    </select>
				    <input class="search-board-box" name="keyword" type="text" value="${keyword}" placeholder="검색어를 입력해주세요">
				    <button type="submit" class="button">검색</button>
				</form>
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
                    <c:forEach var="inquiry" items="${inquirys}">
			            <tr>
			                <td>${inquiry.inquiryId}</td>
			                <td><a href="/support-center/inquirys/${inquiry.inquiryId}"><c:if test="${not empty inquiry.replyDate}"><span class="reply">[완료] </span></c:if>${inquiry.inquiryTitle}</a></td>
			                <td>${inquiry.username}</td>
			                <td><fmt:formatDate value="${inquiry.createdDate}" pattern="yyyy.MM.dd" /></td>
			            </tr>
        			</c:forEach>
                </tbody>
            </table>
            
			<!-- 페이지네이션 -->
			<div class="pagination">
			    <c:choose>
				    <c:when test="${count > 0}">
				        <c:if test="${category == 'all' || category == 'title' || category == 'content'}">
				            <c:set var="queryString" value="${queryString}&category=${fn:escapeXml(category)}&keyword=${fn:escapeXml(keyword)}" />
				        </c:if>
				
				        <c:choose>
				            <c:when test="${currentPage > 1}">
				                <a href="/support-center/inquirys?page=${currentPage - 1}${queryString}">◀</a>
				            </c:when>
				            <c:otherwise><a>◀</a></c:otherwise>
				        </c:choose>
				
				        <span>${currentPage} / ${totalPages}</span>
				
				        <c:choose>
				            <c:when test="${currentPage < totalPages}">
				                <a href="/support-center/inquirys?page=${currentPage + 1}${queryString}">▶</a>
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
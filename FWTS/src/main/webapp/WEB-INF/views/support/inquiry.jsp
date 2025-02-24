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
	         	<form class="search-table-form" action="/support-center/inquirys" onsubmit="return cleanEmptyQuery()">
				    <select class="search-category" id="category" name="category">
				        <option value="all" ${tCategory == 'all' ? 'selected' : ''}>전체</option>
				        <option value="title" ${tCategory == 'title' ? 'selected' : ''}>제목</option>
				        <option value="content" ${tCategory == 'content' ? 'selected' : ''}>내용</option>
				    </select>
				    <input class="search-table-box" id="keyword" name="keyword" value="${tKeyword}" placeholder="검색어를 입력해주세요">
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
			                <td title="${inquiry.inquiryTitle}">
			                	<a href="/support-center/inquirys/${inquiry.inquiryId}">
			                		<c:if test="${not empty inquiry.replyDate}"><span class="reply">[완료]</span></c:if>
			                		${inquiry.inquiryTitle}
			                	</a>
			                </td>
			                <td title="${inquiry.username}">${inquiry.username}</td>
			                <td><fmt:formatDate value="${inquiry.createdDate}" pattern="yyyy.MM.dd" /></td>
			            </tr>
        			</c:forEach>
                </tbody>
            </table>

            <!-- 페이지네이션 -->
			<div class="pagination">
			    <c:choose>
			        <c:when test="${count > 0}">
			        	<c:set var="queryString" value="" />
			            <c:if test="${tCategory == 'all' || tCategory == 'title' || tCategory == 'content'}">
			                <c:set var="queryString" value="${queryString}&category=${fn:escapeXml(tCategory)}&keyword=${fn:escapeXml(tKeyword)}" />
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
			        <c:otherwise><p>조회된 글이 없습니다.</p></c:otherwise>
			    </c:choose>
			</div>
        </div>
    </div>
    
    <!-- 푸터 -->
    <%@ include file="/WEB-INF/views/common/footer.jsp"%>
</div>
<script>
	//빈 쿼리 제거
	function cleanEmptyQuery() {
	    const form = document.getElementById("search-table-form");
	    
	    var categoryInput = document.getElementById("category");
	    var keywordInput = document.getElementById("keyword");
	    
	    if (keywordInput && !keywordInput.value.trim()) {
	        keywordInput.removeAttribute("name");
	        categoryInput.removeAttribute("name");
	    }
	    
	    form.requestSubmit(); // 폼 제출 실행
	}
</script>
</body>
</html>
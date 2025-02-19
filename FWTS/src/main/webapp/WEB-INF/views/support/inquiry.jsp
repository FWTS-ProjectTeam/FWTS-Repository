<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<style>
    .sidebar .inquiry-active {
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
	
	.search-board-container {
	    display: flex;
	    align-items: center;
	}
	.search-category {
	 	width: 80px;
	    padding: 10px;
	    border: 1px solid #ccc;
	    border-radius: 5px;
	    font-size: 14px;
	    background-color: #fff;
	    margin-right: 10px;
	    outline: none; /* 클릭 시 검은색 강조 제거 */
	    appearance: none; /* 기본 드롭다운 스타일 제거 */
	    -webkit-appearance: none;
	    -moz-appearance: none;
	}
	
    .search-board-box {
    	width: 280px;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 5px;
        font-size: 14px;
        outline: none;
    }
    .search-board-button {
        margin-left: 10px;
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
    
    .reply {
		font-weight: 600;
		color: #ffb6c1;
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
			        	<button class="hidden">작성</button>
					</sec:authorize>
					
					<!-- 비관리자 항목 -->
					<sec:authorize access="!hasRole('ROLE_ADMIN')">
			        	<button onclick="location.href='/support-center/inquiry/edit'">작성</button>
					</sec:authorize>
				</div>
	         
	         	<!-- 게시글 검색 -->
	         	<form class="search-board-container" action="/support-center/inquiry">
				    <select class="search-category" name="category">
				        <option value="all" ${category == 'all' ? 'selected' : ''}>전체</option>
				        <option value="title" ${category == 'title' ? 'selected' : ''}>제목</option>
				        <option value="content" ${category == 'content' ? 'selected' : ''}>내용</option>
				    </select>
				    <input class="search-board-box" name="keyword" type="text" placeholder="검색어를 입력하세요" value="${keyword}">
				    <div class="button-container">
			        	<button type="submit" class="search-board-button">검색</button>
		   			</div>
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
			                <td><a href="/support-center/inquiry/${inquiry.inquiryId}"><c:if test="${not empty inquiry.replyDate}"><span class="reply">[완료] </span></c:if>${inquiry.inquiryTitle}</a></td>
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
			            <c:set var="queryString">
						    <c:if test="${category == 'all' || category == 'title' || category == 'content'}">
						        <c:set var="queryString" value="&category=${fn:escapeXml(category)}&keyword=${fn:escapeXml(keyword)}" />
						    </c:if>
						</c:set>
			
			            <!-- 이전 페이지 버튼 -->
			            <c:choose>
			                <c:when test="${currentPage > 1}">
			                    <a href="/support-center/inquiry?page=${currentPage - 1}${queryString}">◀</a>
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
			                    <a href="/support-center/inquiry?page=${currentPage + 1}${queryString}">▶</a>
			                </c:when>
			                <c:otherwise>
			                    <a>▶</a>
			                </c:otherwise>
			            </c:choose>
			        </c:when>
			        <c:otherwise>
			            <p>조회된 글이 없습니다.</p>
			        </c:otherwise>
			    </c:choose>
			</div>
        </div>
    </div>
</div>
</body>
</html>
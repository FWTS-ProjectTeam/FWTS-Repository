<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>생화 24 - 마이페이지</title>
<link rel="stylesheet" href="/resources/css/common.css">
<link rel="stylesheet" href="/resources/css/table.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
	th:nth-child(2), td:nth-child(2) { 
		white-space: nowrap; /* 텍스트가 한 줄로 유지 */
	    overflow: ellipsis; /* 넘칠 경우 숨김 처리 */
	}
	td:nth-child(2) {
   		text-align: left; /* 제목만 왼쪽 정렬 */
   	}
	th:nth-child(3), td:nth-child(3),
	th:nth-child(4), td:nth-child(4) { 
	    width: 100px; /* 작성자, 작성일 열의 너비 고정 */
	    min-width: 100px;
	    max-width: 100px;
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
			<div class="table-top-container"></div>
         
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
			                <td>
			                	<a href="/support-center/inquirys/${inquiry.inquiryId}">
			                	<c:if test="${not empty inquiry.replyDate}"><span class="reply">[완료] </span></c:if>${inquiry.inquiryTitle}</a></td>
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
						<c:choose>
							<c:when test="${currentPage > 1}">
								<a href="/my-page/inquiry-history?page=${currentPage - 1}">◀</a>
						    </c:when>
						    <c:otherwise><a>◀</a></c:otherwise>
				        </c:choose>
	       
	      				<span>${currentPage} / ${totalPages}</span>
	      		
	       				<c:choose>
						    <c:when test="${currentPage < totalPages}">
						        <a href="/my-page/inquiry-history?page=${currentPage + 1}">▶</a>
						    </c:when>
						    <c:otherwise><a>▶</a></c:otherwise>
						</c:choose>
	     			</c:when>
	    			<c:otherwise><p>조회된 글이 없습니다.</p></c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>
	<%@ include file="/WEB-INF/views/common/footer.jsp"%>
 </div>
</body>
</html>
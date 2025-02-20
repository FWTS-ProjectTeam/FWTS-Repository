<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>생화24 - 관리페이지</title>
<link rel="stylesheet" href="/resources/css/common.css">
<link rel="stylesheet" href="/resources/css/table.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<style>
    .sidebar .wholesaler-active {
        font-weight: 600;
        background-color: #ff7f9d;
        color: white;
        border-radius: 5px;
    }

	.table-top-container label {
		font-size: 14px;
	    align-self: flex-end; /* 하단으로 정렬 */
	}
    
    table {
	  font-size: 14px;
	  line-height: 1.5;
	}
    th, td { 
	    text-align: center;
	}

	.modal {
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    position: fixed;
	    top: 0;
	    left: 0;
	    width: 100%;
	    height: 100%;
	    background-color: rgba(0, 0, 0, 0.5);
	}
	
	.hidden {
	    display: none;
	}
	
	.modal-content {
	    background-color: white;
	    padding: 20px;
	    border-radius: 8px;
	    text-align: center;
	    width: 300px;
	}
	
	.close {
	    float: right;
	    font-size: 24px;
	    cursor: pointer;
	}
</style>
</head>
<body>
<div class="container">
	<!-- 공통 -->
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
    
    <div class="body-container">
        <!-- 사이드바 -->
    	<%@ include file="/WEB-INF/views/common/managepage-sidebar.jsp" %>
    	
    	<div id="userDetailModal" class="modal hidden">
		    <div class="modal-content">
		        <span class="close" onclick="closeDetail()">&times;</span>
		        <h3>회원 상세 정보</h3>
		        <p><strong>고유번호:</strong> <span id="detailUserId"></span></p>
		        <p><strong>로그인 ID:</strong> <span id="detailUsername"></span></p>
		        <p><strong>이름:</strong> <span id="detailEcoName"></span></p>
		        <p><strong>이메일:</strong> <span id="detailEmail"></span></p>
		        <p><strong>가입일:</strong> <span id="detailCreatedAt"></span></p>
		        <p><strong>계정 상태:</strong> <span id="detailStatus"></span></p>
		        <button onclick="closeDetail()">닫기</button>
		    </div>
		</div>
        
        <div class="table-container">
        	<div class="table-top-container">
		    <!-- 제한된 회원 필터 -->
		    <label>
		        <input type="checkbox" id="limited-filter" name="isLimited" onchange="toggleLimitedFilter()" ${isLimited ? 'checked' : ''}>
				제한된 회원만 보기
		    </label>
		
		    <!-- 회원 검색 -->
		    <form class="search-board-form" id="search-board-form" action="/manage-page/wholesalers" onsubmit="return cleanEmptyQuery()">
		        <select class="search-category" name="category">
		            <option value="username" ${category == 'username' ? 'selected' : ''}>아이디</option>
		            <option value="email" ${category == 'email' ? 'selected' : ''}>이메일</option>
		            <option value="companyName" ${category == 'companyName' ? 'selected' : ''}>상호명</option>
		            <option value="ceoName" ${category == 'ceoName' ? 'selected' : ''}>대표자명</option>
		        </select>
		        <input class="search-board-box" name="keyword" type="text" value="${keyword}" placeholder="검색어를 입력해주세요">
		
		        <!-- 제한된 회원 여부를 hidden input으로 전송 -->
		        <input type="hidden" id="is-limited" name="isLimited" value="${isLimited}">
		
		        <button type="submit" class="button">검색</button>
		    </form>
		</div>
        
            <table>
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>아이디</th>
                        <th>대표자</th>
                        <th>이메일</th>
                        <th>가입일</th>
                        <th>상태</th>
                        <th>상세</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${users}">
			            <tr>
			                <td>${user.userId}</td>
			                <td>${user.username}</td>
			                <td>${user.ceoName}</td>
			                <td>${user.email}</td>
			                <td><fmt:formatDate value="${user.createdAt}" pattern="yyyy.MM.dd"/></td>
			                <td>${user.isLimited() ? '제한' : '활성화'}</td>
			                <td><button onclick="showDetail(${user.userId})">🔍</button></td>
			            </tr>
        			</c:forEach>
                </tbody>
            </table>
            
			<!-- 페이지네이션 -->
			<div class="pagination">
			    <c:choose>
			        <c:when test="${count > 0}">
			        	<c:set var="queryString" value="" />
			        
					    <c:if test="${category == 'all' || category == 'title' || category == 'content'}">
					        <c:set var="queryString" value="&category=${fn:escapeXml(category)}&keyword=${fn:escapeXml(keyword)}" />
					    </c:if>
					    
					    <c:if test="${not empty isLimited and isLimited eq 'true'}">
				            <c:set var="queryString" value="${queryString}&isLimited=true" />
				        </c:if>
			
			            <c:choose>
			                <c:when test="${currentPage > 1}">
			                    <a href="/manage-page/wholesalers?page=${currentPage - 1}${queryString}">◀</a>
			                </c:when>
			                <c:otherwise><a>◀</a></c:otherwise>
			            </c:choose>
			
			            <span>${currentPage} / ${totalPages}</span>
			
			            <c:choose>
			                <c:when test="${currentPage < totalPages}">
			                    <a href="/manage-page/wholesalers?page=${currentPage + 1}${queryString}">▶</a>
			                </c:when>
			                <c:otherwise><a>▶</a></c:otherwise>
			            </c:choose>
			        </c:when>
			        <c:otherwise><p>조회된 회원이 없습니다.</p></c:otherwise>
			    </c:choose>
			</div>
        </div>
    </div>
</div>
<script>
	var users = [];
	
	<c:forEach var="user" items="${users}">
	    users.push({
	        userId: ${user.userId},
	        username: "${user.username}",
	        ecoName: "${user.ceoName}",
	        email: "${user.email}",
	        createdAt: "<fmt:formatDate value='${user.createdAt}' pattern='yyyy.MM.dd'/>",
	        role: "${user.role}",
	        isLimited: ${user.isLimited()}
	    });
	</c:forEach>
	
	// 상세 보기 모달 표시 함수
	function showDetail(userId) {
		const user = users.find(user => user.userId === userId);
	    if (!user) {
	    	return;
	    }
	
	    document.getElementById("detailUserId").innerText = user.userId;
	    document.getElementById("detailUsername").innerText = user.username;
	    document.getElementById("detailEcoName").innerText = user.ecoName;
	    document.getElementById("detailEmail").innerText = user.email;
	    document.getElementById("detailCreatedAt").innerText = user.createdAt;
	    document.getElementById("detailStatus").innerText = user.isLimited ? "❌" : "✅";
	
	    document.getElementById("userDetailModal").classList.remove("hidden");
	}
	
	// 상세 보기 모달 닫기 함수
	function closeDetail() {
	    document.getElementById("userDetailModal").classList.add("hidden");
	}
	
	// 제한된 회원 필터
	function toggleLimitedFilter() {
	    var checkbox = document.getElementById("limited-filter");
	    var hiddenInput = document.getElementById("is-limited");

	    // 체크 여부에 따라 hidden input 값 설정
	    hiddenInput.value = checkbox.checked ? "true" : "false";

	    // 빈 쿼리 제거 후 폼 제출
	    cleanEmptyQuery();
	}
	
	// 빈 쿼리 제거
	function cleanEmptyQuery() {
	    const form = document.getElementById("search-board-form");
	    
	    var keywordInput = form.querySelector("input[name='keyword']");
        var categorySelect = form.querySelector("select[name='category']");
        var limitedFilter = form.querySelector("#limited-filter");
        var isLimitedInput = form.querySelector("input[name='isLimited']");
        
     	// 검색어가 없으면 category도 함께 제거
        if (keywordInput && !keywordInput.value.trim()) {
            keywordInput.removeAttribute("name");
            if (categorySelect) {
                categorySelect.removeAttribute("name");
            }
        }
	
        // 제한 필터 (체크 안 되어 있으면 isLimited 제거)
        if (limitedFilter && !limitedFilter.checked && isLimitedInput) {
            isLimitedInput.removeAttribute("name");
        }
        
        form.requestSubmit(); // 폼 제출 실행
	}
</script>
</body>
</html>
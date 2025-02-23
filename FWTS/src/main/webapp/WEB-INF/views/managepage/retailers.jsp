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
    .sidebar .retailer-active {
        font-weight: 600;
        background-color: #ff7f9d;
        color: white;
        border-radius: 5px;
    }

	.table-top-container label {
		font-size: 14px;
	    align-self: flex-end; /* 하단으로 정렬 */
	}
	
	table button {
	    background-color: transparent;
	    border: none;
	    padding: 0;
	    font-size: 18px;
	    cursor: pointer;
	    transition: background-color 0.3s, color 0.3s;
	}
	table button i.fas {
	    color: var(--main2);
	}
	table button:hover {
	    background-color: #f0f0f0;
	}
	
	th:nth-child(1), td:nth-child(1) { 
	    width: 45px;  /* 번호 열의 너비 고정 */
	    min-width: 45px;
	    max-width: 45px;
	}
	th:nth-child(2), td:nth-child(2),
	th:nth-child(3), td:nth-child(3) { 
	    width: 100px;  /* 아이디, 대표자명 열의 너비 고정 */
	    min-width: 100px;
	    max-width: 100px;
	}
	th:nth-child(4), td:nth-child(4) {
		white-space: nowrap; /* 텍스트가 한 줄로 유지 */
	    overflow: hidden; /* 넘칠 경우 숨김 처리 */
	}
	th:nth-child(5), td:nth-child(5) { 
	    width: 80px;  /* 가입일 열의 너비 고정 */
	    min-width: 80px;
	    max-width: 80px;
	}
	th:nth-child(6), td:nth-child(6) { 
	    width: 36px;  /* 상태 열의 너비 고정 */
	    min-width: 36px;
	    max-width: 36px;
	}
	th:nth-child(7), td:nth-child(7) { 
	    width: 64px;  /* 상세보기 열의 너비 고정 */
	    min-width: 64px;
	    max-width: 64px;
	}
	
	/* 모달 */
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
	.modal-content {
	    background-color: #fff;
	    padding: 25px;
	    border-radius: 12px;
	    text-align: left;
	    width: 90%;
	    max-width: 500px;  /* 반응형 조절 */
	    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
	    position: relative;
	}
	.modal-content h3 {
	    text-align: center;
	    font-size: 22px;
	    font-weight: bold;
	    margin: 15px 0;
	}
	.modal-content .detail-grid {
	    display: grid;
	    grid-template-columns: 1fr 1fr; /* 2열 배치 */
	    margin-bottom: 15px;
	}
	.modal-content p {
	    margin: 5px 0;
	    font-size: 15px;
	}
	.modal-content p strong {
	    display: inline-block;
	    font-weight: bold;
	}
	
	.status-active {
	    color: green;
	    font-weight: 600;
	}
	.status-limited {
	    color: red;
	    font-weight: 600;
	}
	
	.hidden {
	    display: none;
	}
	
	.close {
	    position: absolute;
	    top: 15px;
	    right: 20px;
	    font-size: 24px;
	    font-weight: bold;
	    cursor: pointer;
	    color: #555;
	    transition: 0.3s;
	}
	.close:hover {
	    color: #d33;
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
    	
    	<div id="user-detail-modal" class="modal hidden">
		    <div class="modal">
			    <div class="modal-content">
			        <span class="close" onclick="closeDetail()">&times;</span>
			        <h3 id="detail-title"></h3>
			
			        <div class="detail-grid">
				        <div>
				        	<p><strong>대표자명:</strong> <span id="detail-ceo"></span></p>
				        	<p><strong>상호명:</strong> <span id="detail-company"></span></p>
				            <p><strong>사업자등록번호:</strong> <span id="detail-business-no"></span></p>
				            <p><strong>가입일:</strong> <span id="detail-created-at"></span></p>
				        </div>
				
				        <div>
				            <p><strong>이메일:</strong> <span id="detail-email"></span></p>
				            <p><strong>휴대폰번호:</strong> <span id="detail-phone"></span></p>
				            <p><strong>사업장 전화번호:</strong> <span id="detail-company-phone"></span></p>
				            <p><strong>상태:</strong> <span id="detail-status"></span></p>
				        </div>
				    </div>
				    
				    <p><strong>주소:</strong> <span id="detail-address"></span></p>
				</div>
			</div>
		</div>
        
        <div class="table-container">
        	<div class="table-top-container">
		    <!-- 제한된 회원 필터 -->
		    <label>
		        <input type="checkbox" id="limited-filter" onchange="toggleLimitedFilter()" ${isLimited ? 'checked' : ''}>
				제한된 회원만 보기
		    </label>
		
		    <!-- 회원 검색 -->
		    <form class="search-table-form" id="search-table-form" action="/manage-page/retailers" onsubmit="return cleanEmptyQuery()">
		        <select class="search-category" id="category" name="category">
		            <option value="username" ${tCategory == 'username' ? 'selected' : ''}>아이디</option>
		            <option value="email" ${tCategory == 'email' ? 'selected' : ''}>이메일</option>
		            <option value="companyName" ${tCategory == 'companyName' ? 'selected' : ''}>상호명</option>
		            <option value="ceoName" ${tCategory == 'ceoName' ? 'selected' : ''}>대표자명</option>
		        </select>
		        <input class="search-table-box" id="keyword" name="keyword" value="${tKeyword}" placeholder="검색어를 입력해주세요">
		
		        <!-- 제한된 회원 여부를 hidden input으로 전송 -->
		        <input type="hidden" id="limited-hidden" name="isLimited" value="${isLimited}">
		
		        <button type="submit" class="button">검색</button>
		    </form>
		</div>
        
            <table>
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>아이디</th>
                        <th>대표자명</th>
                        <th>이메일</th>
                        <th>가입일</th>
                        <th>상태</th>
                        <th>상세보기</th>
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
			                <td>
			                	<button class="status-btn" onclick="toggleUserStatus(${user.userId}, this)">
			                        ${user.isLimited() ? '⚠️' : '✅'}
			                    </button>
			                </td>
			                <td><button onclick="showDetail(${user.userId})"><i class="fas fa-info-circle"></i></button></td>
			            </tr>
        			</c:forEach>
                </tbody>
            </table>
            
			<!-- 페이지네이션 -->
			<div class="pagination">
			    <c:choose>
			        <c:when test="${count > 0}">
			        	<c:set var="queryString" value="" />
			        
					    <c:if test="${tCategory == 'username' || tCategory == 'email' || tCategory == 'companyName' || tCategory == 'ceoName'}">
					        <c:set var="queryString" value="&category=${fn:escapeXml(tCategory)}&keyword=${fn:escapeXml(tKeyword)}" />
					    </c:if>
					    
					    <c:if test="${not empty isLimited}">
				            <c:set var="queryString" value="${queryString}&isLimited=true" />
				        </c:if>
			
			            <c:choose>
			                <c:when test="${currentPage > 1}">
			                    <a href="/manage-page/retailers?page=${currentPage - 1}${queryString}">◀</a>
			                </c:when>
			                <c:otherwise><a>◀</a></c:otherwise>
			            </c:choose>
			
			            <span>${currentPage} / ${totalPages}</span>
			
			            <c:choose>
			                <c:when test="${currentPage < totalPages}">
			                    <a href="/manage-page/retailers?page=${currentPage + 1}${queryString}">▶</a>
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
	        ceoName: "${user.ceoName}",
	        email: "${user.email}",
	        createdAt: "<fmt:formatDate value='${user.createdAt}' pattern='yyyy.MM.dd'/>",
	        isLimited: ${user.isLimited()},
	        phoneNum: "${user.phoneNum}",
	        companyNum: "${user.companyNum}",
	        businessNo: "${user.businessNo}",
	        companyName: "${user.companyName}",
	        postalCode: "${user.postalCode}",
	        address: "${user.address}",
	        detailAddress: "${user.detailAddress}"
	    });
	</c:forEach>
	
	// 제한 여부 변경
	function toggleUserStatus(userId, btn) {
		Swal.fire({
	        title: "정말로 변경하시겠습니까?",
	        text: "이 작업은 되돌릴 수 없습니다!",
	        icon: "question",
	        showCancelButton: true,
	        cancelButtonColor: "#aaa",
	        confirmButtonText: "변경",
	        cancelButtonText: "취소"
	    }).then((result) => {
	        if (result.isConfirmed) {
				const requestUrl = "/manage-page/users/update/" + userId;
				
			    fetch(requestUrl, {
			        method: 'GET'
			    })
			    .then(response => response.json())
			    .then(data => {
			        if (data.success) {
			            var newStatus = data.isLimited ? '제한 상태' : '활성화 상태';
			            var statusColor = newStatus === "활성화 상태" ? "green" : "red";
			            btn.innerText = data.isLimited ? '⚠️' : '✅';
			
			            Swal.fire({
			                icon: 'success',
			                title: '변경 완료',
			                html: '<span style="color: ' + statusColor + '; font-weight: 600;">' + newStatus + '</span>로 변경되었습니다.',
			                confirmButtonText: '확인'
			            }).then((result) => {
			                location.reload();
			            });
			        } else {
			        	throw new Error("서버 오류");
			        }
			    })
			    .catch(error => {
			    	Swal.fire({
			    		icon: 'error',
						title: '변경 실패',
						text: '회원 상태 변경에 실패했습니다.',
						confirmButtonColor: '#d33',
						confirmButtonText: '확인'
		            });
		        });
	        }
		});
	}
	
	// 상세 보기 모달 표시 함수
	function showDetail(userId) {
	    const user = users.find(user => user.userId === userId);
	    
	    document.getElementById("detail-title").innerText = "회원 정보 - " + user.username;
	    document.getElementById("detail-ceo").innerText = user.ceoName;
	    document.getElementById("detail-company").innerText = user.companyName;
	    document.getElementById("detail-email").innerText = user.email;
	    document.getElementById("detail-created-at").innerText = user.createdAt;
	
	    document.getElementById("detail-phone").innerText = user.phoneNum;
	    document.getElementById("detail-company-phone").innerText = user.companyNum;
	    document.getElementById("detail-business-no").innerText = user.businessNo;
	    	
	    // 상태 처리
	    var statusField = document.getElementById("detail-status");
	    statusField.innerText = user.isLimited ? "⚠️ 제한" : "✅ 활성화";
	    statusField.classList.remove("status-active", "status-limited");
	    statusField.classList.add(user.isLimited ? "status-limited" : "status-active");
	    
	 	// 주소 처리
	    var addressText = "(" + user.postalCode + ") " + user.address;
	    if (user.detailAddress) {
	        addressText += ", " + user.detailAddress;
	    }
	    document.getElementById("detail-address").innerText = addressText;
	    
	    document.getElementById("user-detail-modal").classList.remove("hidden");
	}
	
	// 상세 보기 모달 닫기 함수
	function closeDetail() {
	    document.getElementById("user-detail-modal").classList.add("hidden");
	}
	
	// 제한된 회원 필터
	function toggleLimitedFilter() {
	    var limitedFilter = document.getElementById("limited-filter");
	    var limitedHidden = document.getElementById("limited-hidden");

	    // 체크 여부에 따라 hidden limited 값 설정
	    limitedHidden.value = limitedFilter.checked ? "true" : "false";

	    cleanEmptyQuery(); // 빈 쿼리 제거 후 폼 제출
	}
	
	// 빈 쿼리 제거
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
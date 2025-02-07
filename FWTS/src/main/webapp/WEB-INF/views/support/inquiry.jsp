<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
        font-size: 16px;
        margin-left: 110px;
        background-color: #fff;
    }
    .search-box {
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
    .search-board-container {
    	display: flex;
	    align-items: center;
	    justify-content: end;
	    margin-bottom: 20px;
	}
	.search-category {
	 	width: 80px;
	    padding: 10px;
	    border: 1px solid #ccc;
	    border-radius: 5px;
	    font-size: 16px;
	    background-color: #fff;
	    margin-right: 10px;
	}
    .search-board-box {
    	width: 280px;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 5px;
        font-size: 16px;
        outline: none;
    }
    .search-board-button {
        padding: 10px 15px;
        border: none;
        border-radius: 5px;
        background-color: #ff7f9d;
        color: #fff;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
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
</style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="header-left">
                <h1>생화24</h1>
                <div class="search-container">
			        <input class="search-box" type="text" placeholder="찾으시는 꽃을 입력해주세요!">
			        <button class="search-button">
			            <i class="fas fa-search"></i>
			        </button>
			    </div>
            </div>
            <div class="header-right">
                <a href="/login"><strong>로그인</strong></a>
                <a href="/sign-up">회원가입</a>
            </div>
        </div>
        <div class="nav-container">
            <div class="nav">
                <a href="#">절화</a>
                <a href="#">난</a>
                <a href="#">관엽</a>
                <a href="#">기타</a>
            </div>
            <div class="nav-right">
                <a href="#">마이페이지</a>
                <a href="#">고객센터</a>
            </div>
        </div>
        
        <div class="body-container">
            <div class="sidebar">
                <h2>고객센터</h2>
                <a href="/support-center/notice">공지사항</a>
                <a class="active">문의사항</a>
            </div>
            
            <div class="table-container">
            	<div class="search-board-container">
				    <select class="search-category">
				        <option value="all">전체</option>
				        <option value="title">제목</option>
				        <option value="content">내용</option>
				    </select>
				    <input class="search-board-box" type="text" placeholder="검색어를 입력하세요">
				    <button class="search-board-button">검색</button>
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
				                <td><a href="/support-center/inquiry/${inquiry.inquiryId}">${inquiry.inquiryTitle}</a></td>
				                <td>${inquiry.writer.username}</td>
				                <td><fmt:formatDate value="${inquiry.createdDate}" pattern="yyyy.MM.dd" /></td>
				            </tr>
				        </c:forEach>
                    </tbody>
                </table>
                
				<!-- 페이지네이션 -->
                <div class="pagination">		        
			        <c:choose>
				        <c:when test="${count > 1}">
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
			        	<c:otherwise><p>아직 작성된 글이 없습니다.</p></c:otherwise>
			        </c:choose>
			    </div>
            </div>
        </div>
    </div>
</body>
</html>
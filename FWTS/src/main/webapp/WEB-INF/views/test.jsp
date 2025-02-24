<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>배송지 목록</title>
    <link rel="stylesheet" href="styles.css">
</head>
<style>
	.container {
		max-width: 800px;
		margin: auto;
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
    td:nth-child(3) {
   		text-align: left; /* 제목만 왼쪽 정렬 */
   	}
    td a {
        text-decoration: none;
        color: #333;
        display: block;
        text-align: left;
    }
    th:nth-child(1), td:nth-child(1) { 
	    width: 100px;  /* 배송지 열의 너비 고정 */
	    min-width: 100px;
	    max-width: 100px;
	    text-align: center;
	}
	th:nth-child(2), td:nth-child(2) { 
	    width: 80px;  /* 우편번호 열의 너비 고정 */
	    min-width: 80px;
	    max-width: 80px;
	    text-align: center;
	}
	th:nth-child(4), td:nth-child(4) { 
	    width: 90px; /* 기본 배송지 열의 너비 고정 */
	    min-width: 90px;
	    max-width: 90px;
	    text-align: center;
	}
	th:nth-child(5), td:nth-child(5) { 
	    width: 100px; /* 수정삭제 열의 너비 고정 */
	    min-width: 100px;
	    max-width: 100px;
	    text-align: center;
	}
	.checkmark {
		color: #81C784;
	}
	.edit-btn, .delete-btn {
		height: 30px;
		background-color: #fff;
		border: 1px solid #363636;
		border-radius: 6px;
	}
	.add-button-container {
        display: flex;
        justify-content: center;
        margin-top: 20px;
    }
    .add-btn {
        padding: 10px 15px;
        border: none;
        border-radius: 5px;
        background-color: #ff7f9d;
        color: #fff;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.2);
    }
    .add-btn:hover {
        background-color: #e06b85;
    }
</style>
<body>
    <div class="container">
        <h2>배송지 목록</h2>
        <table class="address-table">
            <thead>
                <tr>
                    <th>배송지</th>
                    <th>우편번호</th>
                    <th>주소</th>
                    <th>기본 배송지</th>
                    <th>수정 · 삭제</th>
                </tr>
            </thead>
            <tbody>
                 <tr>
                     <td>회사</td>
                     <td>12345</td>
                     <td>서울</td>
                     <td><span class="checkmark">✔</span></td>
                     <td>
                         <button class="edit-btn">수정</button>
                         <button class="delete-btn">삭제</button>
                     </td>
                 </tr>
                 <tr>
                     <td>회사</td>
                     <td>12345</td>
                     <td>서울</td>
                     <td><span class="checkmark">✔</span></td>
                     <td>
                         <button class="edit-btn">수정</button>
                         <button class="delete-btn">삭제</button>
                     </td>
                 </tr>
                 <tr>
                     <td>집</td>
                     <td>10045</td>
                     <td>서울</td>
                     <td><span class="checkmark"></span></td>
                     <td>
                         <button class="edit-btn">수정</button>
                         <button class="delete-btn">삭제</button>
                     </td>
                 </tr>
                 <tr>
                     <td>창고</td>
                     <td>15245</td>
                     <td>서울</td>
                     <td><span class="checkmark"></span></td>
                     <td>
                         <button class="edit-btn">수정</button>
                         <button class="delete-btn">삭제</button>
                     </td>
                 </tr>
            </tbody>
        </table>
        <div class="add-button-container">
            <button class="add-btn">+ 배송지 추가</button>
        </div>
    </div>
</body>
</html>
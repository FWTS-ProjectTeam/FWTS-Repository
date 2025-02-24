<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>상품 목록</title>
    <style>
        .container {
            max-width: 800px;
            margin: 20px auto;
            text-align: center;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
        }
        th {
            background-color: #f8f8f8;
        }
        .order-button {
            background-color: #ff6080;
            color: white;
            padding: 5px 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .order-button:hover {
            background-color: #ff4060;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>🛒 상품 목록</h1>

    <table>
        <thead>
            <tr>
                <th>상품 아이디</th>
                <th>상품명</th>
                <th>주문</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="product" items="${productList}">
    <tr>
        <td>${product.proId}</td>
        <td>${product.proName}</td>
        <td>
            <form action="/productDetail" method="get">
                <input type="hidden" name="proId" value="${product.proId}">
                <button type="submit" class="order-button">주문하기</button>
            </form>
        </td>
    </tr>
</c:forEach>

        </tbody>
    </table>
</div>

</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>생화 24 - 고객센터</title>
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
            align-items: center;
            padding: 0px 10px;
            position: relative;
        }
        .header-left {
            display: flex;
            align-items: center;
        }
        .header-right {
            display: flex;
            align-items: center;
        }
        .search-container {
        	width: 240px;
            display: flex;
            align-items: center;
            border: 1px solid #ccc;
            border-radius: 5px;
            padding: 10px;
            font-size: 16px;
            margin-left: 80px;
            background-color: #fff;
        }
        .search-box {
            border: none;
            outline: none;
            flex-grow: 1;
        }
        .nav-container {
            display: flex;
            justify-content: space-between;
            border-top: 1px solid #ccc;
            border-bottom: 1px solid #ccc;
            padding: 20px 10px;
        }
        .nav a {
            font-size: 20px;
            font-weight: bold;
            text-decoration: none;
            color: #333;
            margin-right: 30px;
        }
        .nav-right a {
            text-decoration: none;
            color: #FF748B;
            font-size: 16px;
            font-weight: bold;
            margin-right: 15px;
        }
        .sidebar {
            width: 200px;
            padding: 10px;
            border: 1px solid #ccc;
            background-color: #fff;
            border-radius: 10px;
            margin-right: 20px;
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
            background-color: #ff7f9d;
            color: #fff;
            border-radius: 5px;
        }
        .table-container {
            width: 100%;
            margin-top: 20px;
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
            color: white;
            text-align: center;
        }
        td {
            text-align: center;
        }
        td a {
            text-decoration: none;
            color: #333;
            display: block;
            text-align: left;
        }
        .pagination {
            text-align: center;
            margin-top: 20px;
        }
        .pagination span {
            background-color: #ff7f9d;
            padding: 5px 10px;
            border-radius: 5px;
            color: #fff;
        }
        .header-right a {
            font-size: 13px;
            text-decoration: none;
            color: #333;
            margin-left: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="header-left">
                <h1 style="color:#ff3366; margin-right: 10px;">생화24</h1>
                <div class="search-container">
                    <input class="search-box" type="text" placeholder="찾으시는 꽃을 입력해주세요!">
                </div>
            </div>
            <div class="header-right">
                <a href="/login"><strong>로그인</strong></a>
                <a href="/sign-up">회원가입</a>
            </div>
        </div>
        <div class="nav-container">
            <div class="nav">
                <a href="#">☰</a><a href="#">절화</a>
                <a href="#">난</a>
                <a href="#">관엽</a>
                <a href="#">기타</a>
            </div>
            <div class="nav-right">
                <a href="#">마이페이지</a>
                <a href="#">고객센터</a>
            </div>
        </div>
        <div style="display: flex; margin-top: 20px;">
            <div class="sidebar">
                <h2>고객센터</h2>
                <a href="#" class="active"><strong>공지사항</strong></a>
                <a href="#">문의사항</a>
            </div>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>번호</th>
                            <th>제목</th>
                            <th>작성일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>3</td>
                            <td><a href="#">[이벤트] 첫 구매 10% 할인 쿠폰 증정</a></td>
                            <td>2025.01.17</td>
                        </tr>
                        <tr>
                            <td>2</td>
                            <td><a href="#">[중요] 시스템 점검 일정 안내 (1월 20일)</a></td>
                            <td>2025.01.17</td>
                        </tr>
                        <tr>
                            <td>1</td>
                            <td><a href="#">[가이드] 초보자를 위한 도매 거래 꿀팁</a></td>
                            <td>2025.01.17</td>
                        </tr>
                    </tbody>
                </table>
                <div class="pagination">
                    <span>1</span>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
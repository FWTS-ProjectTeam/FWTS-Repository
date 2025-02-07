<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
            border-top: 1px solid #ccc;
            border-bottom: 1px solid #ccc;
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
        	margin: 20px 20px 0px 20px;
        }
        .sidebar {
            width: 200px;
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
	    /* 이름 바꿔서 사용 */
        .table-container {
            width: 100%;
            margin: 20px 10px 0px 10px;
        }
        /* 화면 추가 - 시작 */
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
        /* 화면 추가 - 종료 */
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
                <h2>마이페이지</h2>
                <a href="#" class="active">내 정보 관리</a>
                <a href="#">장바구니</a>
                <a href="#">주문 내역</a>
                <a href="#">문의 내역</a>
            </div>
            
            <!-- 이름 바꿔서 사용 -->
            <div class="table-container">
            	<!-- 화면 추가 -->
            </div>
        </div>
    </div>
</body>
</html>
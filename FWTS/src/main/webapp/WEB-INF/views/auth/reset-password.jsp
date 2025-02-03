<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String email = (String) request.getAttribute("email");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>생화24 - 비밀번호 재설정</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #fff;
            color: #333;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .find-container {
            text-align: center;
            max-width: 400px;
            width: 100%;
            background-color: #fefefe;
            border: 1px solid #ddd;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        .find-container h1 {
            color: #ff6699;
            font-weight: 600;
            margin-bottom: 15px;
        }
        .description {
            font-size: 14px;
            color: #666;
            margin-bottom: 20px;
        }
        .input-group {
            width: 100%;
            text-align: left;
            margin-bottom: 20px;
        }
        .input-group label {
            font-size: 14px;
            font-weight: 600;
            display: block;
            margin-bottom: 5px;
        }
        .input-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            outline: none;
            transition: border-color 0.3s;
            box-sizing: border-box;
        }
        .input-group input:focus {
            border-color: #ff6699;
        }
        .button-container {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .button-container button {
            width: 100%;
            padding: 12px;
            font-size: 16px;
            font-weight: 600;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .btn-primary {
            background-color: #ff6699;
            color: #fff;
        }
        .btn-primary:hover {
            background-color: #ff5577;
        }
        .btn-secondary {
            background-color: #ddd;
            color: #333;
        }
        .btn-secondary:hover {
            background-color: #bbb;
        }
        .error-message {
            color: red;
            font-size: 14px;
            margin-bottom: 10px;
        }
        .links-container {
            margin-top: 20px;
            font-size: 14px;
        }
        .links-container a {
            text-decoration: none;
            color: #555;
            font-weight: 600;
        }
    </style>
    <script>
        function validateForm() {
            var password = document.getElementById("password").value;
            var confirmPassword = document.getElementById("confirmPassword").value;
            var errorMessage = document.getElementById("error-message");

            if (password.length < 6) {
                errorMessage.textContent = "비밀번호는 최소 6자리 이상이어야 합니다.";
                return false;
            }
            if (password !== confirmPassword) {
                errorMessage.textContent = "비밀번호가 일치하지 않습니다.";
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
    <div class="find-container">
        <h1>비밀번호 재설정</h1>
        <p class="description">
            <% if (email != null) { %>
                <strong><%= email %></strong> 계정의 새 비밀번호를 설정하세요.
            <% } else { %>
                새 비밀번호를 입력하세요.
            <% } %>
        </p>

        <form action="/find-account/reset-password" method="post" onsubmit="return validateForm()">
            <input type="hidden" name="email" value="<%= email %>">
            
            <div class="input-group">
                <label for="password">새 비밀번호</label>
                <input type="password" id="password" name="password" placeholder="새 비밀번호를 입력하세요" required>
            </div>

            <div class="input-group">
                <label for="confirmPassword">비밀번호 확인</label>
                <input type="password" id="confirmPassword" name="confirmPassword" placeholder="비밀번호를 다시 입력하세요" required>
            </div>

            <p class="error-message" id="error-message"></p>

            <div class="button-container">
                <button type="submit" class="btn-primary">비밀번호 변경</button>
            </div>
        </form>

        <div class="links-container">
            <a href="/login">로그인으로 돌아가기</a>
        </div>
    </div>
</body>
</html>
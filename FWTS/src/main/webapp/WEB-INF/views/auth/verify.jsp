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
    <title>생화24 - 인증 코드 입력</title>
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
            position: relative;
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
		.input-container {
		    display: flex;
		    align-items: center;
		    gap: 10px; /* 입력 필드와 버튼 사이 여백 */
		}
		.input-container input {
		    flex: 1; /* 입력 필드가 남은 공간을 다 차지하도록 */
		    padding: 12px;
		    border: 1px solid #ddd;
		    border-radius: 6px;
		    font-size: 14px;
		    outline: none;
		    transition: border-color 0.3s;
		    box-sizing: border-box;
		}
		.input-container input:focus { border-color: #ff6699; }
		.resend-code {
		    padding: 8px 12px;
		    font-size: 12px;
		    font-weight: bold;
		    color: #fff;
		    background-color: #ffb6c1;
		    cursor: pointer;
		    border: none;
		    border-radius: 6px;
		    white-space: nowrap;
		    transition: background-color 0.3s;
		}
		.resend-code:hover { background-color: #ff9aa2; }
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
        function resendCode() {
            alert("인증 코드가 다시 전송되었습니다.");
            // 실제 코드 전송 로직을 Ajax로 구현 가능
        }
    </script>
</head>
<body>
    <div class="find-container">
        <h1>이메일 인증</h1>
        <p class="description">
            <strong><%= email %></strong>로 인증 코드를 전송했습니다.
        </p>

        <form action="/find-account/reset-password" method="get">
            <input type="hidden" name="email" value="<%= email %>">
            
            <div class="input-group">
			    <label for="code">인증 코드</label>
			    <div class="input-container">
			        <input type="text" id="code" name="code" placeholder="6자리 인증 코드를 입력하세요" required>
			        <button type="button" class="resend-code" onclick="resendCode()">재전송</button>
			    </div>
			</div>

            <div class="button-container">
                <button type="submit" class="btn-primary">확인</button>
            </div>
        </form>

        <div class="links-container">
            <a href="/find-account/password">이전으로 돌아가기</a>
        </div>
    </div>
</body>
</html>
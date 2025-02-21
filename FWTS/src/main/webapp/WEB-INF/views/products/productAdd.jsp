<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>생화24 - 상품 등록</title>
<link rel="stylesheet" href="/resources/css/common.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript" src="/smarteditor/js/HuskyEZCreator.js"
	charset="utf-8"></script>
<style>
.body-container {
	display: flex;
	flex-direction: column;
	width: 80%;
	margin: 0 auto;
}

.pro-info1 {
	display: flex;
	flex-direction: row;
	width: 100%;
	margin: 0 auto;
}

.img-container {
	width: 30%;
	height: 300px;
}

.img {
	width: 100%;
	height: 300px;
	display: flex;
	justify-content: center;
	align-items: center;
	background-color: #f0f0f0; /* 이미지가 없을 때 '이미지가 없습니다' 텍스트 표시용 */
	overflow: hidden;
	position: relative; /* :before를 중앙에 배치하려면 필요 */
	margin-top: 30px;
	margin-bottom: 10px;
}

.img:before {
	content: "이미지가 없습니다";
	color: #666;
	font-size: 16px;
	font-weight: bold;
	position: absolute; /* 부모 중앙에 텍스트 배치 */
	text-align: center;
	width: 100%;
	height: 300px;
	display: flex;
	justify-content: center;
	align-items: center;
	margin-top: 30px;
	margin-bottom: 10px;
}

img {
	width: 100%;
	height: 100%;
	object-fit: cover; /* 이미지 비율 유지하며 크기에 맞게 자르기 */
}

.pro-detail {
	display: flex;
	flex-direction: column;
	justify-content: space-between;
	width: 70%;
	height: 70%;
	margin: 0px 0px 0px 40px;
}

.pro-detail1 {
	display: flex;
	flex-direction: row;
	justify-content: space-between;
	width: 100%;
	margin: 0px 300px 0px 0px;
	border-bottom: 3px solid var(--main4);
}

.pro-detail2 {
	display: flex;
	flex-direction: column;
	width: 100%;
}

.pro-info2 {
	width: 100%;
	margin-top: 50px;
	margin-bottom: 100px;
}

.description-title {
	background-color: var(--main4);
	padding: 5px 10px;
	color: white; /* 텍스트 색상 */
	font-weight: bold;
}

.post-form {
	width: 100%;
	margin: 50px 10px 0 10px;
	background: white;
	display: block;
}

.post-content {
	padding: 20px;
	border-top: 1px solid #ccc;
	border-bottom: 1px solid #ccc;
}

.post-content .title {
	width: 100%;
	padding: 10px;
	font-size: 24px;
	border: 1px solid #ccc;
	outline: none;
	font-weight: 600;
	margin-bottom: 16px;
	box-sizing: border-box;
}

.post-content textarea {
	width: 99.6%;
	box-sizing: border-box; /* 패딩을 포함해 전체 너비 100%로 설정 */
}

.button-container {
	width: 100%;
	display: flex;
	justify-content: center; /* 버튼 중앙 정렬 */
	gap: 20px; /* 버튼 간격을 설정 */
	margin: 50px 0;
}

.button-container .btn1 {
	background-color: var(--main3);
	color: #fff;
	padding: 10px 40px;
	border: 1px solid var(--main3);
	border-radius: 5px;
	cursor: pointer;
}

.button-container .btn2 {
	background-color: #fff;
	color: var(--main4);
	padding: 10px 40px;
	border: 1px solid var(--main4);
	border-radius: 5px;
	cursor: pointer;
}

.button-container .btn1:hover {
	background-color: var(--main4);
	color: #fff;
	padding: 10px 40px;
	border: 1px solid var(--main4);
	border-radius: 5px;
	cursor: pointer;
}

.button-container .btn2:hover {
	background-color: var(--main4);
	color: #fff;
	padding: 10px 40px;
	border: 1px solid var(--main4);
	border-radius: 5px;
	cursor: pointer;
}
</style>

</head>
<body>
	<div class="container">
		<!-- 공통 -->
		<%@ include file="/WEB-INF/views/common/header.jsp"%>
		<div class="body-container">
			<div class="product-container">
				<h1>상품 등록</h1>
				<div class="pro-info1">
					<div class="img-container">
						<div class="img">
							<img src="${product.imgPath}">
						</div>
						<input type="file" name="productImage" accept="image/*">
					</div>
					<div class="pro-detail">
						<div class="pro-detail1">
							<h3>${userDetails.companyName }</h3>
							<p>상품 ID는 상품 등록 시 자동 생성됩니다 :)</p>
						</div>
						<div class="pro-detail2">
							<p>
								상품명: <input type="text" name="proName"
									value="${product.proName}">
							</p>
							<p>
								판매 상태: <select name="isSales">
									<option value="true" ${product.isSales() ? 'selected' : ''}>판매
										중</option>
									<option value="false" ${!product.isSales() ? 'selected' : ''}>판매
										중지</option>
								</select>
							</p>
							<p>
								최소 구매 가능 수량: <input type="number" name="minPossible"
									value="${product.minPossible}">
							</p>
							<p>
								최대 구매 가능 수량: <input type="number" name="maxPossible"
									value="${product.maxPossible}">
							</p>
							<p>
								재고: <input type="number" name="inventory"
									value="${product.inventory}">
							</p>
							<p>
								가격: <input type="number" name="unitPrice"
									value="${product.unitPrice}">
							</p>
							<p>
								카테고리: <select name="category">
									<option value="절화"
										${product.categoryId == '1' ? 'selected' : ''}>절화</option>
									<option value="관엽"
										${product.categoryId == '2' ? 'selected' : ''}>관엽</option>
									<option value="난"
										${product.categoryId == '3' ? 'selected' : ''}>난</option>
									<option value="기타"
										${product.categoryId == '4' ? 'selected' : ''}>기타</option>
								</select>
							</p>
						</div>
					</div>
				</div>
				<div class="pro-info2">
					<p class="description-title">상품 설명</p>
					<div class="post-content">
						<div id="smarteditor">
							<textarea id="content" name="description" rows="20"></textarea>
						</div>
					</div>
				</div>

				<form id="productForm" method="POST" action="/add">
					<div class="button-container">
						<button type="button" class="btn1" onclick="confirmCancle()">취소</button>
						<button type="submit" class="btn2" onclick="confirmAdd()">등록</button>
					</div>
				</form>
			</div>
		</div>
		<%@ include file="/WEB-INF/views/common/footer.jsp"%>
	</div>
	<script>
		var oEditors = [];

		// 스마트 에디터 초기화 함수
		smartEditor = function() {
			nhn.husky.EZCreator
					.createInIFrame({
						oAppRef : oEditors,
						elPlaceHolder : "content", // 텍스트 영역 ID
						sSkinURI : "/smarteditor/SmartEditor2Skin.html", // 스마트 에디터 스킨 경로
						fOnAppLoad : function() {
							// 에디터 로딩 후 기존 내용 설정 (서버에서 넘어온 내용을 에디터에 삽입)
							const content = "${inquiry.inquiryContent}";
							oEditors.getById["content"].exec("PASTE_HTML",
									[ content ]);
						},
						fCreator : "createSEditor2"
					});
		};

		// 문서 준비되었을 때 실행
		$(document).ready(function() {
			smartEditor(); // 스마트 에디터 실행
		});

		// 스마트 에디터 내용 전송
		function submitPostForm() {
			const form = document.getElementById("post-form");

			// 스마트 에디터 내용 업데이트
			oEditors.getById["content"].exec("UPDATE_CONTENTS_FIELD", []);

			// 폼 제출
			form.requestSubmit();
		}

		// 유효성 검사 실패 시 alert
		<c:if test="${not empty validMessage}">
		alert("${validMessage}");
		</c:if>

		// 서버 오류 발생 시 Swal 알림
		<c:if test="${not empty errorMessage}">
		Swal.fire({
			icon : 'error',
			title : '서버 오류',
			text : "${errorMessage}",
			confirmButtonColor : '#d33',
			confirmButtonText : '확인'
		});
		</c:if>

		// 취소 버튼
		function confirmCancle() {
			window.location.href = "/products/shopM/1";
		}

		// 등록 버튼 
		function confirmAdd() {
			const isConfirmed = confirm(`상품을 등록하시겠습니까?`);
			if (isConfirmed) {
				document.getElementById("productForm").submit(); // 폼 제출
			}
		}
	</script>

</body>
</html>


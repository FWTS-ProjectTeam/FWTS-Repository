<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>생화24 - 상품수정</title>
<link rel="stylesheet" href="/resources/css/common.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
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

.img-container{
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
	margin-top:30px;
	margin-bottom:10px;
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
	margin-top:30px;
	margin-bottom:10px;
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

.status {
	display: inline;
	padding: 5px 10px;
	border: 2px solid var(--main4);
	border-radius: 12px;
	color: var(--main4);
	font-weight: bold;
	text-align: center;
}

.status.available {
	background-color: var(--main5);
}

.status.sold-out {
	background-color: transparent; /* 배경색 없앰 */
	color: #999; /* 텍스트 색상 변경 */
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
   		<%@ include file="/WEB-INF/views/common/header.jsp" %>
		<div class="body-container">
			<div class="product-container">
				<h1>상품 수정</h1>
				<form method="POST" action="/products/update/${product.proId}"
					enctype="multipart/form-data">
					<div class="pro-info1">
						<div class="img-container">
						<div class="img">
							<img src="${product.imgPath}">
						</div>
							<input type="file" name="productImage" accept="image/*">
						</div>
						<div class="pro-detail">
							<div class="pro-detail1">
								<h3>A플라워(수정필요)</h3>
								<p>상품 ID: ${product.proId}</p>
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
									</select>
								</p>
							</div>
						</div>
					</div>
					<div class="pro-info2">
						<p class="description-title">상품 설명</p>
						<p><textarea name="proName" style="width: 100%; height: 300px; overflow-y: auto; padding: 0; line-height: 1.5; vertical-align: top;">
  ${product.description}</textarea></p>
  					</div>
					<div class="button-container">
						<button class="btn1" type="submit">수정 완료</button>
					</div>
				</form>
			</div>
		</div>
		<%@ include file="/WEB-INF/views/common/footer.jsp"%>
	</div>

</body>
</html>


<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>생화24 - 상품수정</title>
<link rel="stylesheet" href="/resources/css/common.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
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
	margin-top: 30px; margin-bottom : 10px;
	z-index: 1;
	margin-bottom: 10px;
}

img {
	width: 100%;
	height: 100%;
	object-fit: cover; /* 이미지 비율 유지하며 크기에 맞게 자르기 */
	z-index: 2;
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

.button-container .btn1:hover {
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
				<h1>상품 수정</h1>
				<form id="updateForm" method="post" enctype="multipart/form-data"
					onsubmit="submitForm(event, '${product.proId}')">
					<div class="pro-info1">
						<div class="img-container">
							<div class="img">
								<img src="${product.imgPath}">
							</div>
							<input type="file" name="productImage" accept="image/*">
						</div>
						<div class="pro-detail">
							<div class="pro-detail1">
								<h3>${userDetails.companyName}</h3>
								<p>상품 ID: ${product.proId}</p>
							</div>
							<div class="pro-detail2">
								<p>
									상품명: <input type="text" name="proName" id="proName"
										value="${product.proName}">
								</p>

								<label for="isSales">판매 상태:<select name="isSales"
									id="isSales">
									<option value="1" ${product.sales ? 'selected' : ''}>판매
										중</option>
									<option value="0" ${!product.sales ? 'selected' : ''}>판매
										중지</option>
								</select></label>

								<p>
									최소 구매 가능 수량: <input type="number" name="minPossible"
										id="minPossible" value="${product.minPossible}">
								</p>
								<p>
									최대 구매 가능 수량: <input type="number" name="maxPossible"
										id="maxPossible" value="${product.maxPossible}">
								</p>
								<p>
									재고: <input type="number" name="inventory" id="inventory"
										value="${product.inventory}">
								</p>
								<p>
									가격: <input type="number" name="unitPrice" id="unitPrice"
										value="${product.unitPrice}">
								</p>
								<p>
									배송비: <input type="number" name="deliveryFee" id="deliveryFee"
										value="${product.deliveryFee}">
								</p>
								<label for="categoryId">카테고리:<select name="categoryId"
									id="categoryId">
										<option value="1" ${product.categoryId == 1 ? 'selected' : ''}>절화</option>
										<option value="2" ${product.categoryId == 2 ? 'selected' : ''}>관엽</option>
										<option value="3" ${product.categoryId == 3 ? 'selected' : ''}>난</option>
										<option value="4" ${product.categoryId == 4 ? 'selected' : ''}>기타</option>
								</select></label>
							</div>
						</div>
					</div>
					<div class="pro-info2">
						<p class="description-title">상품 설명</p>
						<p>
							<textarea name="description"
								style="width: 100%; height: 300px; overflow-y: auto; padding: 0; line-height: 1.5; vertical-align: top;">
  ${product.description}</textarea>
						</p>
					</div>
					<div class="button-container">
						<button class="btn1" type="button"
							onclick="submitForm(event, '${product.proId}')">수정 완료</button>
					</div>
				</form>
			</div>
		</div>
		<%@ include file="/WEB-INF/views/common/footer.jsp"%>
	</div>
	<script>
	function submitForm(event, id) {
	    event.preventDefault(); // 기본 폼 제출 방지 (페이지 이동 방지)

	    const form = document.getElementById("updateForm");
	    if (!form) {
	        alert("폼이 존재하지 않습니다.");
	        return;
	    }

	    const formData = new FormData(form);
	    const proName = formData.get("proName") || "상품";
	    const isConfirmed = confirm(`\${formData.get("isSales")} \${proName} 상품을 수정하시겠습니까?`);
	    
	    if (!isConfirmed) {
	        console.log("사용자가 취소함");
	        return; // 사용자가 취소하면 아무것도 하지 않음
	    }

	    fetch(`/products/update/${id}`, {
	        method: "PUT",
	        body: formData,
	        headers: {
	            "Accept": "application/json"
	        }
	    })
	    .then(response => {
	        if (!response.ok) {
	            throw new Error("서버 응답이 올바르지 않습니다.");
	        }
	        return response.json();
	    })
	    .then(data => {
	        alert("수정이 완료되었습니다.");
	        location.href = `/products/sell/${product.proId}`;
	    })
	    .catch(error => {
	        console.error("수정 중 오류 발생:", error);
	        alert("서버 오류로 인해 수정에 실패했습니다.");
	    });
	}
</script>
</body>
</html>
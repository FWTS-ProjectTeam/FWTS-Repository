<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>생화24</title>
<link rel="stylesheet" href="/resources/css/common.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<style>
	.body-container {
        flex-direction: column;
        margin: 30px;
        gap: 20px;
    }
    
	.top-section {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .banner {
        width: 64%;
        height: 200px;
        object-fit: contain;
        border-radius: 8px;
        background-color: #f0f0f0;
    }
    
    .notice {
        width: 30%;
        height: 200px;
        background-color: #fff;
        padding: 5px 12px;
        border: 1px solid #ddd;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }
    .notice ul {
    	display: flex;
	    flex-direction: column;
	    gap: 10px;
	    list-style: none;
	    padding: 0 10px;
	}
	.notice li {
	    display: flex;
	}
	.notice span {
	    color: var(--main4);
	    margin-right: 10px;
	    flex-shrink: 0;
	}
	.notice a {
	    color: #333;
	    text-decoration: none;
	    flex-grow: 1;
	    white-space: nowrap;
	    overflow: hidden;
	}
    
    .hot-items {
    	width: 100%;
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	    margin-top: 30px;
	    gap: 20px;
	}
	.hot-items h2 {
	    font-size: 40px;
	    font-weight: bold;
	    letter-spacing: 5px;
	    margin: 0;
	    color: #333;
	}
	
	.item-list {
	    display: flex;
	    gap: 20px;
	}
	.item img {
	    width: 160px;
		height: 160px;
		border-radius: 5px;
		background-color: #f2f2f2;
		display: block;
		object-fit: cover;
	}
	.item p {
	    margin-top: 10px;
	    font-size: 16px;
	}
	
	.price {
	    font-weight: bold;
	    color: var(--main1);
	}
	
	/* 그래프 */
	.flower-prices {
    	width: 100%;
    	text-align: center;
    }
    
    /* 탭 */
	.tab-list {
	    display: flex;
	    justify-content: center;
	    list-style: none;
	    padding: 0;
	    margin: 10px 0;
	}
	.tab-item {
	    padding: 10px 20px;
	    cursor: pointer;
	    border: 1px solid #ddd;
	    border-radius: 6px;
	    background-color: #f5f5f5;
	    margin-right: 5px;
	}
	.tab-item:hover {
		background-color: var(--main3);
	    color: white;
	}
	.tab-item.active {
		border: 1px solid #ff7f9d;
	    background-color: #ff7f9d;
	    color: white;
	    font-weight: bold;
	}
	
	/* 탭 콘텐츠 */
	.tab-panel {
	    display: none;
	    padding: 15px;
	    background: #f9f9f9;
	    border: 1px solid #ddd;
	    margin-top: 10px;
	    height: 500px;
	}
	.tab-panel.active {
	    display: block;
	}
	
	.price-chart {
	    position: relative;
	    width: 100%;
	    height: 100%;
	}
	.price-chart canvas {
		margin: auto;
        width: 100%;
        height: 100%;
    }
    .error {
	    position: absolute;
	    top: 50%;
	    left: 50%;
	    transform: translate(-50%, -50%);
	    color: gray;
	    font-size: 18px;
	}
	
	/* 로딩 애니메이션 */
	.loading {
		position: relative;
	    top: 50%;
	    left: 50%;
	    color: #333;
	    z-index: 9999; /* 다른 요소들 위에 오게 하기 */
        border: 6px solid rgba(255, 255, 255, 0.3);
        border-top: 6px solid #3498db;
        border-radius: 50%;
        width: 30px;
        height: 30px;
        animation: spin 1s linear infinite;
    }
    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }
</style>
<body>
<div class="container">
	<!-- 공통 -->
	<%@ include file="/WEB-INF/views/common/header.jsp"%>
	
	<div class="body-container">
        <div class="top-section">
            <img class="banner" src="/resources/img/banner.png" alt="배너">
            
            <div class="notice">
                <h2>공지사항</h2>
                <ul>
                	<c:forEach var="notice" items="${notices}">
			            <li>
		                	<span><fmt:formatDate value="${notice.createdDate}" pattern="yyyy.MM.dd" /></span>
		                	<a href="/support-center/notices/${notice.noticeId}">${notice.noticeTitle}</a>
		                </li>
        			</c:forEach>
                </ul>
            </div>
        </div>
        
        <section class="hot-items">
        	<h2>HOT!</h2>
            <div class="item-list">
                <div class="item">
                    <img src="" alt="해바라기">
                    <p>해바라기 <span class="price">3,000원</span></p>
                </div>
                <div class="item">
                    <img src="" alt="튤립">
                    <p>튤립 <span class="price">1,500원</span></p>
                </div>
                <div class="item">
                    <img src="" alt="백합">
                    <p>백합 <span class="price">5,600원</span></p>
                </div>
                <div class="item">
                    <img src="" alt="캐모마일">
                    <p>캐모마일 <span class="price">3,200원</span></p>
                </div>
                <div class="item">
                    <img src="" alt="장미">
                    <p>장미 <span class="price">12,000원</span></p>
                </div>
            </div>
        </section>
        
        <section class="flower-prices">
		    <h2>최근 3일 꽃 거래 동향</h2>
		
		    <!-- 탭 메뉴 -->
		    <ul class="tab-list">
			    <li class="tab-item active" data-tab="cut-flower">절화</li>
			    <li class="tab-item" data-tab="orchid">난</li>
			    <li class="tab-item" data-tab="foliage">관엽</li>
			</ul>
			
			<!-- 그래프 영역 -->
			<div class="tab-content">
			    <div class="tab-panel active" id="cut-flower">
			        <div class="price-chart">
			            <div class="loading" id="cut-flower-loading"></div>
			            <canvas id="cut-flower-chart"></canvas>
			            <p class="error" id="cut-flower-error"></p>
			        </div>
			    </div>
			    <div class="tab-panel" id="orchid">
			        <div class="price-chart">
			            <div class="loading" id="orchid-loading"></div>
			            <canvas id="orchid-chart"></canvas>
			            <p class="error" id="orchid-error"></p>
			        </div>
			    </div>
			    <div class="tab-panel" id="foliage">
			        <div class="price-chart">
			            <div class="loading" id="foliage-loading"></div>
			            <canvas id="foliage-chart"></canvas>
			            <p class="error" id="foliage-error"></p>
			        </div>
			    </div>
			</div>
		</section>
    </div>
	
	<!-- 푸터 -->
	<%@ include file="/WEB-INF/views/common/footer.jsp"%>
</div>
<script>
	document.addEventListener("DOMContentLoaded", function () { 
	    // 페이지 로드 후 데이터 로드
	    loadAllFlowerData();
	
	    // 탭 클릭 이벤트 추가
	    document.querySelectorAll(".tab-item").forEach(tab => { 
	        tab.addEventListener("click", function () { 
	            const tabId = tab.getAttribute("data-tab"); 
	
	            // 모든 탭에서 active 제거 후 클릭한 탭에 추가 
	            document.querySelectorAll(".tab-item").forEach(t => t.classList.remove("active")); 
	            tab.classList.add("active"); 
	
	            // 모든 패널 숨기고 클릭한 탭의 패널만 표시 
	            document.querySelectorAll(".tab-panel").forEach(panel => panel.classList.remove("active")); 
	            document.getElementById(tabId).classList.add("active"); 
	
	            // 해당 탭에 맞는 그래프 로드
	            loadGraphData(tabId); 
	        }); 
	    });
	
	    // 초기 로딩 시 "절화" 탭의 그래프 로드
	    loadGraphData("cut-flower"); 
	});

	// 초기 데이터 로드
	var allFlowerData = {}; // 데이터를 저장할 변수
	
	function loadAllFlowerData() {
	    fetch("/flower-prices")  // 서버에서 데이터를 한 번에 가져오는 API 호출
        .then(response => response.json())
        .then(data => {
            allFlowerData = data;
            loadGraphData("cut-flower");
        })
        .catch(error => {
        	allFlowerData = { "errorMessage": "데이터를 가져오는 데 문제가 발생했습니다." };
        	loadGraphData("cut-flower");
        });
	}

	// 그래프 그리기
	function drawGraph(data, tabId, chartId) {	   
		if (data.errorMessage) {
			document.getElementById(tabId + "-error").innerText = data.errorMessage;
	        document.getElementById(tabId + "-loading").style.display = "none";
	        return;
		}
		
	    // 데이터가 없으면 메시지 표시
	    if (!data || Object.keys(data).length === 0) {
	    	document.getElementById(tabId + "-error").innerText = "데이터가 없습니다.";
	        document.getElementById(tabId + "-loading").style.display = "none";
	        return;
	    }
	
	    document.getElementById(tabId + "-error").innerText = "";
	    
	 	// 기존 차트가 있으면 삭제
	    var existingChart = Chart.getChart(chartId);
	    if (existingChart) {
	        existingChart.destroy();
	    }
	    
	    var ctx = document.getElementById(chartId).getContext('2d'); 
	    var labels = Object.keys(data);
	    var prices = labels.map(label => data[label].avgPrice);
	    var quantities = labels.map(label => data[label].totalQty);
	
	    var chart = new Chart(ctx, {
	        type: 'bar',
	        data: {
	            labels: labels,
	            datasets: [
	                {
	                    label: '판매량',
	                    data: quantities,
	                    type: 'line',
	                    borderColor: 'rgba(255, 99, 132, 1)',
	                    backgroundColor: 'rgba(255, 99, 132, 0.2)',
	                    borderWidth: 2,
	                    yAxisID: 'y2'
	                },
	                {
	                    label: '평균가',
	                    data: prices,
	                    backgroundColor: 'rgba(75, 192, 192, 0.5)',
	                    borderColor: 'rgba(75, 192, 192, 1)',
	                    borderWidth: 1,
	                    yAxisID: 'y1'
	                }
	            ]
	        },
	        options: {
	            responsive: true,
	            scales: {
	                x: {
	                    display: false
	                },
	                y1: {
	                    type: 'linear',
	                    position: 'left',
	                    beginAtZero: true,
	                    title: { display: true, text: '판매량 (개)' },
	                    grid: { drawOnChartArea: false }
	                },
	                y2: {
	                    type: 'linear',
	                    position: 'right',
	                    beginAtZero: true,
	                    title: { display: true, text: '평균가 (원)' }
	                }
	            }
	        }
	    });
	    
	    document.getElementById(tabId + "-loading").style.display = "none";
	}

	// 탭에 맞는 그래프 그리기
	function loadGraphData(tabId) {
	    var data;

	    // 해당 탭에 맞는 데이터 로드
	    if (allFlowerData.errorMessage) {
	    	data = allFlowerData;
	    } else if (tabId === "cut-flower") {
	        data = allFlowerData.cutFlower;
	    } else if (tabId === "orchid") {
	        data = allFlowerData.orchid;
	    } else if (tabId === "foliage") {
	        data = allFlowerData.foliage;
	    }
	
	    if (data) {
	        drawGraph(data, tabId, tabId + "-chart");
	    }
	}
</script>
</body>
</html>
package com.teamf.fwts.controller;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.teamf.fwts.dto.OrderDetail;
import com.teamf.fwts.dto.OrderList;
import com.teamf.fwts.service.SellerOrderService;
import com.teamf.fwts.service.UserService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor // private final 자동 추가
@RequestMapping("/seller")
public class SellerOrderController { // 판매자 - 주문 관리
	private final SellerOrderService orderService;
	private final UserService userService;
	
	// 주문 목록 조회
	@GetMapping("/orders")
	public String getOrderList(
	        @RequestParam(value = "page", defaultValue = "1") int page, // ✅ 기본값 1 (첫 페이지)
	        @RequestParam(value = "keyword", required = false) String keyword,
	        Model model) {
		
		 Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	        if (authentication == null || !authentication.isAuthenticated()) {
	            return "redirect:/login"; // 로그인하지 않은 경우
	        }
	        
	        String username = authentication.getName();
	        int sellerId = userService.findByUsername(username).getUserId();
	        
	        int pageSize = 10; // 페이지당 표시할 주문 수
	        int offset = (page - 1) * pageSize; 
		
	        // ✅ 검색어가 있으면 검색 + 페이징, 없으면 전체 조회 + 페이징
	        List<OrderList> orderList = orderService.getOrdersWithPagination(sellerId, keyword, offset, pageSize);
	        int totalOrders = orderService.getTotalOrderCount(sellerId, keyword); // 전체 주문 개수 (검색 포함)

	        int totalPages = (int) Math.ceil((double) totalOrders / pageSize);
	        
	        // JSP로 데이터 전달
	        model.addAttribute("orderList", orderList);
	        model.addAttribute("currentPage", page);
	        model.addAttribute("totalPages", totalPages);
	        model.addAttribute("tKeyword", keyword); // 검색어 유지
	        return "order/seller/orders";
	}
    
    // ✅ 주문 상세 조회
    @GetMapping("/orderDetail")
    public String getOrderDetail(@RequestParam("orderNum") String orderNum, Model model) {
    	OrderDetail orderDetail = orderService.getOrderWithProducts(orderNum);
    	model.addAttribute("order", orderDetail);
    	
    	return "order/seller/order-detail";
    }
    
    // @ResponseBody를 이용해 JSON 형식의 데이터 반환
    
    // ✅ 주문 상태 및 배송 정보 한꺼번에 업데이트 (JSON 응답)
    @PostMapping("/updateOrderInfo")
    @ResponseBody
    public ResponseEntity<String> updateOrderInfo(
            @RequestParam("orderNum") String orderNum,
            @RequestParam(value = "orderState", required = false) Integer orderState,
            @RequestParam(value = "courier", required = false) String courier,
            @RequestParam(value = "shipmentNum", required = false) String shipmentNum) {

        try {
            // ✅ 주문 상태 변경 (orderState가 null이 아닐 경우에만 실행)
            if (orderState != null) {
                orderService.updateOrderState(orderNum, orderState);
            }

            // ✅ 배송 정보 변경 (둘 다 null이 아닐 경우 실행)
            if (courier != null && shipmentNum != null) {
                orderService.updateShipmentInfo(orderNum, courier, shipmentNum);
            }

            return ResponseEntity.ok("✅ 주문 정보가 성공적으로 업데이트되었습니다.");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                 .body("⚠ 주문 정보 업데이트 실패");
        }
    }
    
    // ✅ 엑셀 다운로드 기능
    @GetMapping("/downloadExcel")
    public ResponseEntity<byte[]> downloadOrdersExcel() throws IOException {
        // ✅ 현재 로그인한 사용자 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }

        // ✅ 로그인된 사용자 ID 조회
        String username = authentication.getName();
        int sellerId = userService.findByUsername(username).getUserId(); 

        // ✅ 해당 사용자의 주문 내역만 가져오기
        List<OrderDetail> orderList = orderService.getAllOrdersForExcel(sellerId);

        // ✅ 엑셀 파일 생성
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("판매 내역");

        // ✅ 헤더 행 생성
        Row headerRow = sheet.createRow(0);
        String[] columns = {"주문번호", "주문 날짜", "상품 ID", "상품명", "구매수량", "총 가격", "구매 업체"};

        // ✅ 헤더 스타일 적용
        CellStyle headerStyle = createHeaderStyle(workbook);
        for (int i = 0; i < columns.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(columns[i]);
            cell.setCellStyle(headerStyle);
        }

        // ✅ 데이터 추가
        int rowNum = 1;
        for (OrderDetail order : orderList) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(order.getOrderNum());
            row.createCell(1).setCellValue(order.getOrderDate().toString());
            row.createCell(2).setCellValue(order.getProId());
            row.createCell(3).setCellValue(order.getProName());
            row.createCell(4).setCellValue(order.getPurchaseQuantity());
            row.createCell(5).setCellValue(order.getTotalPrice());
            row.createCell(6).setCellValue(order.getCompanyName());
        }

        // ✅ 엑셀 파일을 byte[]로 변환
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        workbook.write(outputStream);
        workbook.close();

        byte[] excelData = outputStream.toByteArray();

        // ✅ HTTP 응답 헤더 설정
        HttpHeaders headers = new HttpHeaders();
        headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=order_list.xlsx");
        headers.add(HttpHeaders.CONTENT_TYPE, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");

        return ResponseEntity.ok()
                .headers(headers)
                .body(excelData);
    }

    // ✅ 엑셀 헤더 스타일 설정
    private CellStyle createHeaderStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setBold(true);
        style.setFont(font);
        style.setAlignment(HorizontalAlignment.CENTER);
        return style;
    }
}
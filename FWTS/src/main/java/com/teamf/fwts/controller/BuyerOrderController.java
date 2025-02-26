package com.teamf.fwts.controller;

import com.teamf.fwts.dto.OrderList;
import com.teamf.fwts.dto.OrderDetail;
import com.teamf.fwts.dto.OrderDto;
import com.teamf.fwts.service.BuyerOrderService;
import com.teamf.fwts.service.UserService;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.ByteArrayOutputStream;
import java.io.IOException;

import lombok.RequiredArgsConstructor;

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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequiredArgsConstructor // private final 자동 추가
@RequestMapping("/buyer")
public class BuyerOrderController { // 구매자 - 주문 및 배송 조회
    private final BuyerOrderService orderService;
    private final UserService userService;
    
    // 상품 주문
    @GetMapping("/orderNow")
    public String orderNow(@RequestParam("proId") Integer proId,
    					   @RequestParam("quantity") Integer quantity,
    					   Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        
        if (authentication == null || !authentication.isAuthenticated())
            return "redirect:/login"; // 로그인 안 된 경우 로그인 페이지로 리다이렉트

        String userId = authentication.getName(); // 로그인한 사용자의 username 가져오기
        int buyerId = userService.findByUsername(userId).getUserId(); // username으로 userId 조회

        OrderDto orderNow = orderService.getOrderNow(buyerId, proId);
        orderNow.setPurchaseQuantity(quantity);
        model.addAttribute("orderNow", orderNow);
        return "order/buyer/order"; 
    }
    
    // 상품 주문 (최종 주문 요청 처리)
    @PostMapping("/placeOrder")
    public String placeOrder(@RequestParam("proId") int proId,
    						 @RequestParam(value = "cartId", defaultValue = "0") int cartId, // ✅ cartId 기본값 0 설정
                             @RequestParam("purchaseQuantity") int purchaseQuantity,
                             @RequestParam("totalPrice") int totalPrice,
                             @RequestParam(value = "postalCode", required = false) String postalCode,
                             @RequestParam(value = "address", required = false) String address,
                             @RequestParam(value = "detailAddress", required = false) String detailAddress,
                             
                             // 리다이렉트할 때 한 번만 사용할 메시지를 저장하는 객체
                             // 주문 성공 또는 실패 메시지를 저장하는 용도로 사용됨
                             RedirectAttributes redirectAttributes) {
    	// 사용자가 새로운 배송지를 입력하면 해당 값이 서버로 정상적으로 전달되고 DB에 반영되도록 주소 데이터 받기
    	// required = false : 해당 요청 파라미터가 필수가 아님
    	// 해당 파라미터가 요청에 없더라도 에러가 발생하지 않고, null 값으로 처리
    	
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login"; // 로그인 안 된 경우 로그인 페이지로 이동
        }

        String username = authentication.getName();
        int buyerId = userService.findByUsername(username).getUserId(); // ✅ 로그인된 유저 ID 조회

        boolean orderSuccess = orderService.placeOrder(buyerId, cartId, proId, purchaseQuantity, totalPrice, postalCode, address, detailAddress);
        // 주문 성공 여부를 boolean 값으로 받음
        
        if (orderSuccess) {
            redirectAttributes.addFlashAttribute("message", "✅ 주문이 완료되었습니다!");
            return "redirect:/products"; // ✅ 주문 완료 후 상품 목록으로 이동
        } else {
            redirectAttributes.addFlashAttribute("message", "⚠ 주문 처리 중 오류가 발생했습니다.");
            return "redirect:/products/buy/" + proId; // 상품 목록으로 리다이렉트
        }
    }
    
    // 주문 목록 조회
    @GetMapping("/orders")
    public String getOrderList(
        @RequestParam(value = "page", defaultValue = "1") int page,
        @RequestParam(value = "keyword", required = false) String keyword,
        @RequestParam(value = "startDate", required = false) String startDate,
        @RequestParam(value = "endDate", required = false) String endDate,
        Model model) {

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }

        String username = authentication.getName();
        int buyerId = userService.findByUsername(username).getUserId();

        int pageSize = 10;
        int offset = (page - 1) * pageSize;

        // ✅ 검색어가 있으면 검색 + 페이징, 없으면 전체 조회 + 페이징
        List<OrderList> orderList = orderService.getOrdersWithPagination(buyerId, keyword, startDate, endDate, offset, pageSize);
        int totalOrders = orderService.getTotalOrderCount(buyerId, keyword, startDate, endDate);
        int totalPages = (int) Math.ceil((double) totalOrders / pageSize);

        // ✅ 검색어 & 날짜 필터 유지
        model.addAttribute("orderList", orderList);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("tKeyword", keyword);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);

        return "order/buyer/orders";
    }
    
    // "orders" : jsp에서 사용할 변수 이름
	// orders : 서비스 계층에서 조회한 주문 내역 정보 객체
    
    // 주문 상세 조회
    @GetMapping("/orderDetail")
    public String getOrderDetail(@RequestParam("orderNum") String orderNum, Model model) {
    	OrderDetail orderDetail = orderService.getOrderWithProducts(orderNum);
    	model.addAttribute("order", orderDetail);
    	
    	return "order/buyer/order-detail";
    }
    
    // 엑셀 다운로드 기능
    @GetMapping("/downloadExcel")
    public ResponseEntity<byte[]> downloadOrdersExcel() throws IOException {
        // 현재 로그인한 사용자 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        } // 인증되지 않은 사용자면 401 Unauthorized 응답 반환

        // 로그인된 사용자 ID 조회
        String username = authentication.getName();
        int buyerId = userService.findByUsername(username).getUserId(); 

        // 해당 사용자의 주문 내역만 가져오기
        List<OrderDetail> orderList = orderService.getAllOrdersForExcel(buyerId);

        // 엑셀 파일 생성
        Workbook workbook = new XSSFWorkbook(); // 새 엑셀 파일 생성
        Sheet sheet = workbook.createSheet("주문 내역"); // 시트 생성

        // 헤더 행 생성
        Row headerRow = sheet.createRow(0); // 첫 번째 행 생성
        String[] columns = {"주문번호", "주문 날짜", "상품 ID", "상품명", "구매수량", "총 가격", "판매 업체"};
        // 각 열의 제목 설정
        
        // 헤더 스타일 적용 (볼드체, 가운데 정렬 등)
        CellStyle headerStyle = createHeaderStyle(workbook);
        for (int i = 0; i < columns.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(columns[i]);
            cell.setCellStyle(headerStyle);
        }

        // 데이터 추가
        int rowNum = 1; // 1번째 행부터 데이터 입력 (0번째는 헤더)
        for (OrderDetail order : orderList) {
        	// orderList의 데이터를 순회하면서 각 셀의 데이터 추가
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(order.getOrderNum());
            row.createCell(1).setCellValue(order.getOrderDate().toString());
            row.createCell(2).setCellValue(order.getProId());
            row.createCell(3).setCellValue(order.getProName());
            row.createCell(4).setCellValue(order.getPurchaseQuantity());
            row.createCell(5).setCellValue(order.getTotalPrice());
            row.createCell(6).setCellValue(order.getCompanyName());
        }

        // 엑셀 파일을 byte[]로 변환
        
        // 엑셀 파일을 메모리에서 byte[]로 변환하는 스트림
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        workbook.write(outputStream); // 엑셀 데이터를 출력하기 위한 스트림
        workbook.close(); // 파일 닫은 후 리소스 해제

        byte[] excelData = outputStream.toByteArray(); // byte[] 형태로 변환하여 HTTP 응답으로 보낼 준비

        // HTTP 응답 헤더 설정
        HttpHeaders headers = new HttpHeaders(); // 응답 헤더 설정
        
        // CONTENT_DISPOSITION → attachment; filename=order_list.xlsx 설정으로 클라이언트가 다운로드할 파일명을 지정
        headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=order_list.xlsx");
        
        // CONTENT_TYPE → application/vnd.openxmlformats-officedocument.spreadsheetml.sheet로 엑셀 파일 타입을 명시
        headers.add(HttpHeaders.CONTENT_TYPE, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");

        // HTTP 응답으로 200 ok와 함께 파일 반환
        return ResponseEntity.ok()
                .headers(headers)
                .body(excelData);
    }

    // 엑셀 헤더 스타일 설정
    private CellStyle createHeaderStyle(Workbook workbook) {
    	// CellStyle을 생성하여 엑셀 헤더 스타일 설정
    	
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setBold(true); // 볼드체 지정
        style.setFont(font);
        style.setAlignment(HorizontalAlignment.CENTER); // 가운데 정렬
        return style;
    }
}
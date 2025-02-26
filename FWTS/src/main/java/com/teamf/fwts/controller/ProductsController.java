package com.teamf.fwts.controller;

import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

import com.teamf.fwts.service.ProductsService;
import com.teamf.fwts.service.UserService;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;

import com.teamf.fwts.dto.ProductsDto;
import com.teamf.fwts.entity.UserDetails;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Controller
@RequiredArgsConstructor
@RequestMapping("/products")
public class ProductsController {
	private final ProductsService productsService;
	private final UserService userService;

	// 상품 목록 페이지 - 기본
	@GetMapping
	public String getProductsList(@RequestParam(name = "page", defaultValue = "1") Integer page,
	                              @RequestParam(name = "category", defaultValue = "0") String category,
	                              @RequestParam(name = "keyword", required = false) String keyword,
	                              @RequestParam(name = "sort", required = false, defaultValue = "default") String sort,
	                              Model model) {
	    int perPage = 10;
	    int startRow = (page - 1) * perPage;

	    List<ProductsDto> products;
	    int count;

	    // 카테고리 이름 처리
	    String categoryName = "ALL"; // 기본값
	    if (keyword != null) {
	    	if (keyword.isBlank()) // 공백 검색어 처리
	    		return "redirect:/products";
	    	categoryName = "검색 결과";
	    	category = "0";
		} else if ("1".equals(category)) {
	        categoryName = "절화";
	    } else if ("2".equals(category)) {
	        categoryName = "관엽";
	    } else if ("3".equals(category)) {
	        categoryName = "난";
	    } else if ("4".equals(category)) {
	        categoryName = "기타";
	    }

	    int categoryId;
	    try {
	        categoryId = Integer.parseInt(category);
	    } catch (NumberFormatException e) {
	        categoryId = 0;
	    }

	    Map<String, Object> params = new HashMap<>();
	    params.put("category", categoryId == 0 ? null : categoryId);
	    params.put("keyword", keyword);
	    params.put("start", startRow);
	    params.put("count", perPage);
	    params.put("sort", sort);

	    // 상품 개수 및 목록 조회 (페이지네이션 + 정렬 포함)
	    count = productsService.countAllProducts(params);
	    products = productsService.findProductsWithPage(params);

	    int totalPages = (int) Math.ceil((double) count / perPage);

	    model.addAttribute("products", products);
	    model.addAttribute("currentPage", page);
	    model.addAttribute("totalPages", totalPages);
	    model.addAttribute("count", count);
	    model.addAttribute("category", category);
	    model.addAttribute("categoryName", categoryName);
	    model.addAttribute("keyword", keyword);
	    model.addAttribute("sort", sort);

	    return "products/productList";
	}

	
	// 상품 목록 페이지 - 특정 샵
	@GetMapping("/shop/{sellerId}")
	public String getProductsShopList(@PathVariable("sellerId") int sellerId,
	                                  @RequestParam(name = "page", defaultValue = "1") int page,
	                                  @RequestParam(name = "sort", defaultValue = "default") String sort,
	                                  @RequestParam(name = "keyword", required = false) String keyword,
	                                  Model model) {
	    int perPage = 8;  // 한 페이지당 상품 개수
	    int startRow = (page - 1) * perPage;

	    // 검색 및 정렬을 위한 파라미터 설정
	    Map<String, Object> params = new HashMap<>();
	    params.put("sellerId", sellerId);
	    params.put("keyword", keyword);
	    params.put("sort", sort);
	    params.put("start", startRow);
	    params.put("count", perPage);

	    // 총 상품 개수
	    int count = productsService.countBySellerId(sellerId);
	    List<ProductsDto> products = productsService.findBySellerIdWithPage(params);

	    int totalPages = (int) Math.ceil((double) count / perPage);

	    // 모델에 데이터 추가
	    model.addAttribute("products", products);
	    model.addAttribute("sellerId", sellerId);
	    model.addAttribute("currentPage", page);
	    model.addAttribute("totalPages", totalPages);
	    model.addAttribute("count", count);
	    model.addAttribute("keyword", keyword);
	    model.addAttribute("sort", sort);
	    
	    // 판매자 정보
		UserDetails userDetails = userService.findUserDetailsByUserId(sellerId);
	    model.addAttribute("userDetails", userDetails);	    

	    return "products/productShop";
	}


	// 상품 목록 페이지 - 상품관리
	@GetMapping("/shopM")
	public String getProductsBySellerId(@RequestParam(name = "page", defaultValue = "1") Integer page,
										Authentication authentication, Model model) {
		Integer userId = userService.findByUsername(authentication.getName()).getUserId();
		
		int perPage = 8; // 한 페이지에 보여줄 수
		int startRow = (page - 1) * perPage; // 페이지 번호

		// sellerId에 맞는 상품 목록을 가져오는 서비스 메서드 수정 필요
		int count = productsService.countAllBySellerId(userId); // 해당 sellerId에 맞는 총 상품 수
		int totalPages = (int) Math.ceil((double) count / perPage); // 전체 페이지 수

		// 페이지네이션 파라미터 설정
		Map<String, Object> params = new HashMap<>();
		params.put("sellerId", userId);
		params.put("start", startRow);
		params.put("count", perPage);

		// 해당 페이지에 맞는 상품 목록을 가져오기
		List<ProductsDto> products = productsService.findAllBySellerIdWithPage(params);

		// 모델에 데이터 전달
		model.addAttribute("products", products);
		model.addAttribute("currentPage", page);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("count", count);

		// 판매자 정보
		UserDetails userDetails = userService.findUserDetailsByUserId(userId);
		model.addAttribute("userDetails", userDetails);
		
		return "products/productShopManager";
	}

	// 상품 상세 페이지-판매자 (판매내역+수정 삭제)
	@GetMapping("/sell/{id}")
	public String getProductSell(@PathVariable("id") int id, Model model) {
		ProductsDto product = productsService.getProductById(id);
		model.addAttribute("product", product); // 상품 데이터 모델에 담기
		return "products/productSell";
	}

	// 상품 상세 페이지-구매자 (구매 전)
	@GetMapping("/buy/{id}")
	public String getProductBuy(@PathVariable("id") int id, Model model) {
		ProductsDto product = productsService.getProductById(id);
		model.addAttribute("product", product); // 상품 데이터 모델에 담기
		
		// 판매자 정보
		UserDetails userDetails = userService.findUserDetailsByUserId(product.getSellerId());
	    model.addAttribute("userDetails", userDetails);
	    
		return "products/productBuy";
	}
    
	// 상품 등록 페이지
	@GetMapping("/add/{sellerId}")
	public String getProductAddPage(@PathVariable("sellerId") int sellerId, Model model) {
		// 판매자 정보
		UserDetails userDetails = userService.findUserDetailsByUserId(sellerId);
		model.addAttribute("userDetails", userDetails);
		
		return "products/productAdd";
	}

	// 상품 수정 페이지
	@GetMapping("/edit/{id}/{sellerId}")
	public String getProductEditPage(@PathVariable("id") int id, @PathVariable("sellerId") int sellerId, Model model) {
		ProductsDto product = productsService.getProductById(id);
		model.addAttribute("product", product); // 수정할 상품 데이터 모델에 담기
		
		// 판매자 정보
		UserDetails userDetails = userService.findUserDetailsByUserId(sellerId);
		model.addAttribute("userDetails", userDetails);
				
		return "products/productEdit";
	}
	
	// 상품 등록 처리
	@PostMapping("/add/{sellerId}")
	public ResponseEntity<Map<String, Object>> registerProduct(
	        @PathVariable("sellerId") int sellerId,
	        @ModelAttribute ProductsDto products,
	        @RequestParam("productImage") MultipartFile productImage,  // 이미지 파일 받기
	        HttpServletRequest request) {

	    Map<String, Object> response = new HashMap<>();

	    try {
	        // 1️⃣ 파일이 비어 있지 않은 경우
	        if (!productImage.isEmpty()) {
	            // 2️⃣ 저장할 디렉토리 설정 (예: /uploads/)
	            String uploadDir = request.getServletContext().getRealPath("/uploads/");
	            File dir = new File(uploadDir);
	            if (!dir.exists()) {
	                dir.mkdirs();  // 디렉토리가 없으면 생성
	            }

	            // 3️⃣ 파일명 생성 (UUID 사용하여 중복 방지)
	            String originalFilename = productImage.getOriginalFilename();
	            String savedFilename = UUID.randomUUID().toString() + "_" + originalFilename;
	            File saveFile = new File(uploadDir, savedFilename);
	            productImage.transferTo(saveFile);  // 파일 저장

	            // 4️⃣ 이미지 경로를 DTO에 설정
	            String imgPath = "/uploads/" + savedFilename;
	            products.setImgPath(imgPath);
	        }

	        // 5️⃣ 상품 저장
	        productsService.addProduct(products);

	        // 6️⃣ 응답 데이터 설정
	        response.put("message", "상품이 성공적으로 등록되었습니다.");
	        response.put("productId", products.getProId());
	        response.put("imgPath", products.getImgPath());

	        return ResponseEntity.ok(response);
	    } catch (Exception e) {
	        response.put("message", "상품 등록 중 오류 발생");
	        response.put("error", e.getMessage());
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
	    }
	}
    
    // 상품 삭제 처리
    @PutMapping("/delete/{id}")
    public ResponseEntity<Map<String, Object>> deleteProduct(@PathVariable("id") int id) {
        productsService.deleteProduct(id);
        
        Map<String, Object> response = new HashMap<>();
        response.put("message", "상품이 삭제되었습니다.");
        return ResponseEntity.ok(response);
    }
    
    // 상품 수정 처리
    @PostMapping("/update/{id}")
    public ResponseEntity<Map<String, Object>> updateProduct(
            @PathVariable("id") int id,
            @ModelAttribute ProductsDto products,
            @RequestParam(value = "productImage", required = false) MultipartFile productImage,
            HttpServletRequest request) {

        Map<String, Object> response = new HashMap<>();
        try {
            ProductsDto existingProduct = productsService.getProductById(id);
            if (existingProduct == null) {
                response.put("message", "상품을 찾을 수 없습니다.");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
            }

            // 이미지가 업로드되었을 때만 처리
            if (productImage != null && !productImage.isEmpty()) {
                String uploadDir = request.getServletContext().getRealPath("/uploads/");
                File dir = new File(uploadDir);
                if (!dir.exists()) {
                    dir.mkdirs();
                }

                String originalFilename = productImage.getOriginalFilename();
                String savedFilename = UUID.randomUUID().toString() + "_" + originalFilename;
                File saveFile = new File(uploadDir, savedFilename);
                productImage.transferTo(saveFile);

                // 기존 이미지 삭제
                if (existingProduct.getImgPath() != null) {
                    File oldFile = new File(request.getServletContext().getRealPath(existingProduct.getImgPath()));
                    if (oldFile.exists()) {
                        oldFile.delete();
                    }
                }

                products.setImgPath("/uploads/" + savedFilename);
            } else {
                // 새 이미지가 없을 경우 기존 이미지 유지
                products.setImgPath(existingProduct.getImgPath());
            }

            products.setProId(id);
            productsService.updateProduct(products);

            response.put("message", "상품이 성공적으로 수정되었습니다.");
            response.put("productId", id);
            response.put("imgPath", products.getImgPath());
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("message", "상품 수정 중 오류 발생");
            response.put("error", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

}
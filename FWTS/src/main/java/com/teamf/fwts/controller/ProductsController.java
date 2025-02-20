package com.teamf.fwts.controller;

import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;

import com.teamf.fwts.service.ProductsService;
import com.teamf.fwts.service.UserService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

import com.teamf.fwts.dto.ProductsDto;
import com.teamf.fwts.entity.UserDetails;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@RequestMapping("/products")
public class ProductsController {
	private final ProductsService productsService;
	private final UserService userService;

	// 상품 목록 페이지 - 기본
	@GetMapping
	public String getProductsList(@RequestParam(name = "page", defaultValue = "1") Integer page,
	                              @RequestParam(name = "category", required = false, defaultValue = "0") String category,
	                              @RequestParam(name = "keyword", required = false) String keyword,
	                              @RequestParam(name = "sort", required = false, defaultValue = "default") String sort,
	                              Model model) {
	    int perPage = 10;
	    int startRow = (page - 1) * perPage;

	    List<ProductsDto> products;
	    int count;

	    // 카테고리 이름 처리
	    String categoryName = "전체"; // 기본값
	    if ("1".equals(category)) {
	        categoryName = "절화";
	    } else if ("2".equals(category)) {
	        categoryName = "난";
	    } else if ("3".equals(category)) {
	        categoryName = "관엽";
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
	@GetMapping("/shopM/{sellerId}")
	public String getProductsBySellerId(@PathVariable("sellerId") int sellerId,
			@RequestParam(name = "page", defaultValue = "1") Integer page, Model model) {
		int perPage = 8; // 한 페이지에 보여줄 수
		int startRow = (page - 1) * perPage; // 페이지 번호

		// sellerId에 맞는 상품 목록을 가져오는 서비스 메서드 수정 필요
		int count = productsService.countAllBySellerId(sellerId); // 해당 sellerId에 맞는 총 상품 수
		int totalPages = (int) Math.ceil((double) count / perPage); // 전체 페이지 수

		// 페이지네이션 파라미터 설정
		Map<String, Object> params = new HashMap<>();
		params.put("sellerId", sellerId);
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
		UserDetails userDetails = userService.findUserDetailsByUserId(sellerId);
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
	@GetMapping("/buy/{id}/{sellerId}")
	public String getProductBuy(@PathVariable("id") int id, @PathVariable("sellerId") int sellerId, Model model) {
		ProductsDto product = productsService.getProductById(id);
		model.addAttribute("product", product); // 상품 데이터 모델에 담기
		
		// 판매자 정보
		UserDetails userDetails = userService.findUserDetailsByUserId(sellerId);
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
	@GetMapping("/edit/{id}")
	public String getProductEditPage(@PathVariable("id") int id, Model model) {
		ProductsDto product = productsService.getProductById(id);
		model.addAttribute("product", product); // 수정할 상품 데이터 모델에 담기
		return "products/productEdit";
	}
	
    
    // 상품 삭제 처리
    @PutMapping("/delete/{id}")
    public ResponseEntity<Map<String, Object>> deleteProduct(@PathVariable("id") int id) {
        productsService.deleteProduct(id);
        
        Map<String, Object> response = new HashMap<>();
        response.put("message", "상품이 삭제되었습니다.");
        return ResponseEntity.ok(response);
    }

	// 상품 등록 처리
    @PostMapping("/add")
    public String addProduct(@Valid @ModelAttribute("productsDto") ProductsDto products,
                             BindingResult bindingResult,
                             Model model) {

        if (bindingResult.hasErrors()) {
            model.addAttribute("validMessage", "입력값을 확인해주세요.");
            return "products/add/1";  // 리다이렉트가 아니라 JSP 템플릿 직접 반환
        }

        productsService.addProduct(products);  

        return "redirect:/products/shopM/1";
    }


	// 상품 수정 처리
	@PostMapping("/edit/{id}")
	public String updateProduct(@PathVariable int id, @ModelAttribute ProductsDto product) {
		product.setProId(id); // 수정할 상품 ID 설정
		productsService.updateProduct(product); // 상품 수정 서비스 호출
		return "products/redirect:/products/" + id; // 수정 후 상세 페이지로 리다이렉트
	}
}

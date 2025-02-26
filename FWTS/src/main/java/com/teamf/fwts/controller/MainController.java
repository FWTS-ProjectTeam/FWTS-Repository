package com.teamf.fwts.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.teamf.fwts.dto.FlowerDto;
import com.teamf.fwts.dto.NoticeListDto;
import com.teamf.fwts.dto.ProductsDto;
import com.teamf.fwts.service.FlowerPriceService;
import com.teamf.fwts.service.NoticeBoardService;
import com.teamf.fwts.service.ProductsService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class MainController {
	private final NoticeBoardService noticeBoardService;
	private final ProductsService productsService;
	private final FlowerPriceService flowerPriceService;
	
	@GetMapping
    public String main(Model model) {
        try {
        	Map<String, Object> params = new HashMap<>();
	        params.put("start", 0);
	        params.put("count", 4);
	        params.put("sort", "default");  // 일반 상품 정렬 조건

	        List<NoticeListDto> notices = noticeBoardService.findAll(params);
	        List<ProductsDto> products = productsService.findProductsWithPage(params);
	        List<ProductsDto> top5Products = productsService.getTop5Products(); // 🔥 HOT 상품 추가

	        model.addAttribute("notices", notices);
	        model.addAttribute("products", products);
	        model.addAttribute("top5Products", top5Products); // ✅ HOT 상품 리스트 추가

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("message", "시세 정보를 불러오는 데 오류가 발생했습니다.");
        }

        return "main";  // main.jsp 페이지로 반환
    }
	
	// 시세 데이터 요청
	@ResponseBody
	@GetMapping("/flower-prices")
	public Map<String, Object> getFlowerPrices() {
		Map<String, Object> result = new HashMap<>();
		
	    try {
	        // 각 유형에 대해 원데이터 가져오기
	        Map<String, FlowerDto> rawCutFlower = flowerPriceService.getFlowerPricesByType("1"); // 절화
	        Map<String, FlowerDto> rawFoliage = flowerPriceService.getFlowerPricesByType("2"); // 관엽
	        Map<String, FlowerDto> rawOrchid = flowerPriceService.getFlowerPricesByType("3"); // 난

	        // 평균 데이터 계산
	        Map<String, FlowerDto> averagedCutFlower = flowerPriceService.calculateAveragedData(rawCutFlower);
	        Map<String, FlowerDto> averagedFoliage = flowerPriceService.calculateAveragedData(rawFoliage);
	        Map<String, FlowerDto> averagedOrchid = flowerPriceService.calculateAveragedData(rawOrchid);

	        // 결과를 Map에 담아 반환
	        result.put("cutFlower", averagedCutFlower);
	        result.put("foliage", averagedFoliage);
	        result.put("orchid", averagedOrchid);
	    } catch (Exception e) {
	        result.put("errorMessage", "데이터를 불러오는 중 오류가 발생했습니다.");
	    }
	    
	    return result;
	}
}
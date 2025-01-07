package com.springbootfinal.app.ajax;

import com.springbootfinal.app.domain.WeatherCoordinate;
import com.springbootfinal.app.service.WeatherCoordinateService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
public class AjaxProcessController {

	// 의존객체 주입
	//@Autowired
	//private MemberService memberService;
	@Autowired
    private WeatherCoordinateService weatherCoordinateService;
	

	// 비밀번호 확인 요청을 처리하는 메서드 - json {"result" : false }
	@GetMapping("passCheck.ajax")
	public Map<String, Boolean> memberPassCheck(
			@RequestParam("id")String id, 
			@RequestParam("pass")String pass) { 
		
		//boolean result = memberService.memberPassCheck(id, pass);
		
		Map<String, Boolean> map = new HashMap<>();
		//map.put("result", result);
		return map;
	}
	
	// 주소를 선택후 좌표의 요청을 처리하는 메서드
	/*@GetMapping("/coordinates/{areaName}")
    public WeatherCoordinate getCoordinates(@PathVariable String areaName) {
        return weatherCoordinateService.getCoordinatesByAreaName(areaName);
    }*/
	@GetMapping("/coordinates/{korCode}")
    public WeatherCoordinate getCoordinates(@PathVariable("korCode") String areaName) {
        // areaName이 "경기도 시흥"과 같은 공백을 포함할 수 있으므로, 공백을 제거하거나 처리
        areaName = areaName.replace("%20", " ");  // 공백을 복원
        //korCode = korCode.replace("")
        return weatherCoordinateService.getCoordinatesByKorCode(areaName);
    }
	
}

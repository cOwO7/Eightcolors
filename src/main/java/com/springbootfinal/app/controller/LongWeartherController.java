package com.springbootfinal.app.controller;

import com.springbootfinal.app.domain.LongWeatherDto;
import com.springbootfinal.app.domain.LongWeatherTemperatureDto;
import com.springbootfinal.app.service.LongWeatherService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

//@RequiredArgsConstructor
@Controller
@Slf4j
public class LongWeartherController {

	@Autowired
	private final LongWeatherService longWeatherService;
	@Autowired
	private final WeatherController weatherController;

	public LongWeartherController(LongWeatherService longWeatherService,
			WeatherController weatherController) {
		this.longWeatherService = longWeatherService;
		this.weatherController = weatherController;
	}
	
	@GetMapping("/longWeather")
	public String index(Model model) {
		// 현재 시각
		LocalDateTime now = LocalDateTime.now();

		// 단기 예보의 Base_time 목록
		int[] shortTermBaseHours = { 6, 18 };

		// 현재 시간 기준으로 가장 가까운 발표 시간을 계산
		String baseTime = getValidBaseTime(now, shortTermBaseHours);
		
		// 발표 시간에 맞는 날짜와 시간을 계산
		String baseDate = now.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
		
		// 기존
		//String baseTime = String.format("%02d00", baseTimeHour);
		String fullBaseTime = baseDate + " " + baseTime; // baseDate와 baseTime을 합쳐서 전체 base_time 생성
		// Thymeleaf 템플릿에 전달
		model.addAttribute("baseDate", baseDate);
		model.addAttribute("baseTime", baseTime);
		model.addAttribute("fullBaseTime", fullBaseTime); // 전체 base_time을 추가
		return "weather/longWeather"; // 
	}
	
	
	private String getValidBaseTime(LocalDateTime now, int[] shortTermBaseHours) {
		// TODO Auto-generated method stub
		return null;
	}

	/* *
	 * 중기 육상 예보
	 * @param regId 예보구역코드
	 * @param tmFc 발표시각
	 * @param model 모델 객체
	 * @return 뷰 이름
	 * */
	@GetMapping("/long")
	public String getLongWeatherForecast(
	        @RequestParam(name = "regId") String regId,
	        @RequestParam(name = "tmFc") String tmFc,
	        Model model) throws IOException {
	    //log.info("Received regId: {}", regId);
	    //log.info("Received tmFc: {}", tmFc);
	    
	    LongWeatherDto response = longWeatherService.getLongWeatherForecast(regId, tmFc);

	    // 디버깅 로그 추가
	    if (response == null) {
	        //log.error("LongWeatherDto is null. Check the API response or the service logic.");
	        throw new RuntimeException("API 호출 실패: LongWeatherDto is null.");
	    }
	    if (response.getResponse() == null) {
	        //log.error("Response object is null. Check the API response format.");
	        throw new RuntimeException("API 호출 실패: Response object is null.");
	    }
	    if (response.getResponse().getBody() == null) {
	        //log.error("Body object is null. Check the API response structure.");
	        throw new RuntimeException("API 호출 실패: Body object is null.");
	    }

	    // 정상 데이터 처리
	    model.addAttribute("weather", response.getResponse().getBody().getItems().getItem());
	    return "weather/longWeather";
	}

	/* *
	 *  중기 기온 예보
	 * @param regId 예보구역코드
	 * @param tmFc 발표시각
	 * @param model 모델 객체
	 * @return 뷰 이름
	 * */
	@GetMapping("/longTemp")
	public String getLongWeatherTemperature(
	        @RequestParam(name = "regIdTemp") String regIdTemp,
	        @RequestParam(name = "tmFc") String tmFc,
	        Model model) throws IOException {
	   // log.info("Received regId: {}", regIdTemp);
	   // log.info("Received tmFc: {}", tmFc);

		LongWeatherTemperatureDto response = longWeatherService.getLongWeatherTemperature(regIdTemp, tmFc);

	    // 디버깅 로그 추가
	    if (response == null) {
	        //log.error("LongWeatherTemperatureDto is null. Check the API response or the service logic.");
	        throw new RuntimeException("API 호출 실패: LongWeatherTemperatureDto is null.");
	    }
	    if (response.getResponse() == null) {
	        //log.error("Response object is null. Check the API response format.");
	        throw new RuntimeException("API 호출 실패: Response object is null.");
	    }
	    if (response.getResponse().getBody() == null) {
	        //log.error("Body object is null. Check the API response structure.");
	        throw new RuntimeException("API 호출 실패: Body object is null.");
	    }

	    // 정상 데이터 처리
	    model.addAttribute("temperature", response.getResponse().getBody().getItems().getItem());
	    return "weather/longWeather";
	}

}
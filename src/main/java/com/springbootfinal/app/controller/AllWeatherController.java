package com.springbootfinal.app.controller;

import com.springbootfinal.app.domain.AllWeatherDto;
import com.springbootfinal.app.domain.WeatherDto;
import com.springbootfinal.app.service.AllWeatherService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.IOException;
import java.util.Map;

@Slf4j
@Controller
//@RequestMapping("/weather")
public class AllWeatherController {
    private final AllWeatherService allWeatherService;

    @Autowired
    public AllWeatherController(AllWeatherService allWeatherService) {
        this.allWeatherService = allWeatherService;
    }

    @GetMapping("/processAllWeather")
    public String processAllWeatherDataForGet() {
        //return "redirect:/weather/form"; // 적절한 경로로 리다이렉트
        return "redirect:/weatherResult"; // 적절한 경로로 리다이렉트
    }

    // 뷰 이동
    @GetMapping("/weatherResult")
    public String showWeatherResult() {
        return "weather/weatherResult"; // 템플릿 파일 반환
    }


    @PostMapping("/processAllWeather")
    @ResponseBody
    public ResponseEntity<?> processAllWeatherDataJson(@RequestBody AllWeatherDto allWeatherDto) throws IOException {
        WeatherDto weatherDto = new WeatherDto(
                allWeatherDto.getBaseDate(),
                allWeatherDto.getBaseTime(),
                allWeatherDto.getNx(),
                allWeatherDto.getNy()
        );

        Map<String, Map<String, String>> mergedWeatherData = allWeatherService.getMergedWeatherData(
                weatherDto,
                allWeatherDto.getRegId(),
                allWeatherDto.getTmFc(),
                allWeatherDto.getRegIdTemp()
        );

        return ResponseEntity.ok(mergedWeatherData);
    }

}


package com.springbootfinal.app.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.springbootfinal.app.domain.WeatherDto;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;

import java.io.IOException;
import java.time.LocalTime;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
public class WeatherService {

	@Value("${apiUrl}")
	private String apiUrl;

	@Value("${apiKey}")
	private String apiKey;

	private final RestTemplate restTemplate;

	private WeatherService weatherService;
	private LongWeatherService longWeatherService;

	public WeatherService(RestTemplate restTemplate
			/*,WeatherService weatherService*/) {
		this.restTemplate = restTemplate;
		//this.weatherService = weatherService;
	}

	
	 // 11-28일 추가
	 // 기상청 갱신 주기 시간 (시:분)
    private static final List<LocalTime> updateTimes = Arrays.asList(
            LocalTime.of(2, 40), LocalTime.of(5, 40), LocalTime.of(8, 40),
            LocalTime.of(11, 40), LocalTime.of(14, 40), LocalTime.of(17, 40),
            LocalTime.of(20, 40), LocalTime.of(23, 40)
    );

    // 가장 가까운 갱신 시간을 찾는 메소드
    public LocalTime getNextUpdateTime() {
        LocalTime currentTime = LocalTime.now();

        // 가장 가까운 갱신 시간을 찾기 위한 변수
        LocalTime nextUpdateTime = updateTimes.get(0);  // 기본값은 첫 번째 갱신 시간

        // 현재 시간 이후 가장 가까운 갱신 시간을 찾음
        for (LocalTime updateTime : updateTimes) {
            if (updateTime.isAfter(currentTime)) {
                nextUpdateTime = updateTime;
                break;
            }
        }

        return nextUpdateTime;
    }

    // 날씨 정보를 API에서 가져오는 메소드 예시
    public String getWeatherInfo() {
        String url = "http://api.weather.com/forecast";
        return restTemplate.getForObject(url, String.class);
    }

    public static void main(String[] args) {
        // Spring에서 RestTemplate을 빈으로 주입받을 수 있으면 이렇게 호출합니다.
        RestTemplate restTemplate = new RestTemplate();
        WeatherService service = new WeatherService(restTemplate);  // RestTemplate을 생성자에 주입
        LocalTime nextUpdate = service.getNextUpdateTime();
        System.out.println("다음 갱신 시간: " + nextUpdate);
    }
	
	// 여기까지

	/* *
	 * 초단기실황조회
	 * @param weatherDto
	 * @return
	 * @throws IOException
	 * */
	public Map<String, String> getUltraSrtNcst(WeatherDto weatherDto) throws IOException {
	    UriComponents uriBuilder = UriComponentsBuilder.fromHttpUrl(apiUrl + "/getUltraSrtNcst")
	            .queryParam("serviceKey", apiKey)
	            .queryParam("dataType", "JSON")
	            .queryParam("numOfRows", 10) // 실황 데이터는 보통 10개 이하
	            .queryParam("pageNo", 1)
	            .queryParam("base_date", weatherDto.getBaseDate())
	            .queryParam("base_time", weatherDto.getBaseTime())
	            .queryParam("nx", weatherDto.getNx())
	            .queryParam("ny", weatherDto.getNy())
	            .build();

	    ResponseEntity<String> response = restTemplate.exchange(uriBuilder.toUriString(), HttpMethod.GET, null, String.class);

	   // log.info("초단기실황 API 호출 URL: {}", uriBuilder.toUriString());
	    //log.info("초단기실황 API 응답: {}", response.getBody());
	    
	    if (!response.getStatusCode().is2xxSuccessful()) {
	        throw new IOException("Ultra Srt Ncst, HTTP 상태를 가져오지 못했습니다: " + response.getStatusCode());
	    }

	    ObjectMapper mapper = new ObjectMapper();
	    JsonNode root = mapper.readTree(response.getBody());
	    JsonNode items = root.path("response").path("body").path("items").path("item");

	    Map<String, String> ultraSrtNcstData = new HashMap<>();
	    for (JsonNode item : items) {
	        String category = item.get("category").asText();
	        String value = item.get("obsrValue").asText(); // 실황은 obsrValue 사용
	        
	        //log.info("카테고리: {}, 값: {}", category, value);
	        
	        ultraSrtNcstData.put(category, value);
	    }

	    return ultraSrtNcstData;
	}



	/* *
	 * 초단기예보조회
	 * @param weatherDto
	 * @return
	 * @throws IOException
	 * */
	public String getWeatherData(String url) {
		// HttpHeaders 설정
		HttpHeaders headers = new HttpHeaders();
		headers.set("Content-Type", "application/json");

		// HttpEntity 설정
		HttpEntity<String> requestEntity = new HttpEntity<>(headers);

		// API 호출 및 응답 받기
		ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.GET, requestEntity, String.class);

		// 응답 내용 로깅
		//log.info("API 응답: {}", response.getBody());

		// 응답 내용 반환
		return response.getBody();
	}

	public Map<String, Map<String, String>> getWeatherGroupedByTime(WeatherDto weatherDto) throws IOException {
	    UriComponents uriBuilder = UriComponentsBuilder.fromHttpUrl(apiUrl + "/getUltraSrtFcst")
	            .queryParam("serviceKey", apiKey)
	            .queryParam("dataType", "JSON")
	            .queryParam("numOfRows", 60)
	            .queryParam("pageNo", 1)
	            .queryParam("base_date", weatherDto.getBaseDate())
	            .queryParam("base_time", weatherDto.getBaseTime())
	            .queryParam("nx", weatherDto.getNx())
	            .queryParam("ny", weatherDto.getNy())
	            .build();

	    // RestTemplate 사용하여 요청 보내기
	    ResponseEntity<String> response = restTemplate.exchange(uriBuilder.toUriString(), HttpMethod.GET, null, String.class);

	    // 응답 상태 코드 확인
	    if (!response.getStatusCode().is2xxSuccessful()) {
	        throw new IOException("날씨 데이터를 가져오지 못했습니다. HTTP 상태: " + response.getStatusCode());
	    }

	    // 응답 내용 로깅 (디버깅을 위한 출력)
	    //log.info("API 응답: {}", response.getBody());

	    // JSON 응답 파싱
	    ObjectMapper mapper = new ObjectMapper();
	    JsonNode root = mapper.readTree(response.getBody());
	    JsonNode items = root.path("response").path("body").path("items").path("item");

	    Map<String, Map<String, String>> groupedData = new HashMap<>();

	    // 시간별 데이터 그룹화
	    for (JsonNode item : items) {
	    	// 날짜+시간 키
	        String timeKey = item.get("fcstDate").asText() + item.get("fcstTime").asText(); 
	        String category = item.get("category").asText();
	        String value = item.get("fcstValue").asText();

	        groupedData.computeIfAbsent(timeKey, k -> new HashMap<>()).put(category, value);
	    }

	    return groupedData;
	}

	
	/* *
	 * 단기예보조회
	 * @param weatherDto
	 * @return
	 * @throws IOException
	 * */
	public Map<String, Map<String, String>> getShortTermForecast(WeatherDto weatherDto) throws IOException {
		UriComponents uriBuilder = UriComponentsBuilder.fromHttpUrl(apiUrl + "/getVilageFcst")
	            .queryParam("serviceKey", apiKey)
	            .queryParam("dataType", "JSON")
	            .queryParam("numOfRows", 60)
	            .queryParam("pageNo", 1)
	            .queryParam("base_date", weatherDto.getBaseDate())
	            .queryParam("base_time", weatherDto.getBaseTime())
	            .queryParam("nx", weatherDto.getNx())
	            .queryParam("ny", weatherDto.getNy())
	            .build();

	    ResponseEntity<String> response = restTemplate.exchange(uriBuilder.toUriString(), HttpMethod.GET, null, String.class);

	    // JSON 응답 파싱
	    ObjectMapper mapper = new ObjectMapper();
	    JsonNode root = mapper.readTree(response.getBody());
	    JsonNode items = root.path("response").path("body").path("items").path("item");

	    Map<String, Map<String, String>> shortTermData = new HashMap<>();
	    for (JsonNode item : items) {
	        String category = item.get("category").asText();
	        String value = item.get("fcstValue").asText();

	        // 시간대를 키로 그룹화
	        String timeKey = item.get("fcstDate").asText() + item.get("fcstTime").asText();
	        shortTermData.computeIfAbsent(timeKey, k -> new HashMap<>()).put(category, value);
	    }

	    return shortTermData;
	}

	// api 병합
	public Map<String, Map<String, String>> getMergedWeatherData(WeatherDto weatherDto) throws IOException {
	    // 초단기예보 데이터 가져오기
	    Map<String, Map<String, String>> forecastData = getWeatherGroupedByTime(weatherDto);

	    // 단기예보 데이터 가져오기
	    Map<String, Map<String, String>> shortTermData = getShortTermForecast(weatherDto);

	    // 초단기실황 데이터 가져오기
	    Map<String, String> ultraSrtNcstData = getUltraSrtNcst(weatherDto);

	    // 데이터 병합
	    for (String timeKey : shortTermData.keySet()) {
	        forecastData.computeIfAbsent(timeKey, k -> new HashMap<>()).putAll(shortTermData.get(timeKey));
	    }

	    // 초단기실황 데이터는 가장 최신 데이터로 병합
	    forecastData.computeIfAbsent("current", k -> new HashMap<>()).putAll(ultraSrtNcstData);

	    return forecastData;
	}
}
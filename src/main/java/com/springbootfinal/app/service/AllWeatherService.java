package com.springbootfinal.app.service;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.springbootfinal.app.domain.LongWeatherDto;
import com.springbootfinal.app.domain.LongWeatherTemperatureDto;
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
import java.net.URI;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Slf4j
@Service
public class AllWeatherService {

    // 단기 예보
    @Value("${apiUrl}")
    private String apiUrl;
    // 중기 예보
    @Value("${apiUrl2}")
    private String apiUrl2;
    // 공통 ApiKey Encoding Key
    @Value("${apiKey}")
    private String apiKey;

    private final RestTemplate restTemplate;

    public AllWeatherService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    /* *
     * 단기/중기 육상/중기 기온 데이터를 병합
     * @param weatherDto - 단기 예보 요청 데이터
     * @param regId - 중기 육상 예보 지역 ID
     * @param tmFc - 중기 예보 기준 시간
     * @param regIdTemp - 중기 기온 예보 지역 ID
     * @return 통합된 날씨 데이터
     * */
    public Map<String, Map<String, Map<String, String>>> getAllWeatherData(
            WeatherDto weatherDto, String regId, String tmFc, String regIdTemp) throws IOException {
        log.info("Start fetching all weather data with weatherDto: {}, regId: {}, tmFc: {}, regIdTemp: {}",
                weatherDto, regId, tmFc, regIdTemp);

        // 단기 예보 데이터 가져오기
        Map<String, Map<String, String>> shortTermData = getShortTermForecast(weatherDto);
        log.info("Short term data: {}", shortTermData);

        // 중기 육상 예보 데이터 가져오기
        LongWeatherDto longWeatherForecast = getLongWeatherForecast(regId, tmFc);
        Map<String, Map<String, String>> midLandData = convertLongWeatherDtoToMap(longWeatherForecast);
        log.info("Mid land forecast data: {}", midLandData);

        // 중기 기온 예보 데이터 가져오기
        LongWeatherTemperatureDto longWeatherTemperature = getLongWeatherTemperature(regIdTemp, tmFc);
        Map<String, Map<String, String>> midTemperatureData = convertLongWeatherTemperatureDtoToMap(longWeatherTemperature);
        log.info("Mid temperature data: {}", midTemperatureData);

        // 모든 데이터를 병합
        Map<String, Map<String, Map<String, String>>> allWeatherData = new HashMap<>();
        allWeatherData.put("shortTerm", shortTermData);
        allWeatherData.put("midLand", midLandData);
        allWeatherData.put("midTemperature", midTemperatureData);

        log.info("All weather data: {}", allWeatherData);

        return allWeatherData;
    }


    private Map<String, Map<String, String>> convertLongWeatherDtoToMap(LongWeatherDto longWeatherForecast) {
        Map<String, Map<String, String>> dataMap = new HashMap<>();

        if (longWeatherForecast == null || longWeatherForecast.getResponse().getBody().getItems().getItem() == null) {
            log.warn("LongWeatherForecast 데이터가 비어 있습니다.");
            return dataMap;
        }

        LongWeatherDto.Item item = longWeatherForecast.getResponse().getBody().getItems().getItem().get(0);

        for (int i = 4; i <= 10; i++) {
            String fcstDate = calculateFutureDate(i - 3);
            Map<String, String> attributes = new HashMap<>();
            attributes.put("rainProbability", i <= 7
                    ? item.getRnSt(i) + " / " + item.getRnSt(i)
                    : String.valueOf(item.getRnSt(i)));
            attributes.put("weatherForecast", i <= 7
                    ? item.getWf(i) + " / " + item.getWf(i)
                    : item.getWf(i));
            dataMap.put(fcstDate, attributes);
        }

        return dataMap;
    }

    // 현재 날짜 함수
    private String calculateFutureDate(int daysFromNow) {
        LocalDate today = LocalDate.now(); // 현재 날짜
        LocalDate futureDate = today.plusDays(daysFromNow); // daysFromNow일 후 날짜 계산
        return futureDate.format(DateTimeFormatter.BASIC_ISO_DATE); // YYYYMMDD 형식 반환
    }



    private Map<String, Map<String, String>> convertLongWeatherTemperatureDtoToMap(LongWeatherTemperatureDto longWeatherTemperature) {
        Map<String, Map<String, String>> dataMap = new HashMap<>();

        for (LongWeatherTemperatureDto.Item item : longWeatherTemperature.getResponse().getBody().getItems().getItem()) {
            for (int day = 4; day <= 10; day++) {
                String fcstDate = calculateFutureDate(day - 3);
                Map<String, String> attributes = dataMap.computeIfAbsent(fcstDate, k -> new HashMap<>());
                attributes.put("minTemperature", item.getTaMin(day));
                attributes.put("maxTemperature", item.getTaMax(day));
            }
        }

        return dataMap;
    }


    public Map<String, Map<String, String>> getCombinedWeatherData(
            WeatherDto weatherDto, String regId, String tmFc, String regIdTemp) throws IOException {

        // 1. 단기 예보 데이터 가져오기
        Map<String, Map<String, String>> shortTermData = getShortTermForecast(weatherDto);
        log.info("단기 예보 데이터 가져오기 성공");

        // 2. 중기 육상 예보 데이터 가져오기
        LongWeatherDto longWeatherForecast = getLongWeatherForecast(regId, tmFc);
        Map<String, Map<String, String>> midLandData = convertLongWeatherDtoToMap(longWeatherForecast);
        log.info("중기 육상 예보 데이터 가져오기 성공");

        // 3. 중기 기온 데이터 가져오기
        LongWeatherTemperatureDto longWeatherTemperature = getLongWeatherTemperature(regIdTemp, tmFc);
        Map<String, Map<String, String>> midTemperatureData = convertLongWeatherTemperatureDtoToMap(longWeatherTemperature);
        log.info("중기 기온 데이터 가져오기 성공");

        // 4. 병합 데이터 구조 생성
        Map<String, Map<String, String>> combinedData = new HashMap<>();

        // 단기 예보 데이터를 병합
        for (String timeKey : shortTermData.keySet()) {
            combinedData.put(timeKey, new HashMap<>(shortTermData.get(timeKey)));
        }

        // 중기 육상 데이터를 병합
        for (String timeKey : midLandData.keySet()) {
            combinedData.computeIfAbsent(timeKey, k -> new HashMap<>()).putAll(midLandData.get(timeKey));
        }

        // 중기 기온 데이터를 병합
        for (String timeKey : midTemperatureData.keySet()) {
            combinedData.computeIfAbsent(timeKey, k -> new HashMap<>()).putAll(midTemperatureData.get(timeKey));
        }

        log.info("모든 데이터를 성공적으로 병합했습니다.");
        return combinedData;
    }

    // 데이터 처리
    /*public Map<String, Map<String, String>> getMergedWeatherData(
            WeatherDto weatherDto, String regId, String tmFc, String regIdTemp) throws IOException {

        // 단기 예보 데이터 가져오기
        Map<String, Map<String, String>> shortTermData = getShortTermForecast(weatherDto);

        // 중기 육상 예보 데이터 가져오기
        LongWeatherDto longWeatherForecast = getLongWeatherForecast(regId, tmFc);
        Map<String, Map<String, String>> midLandData = convertLongWeatherDtoToMap(longWeatherForecast);

        // 중기 기온 예보 데이터 가져오기
        LongWeatherTemperatureDto longWeatherTemperature = getLongWeatherTemperature(regIdTemp, tmFc);
        Map<String, Map<String, String>> midTemperatureData = convertLongWeatherTemperatureDtoToMap(longWeatherTemperature);

        // 날짜 기반 병합
        Map<String, Map<String, String>> dailyForecast = new HashMap<>();

        // 단기 예보 병합 (1~3일)
        for (String timeKey : shortTermData.keySet()) {
            String date = timeKey.substring(0, 8); // YYYYMMDD 추출
            dailyForecast.computeIfAbsent(date, k -> new HashMap<>()).putAll(shortTermData.get(timeKey));
        }

        // 중기 육상 및 기온 병합 (4~10일)
        for (String timeKey : midLandData.keySet()) {
            String date = timeKey.substring(0, 8); // YYYYMMDD 추출
            dailyForecast.computeIfAbsent(date, k -> new HashMap<>()).putAll(midLandData.get(timeKey));
        }

        for (String timeKey : midTemperatureData.keySet()) {
            String date = timeKey.substring(0, 8); // YYYYMMDD 추출
            dailyForecast.computeIfAbsent(date, k -> new HashMap<>()).putAll(midTemperatureData.get(timeKey));
        }

        return dailyForecast;
    }*/

    /*public Map<String, Map<String, String>> getMergedWeatherData(
            WeatherDto weatherDto, String regId, String tmFc, String regIdTemp) throws IOException {

        Map<String, Map<String, String>> shortTermData = getShortTermForecast(weatherDto);
        LongWeatherDto longWeatherForecast = getLongWeatherForecast(regId, tmFc);
        Map<String, Map<String, String>> midLandData = convertLongWeatherDtoToMap(longWeatherForecast);
        LongWeatherTemperatureDto longWeatherTemperature = getLongWeatherTemperature(regIdTemp, tmFc);
        Map<String, Map<String, String>> midTemperatureData = convertLongWeatherTemperatureDtoToMap(longWeatherTemperature);

        Map<String, Map<String, String>> dailyForecast = new TreeMap<>();

        String lastShortTermDate = null;
        for (String timeKey : shortTermData.keySet()) {
            String date = timeKey.substring(0, 8);
            lastShortTermDate = date;
            dailyForecast.computeIfAbsent(date, k -> new HashMap<>()).putAll(shortTermData.get(timeKey));
        }

        if (lastShortTermDate != null) {
            mergeForecastData(dailyForecast, midLandData, lastShortTermDate);
            mergeForecastData(dailyForecast, midTemperatureData, lastShortTermDate);
        }

        log.info("병합된 데이터: {}", dailyForecast);
        return dailyForecast;
    }*/

    public Map<String, Map<String, String>> getMergedWeatherData(
            WeatherDto weatherDto, String regId, String tmFc, String regIdTemp) throws IOException {

        Map<String, Map<String, String>> shortTermData = getShortTermForecast(weatherDto);
        LongWeatherDto longWeatherForecast = getLongWeatherForecast(regId, tmFc);
        Map<String, Map<String, String>> midLandData = convertLongWeatherDtoToMap(longWeatherForecast);
        LongWeatherTemperatureDto longWeatherTemperature = getLongWeatherTemperature(regIdTemp, tmFc);
        Map<String, Map<String, String>> midTemperatureData = convertLongWeatherTemperatureDtoToMap(longWeatherTemperature);

        Map<String, Map<String, String>> dailyForecast = new TreeMap<>();

        String lastShortTermDate = null;
        for (String timeKey : shortTermData.keySet()) {
            String date = timeKey.substring(0, 8);
            lastShortTermDate = date;
            dailyForecast.computeIfAbsent(date, k -> new HashMap<>()).putAll(shortTermData.get(timeKey));
        }

        if (lastShortTermDate != null) {
            mergeForecastData(dailyForecast, midLandData, lastShortTermDate);
            mergeForecastData(dailyForecast, midTemperatureData, lastShortTermDate);
        }

        log.info("병합된 데이터: {}", dailyForecast);
        return dailyForecast;
    }


    private void mergeForecastData(Map<String, Map<String, String>> dailyForecast,
                                   Map<String, Map<String, String>> additionalData, String lastShortTermDate) {
        for (String date : additionalData.keySet()) {
            if (date.compareTo(lastShortTermDate) <= 0) {
                log.warn("중기 데이터가 단기 데이터 범위를 침범: {}", date);
                continue;  // 중기 예보 데이터가 단기 예보의 범위를 넘어가면 건너뛰기
            }
            dailyForecast.computeIfAbsent(date, k -> new HashMap<>()).putAll(additionalData.get(date));
        }
    }


    private Map<String, Map<String, String>> calculateDailyTemperatures(Map<String, Map<String, String>> shortTermData) {
        Map<String, Map<String, String>> dailyTemperatureData = new HashMap<>();
        Map<String, List<Double>> dailyTemps = new HashMap<>();

        // TMP 데이터를 날짜별로 그룹화
        shortTermData.forEach((timeKey, values) -> {
            String date = timeKey.substring(0, 8); // YYYYMMDD 추출
            if (values.containsKey("TMP")) {
                double temp = Double.parseDouble(values.get("TMP"));
                dailyTemps.computeIfAbsent(date, k -> new ArrayList<>()).add(temp);
            }
        });

        // 날짜별로 최저/최고 기온 계산
        dailyTemps.forEach((date, temps) -> {
            double tMin = temps.stream().min(Double::compare).orElse(Double.NaN); // 최저 기온
            double tMax = temps.stream().max(Double::compare).orElse(Double.NaN); // 최고 기온
            Map<String, String> tempData = new HashMap<>();
            tempData.put("TMN", String.valueOf(tMin));
            tempData.put("TMX", String.valueOf(tMax));
            dailyTemperatureData.put(date, tempData);
        });

        return dailyTemperatureData;
    }


    /* *
     * 단기 예보 조회
     * @param weatherDto
     * @return
     * @throws IOException
     * */
    /*public Map<String, Map<String, String>> getShortTermForecast(WeatherDto weatherDto) throws IOException {
        // URI 생성
        URI url = UriComponentsBuilder.fromHttpUrl(apiUrl + "/getVilageFcst")
                .queryParam("serviceKey", apiKey)
                .queryParam("dataType", "JSON")
                .queryParam("numOfRows", 750)
                .queryParam("pageNo", 1)
                .queryParam("base_date", weatherDto.getBaseDate())
                .queryParam("base_time", weatherDto.getBaseTime())
                .queryParam("nx", weatherDto.getNx())
                .queryParam("ny", weatherDto.getNy())
                .build(true)
                .toUri();

        log.info("단기 예보 URL: {}", url); // URL 로깅

        // API 호출
        ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.GET, null, String.class);

        // API 응답 확인 및 로깅
        String responseBody = response.getBody();
        log.info("단기 예보 API 응답 데이터: {}", responseBody);

        // JSON 형식 확인
        if (responseBody.trim().startsWith("<")) {
            log.error("API 응답이 JSON이 아니라 XML/HTML입니다: {}", responseBody);
            throw new RuntimeException("API 응답이 JSON이 아님: XML/HTML 데이터 반환");
        }

        // JSON 응답 파싱
        ObjectMapper mapper = new ObjectMapper();
        JsonNode root;
        try {
            root = mapper.readTree(responseBody);
        } catch (Exception e) {
            log.error("JSON 파싱 오류. 응답 데이터: {}", responseBody);
            throw new RuntimeException("JSON 파싱 오류: " + e.getMessage(), e);
        }

        JsonNode items = root.path("response").path("body").path("items").path("item");

        // 결과 데이터 변환
        Map<String, Map<String, String>> shortTermData = new HashMap<>();
        for (JsonNode item : items) {
            String category = item.get("category").asText();
            String value = item.get("fcstValue").asText();
            String timeKey = item.get("fcstDate").asText() + item.get("fcstTime").asText();
            shortTermData.computeIfAbsent(timeKey, k -> new HashMap<>()).put(category, value);
        }

        return shortTermData;
    }*/
    public Map<String, Map<String, String>> getShortTermForecast(WeatherDto weatherDto) throws IOException {
        URI url = UriComponentsBuilder.fromHttpUrl(apiUrl + "/getVilageFcst")
                .queryParam("serviceKey", apiKey)
                .queryParam("dataType", "JSON")
                .queryParam("numOfRows", 750)
                .queryParam("pageNo", 1)
                .queryParam("base_date", weatherDto.getBaseDate())
                .queryParam("base_time", weatherDto.getBaseTime())
                .queryParam("nx", weatherDto.getNx())
                .queryParam("ny", weatherDto.getNy())
                .build(true)
                .toUri();

        log.info("단기 예보 URL: {}", url);

        ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.GET, null, String.class);

        String responseBody = response.getBody();
        log.info("단기 예보 API 응답 데이터: {}", responseBody);

        if (responseBody.trim().startsWith("<")) {
            log.error("API 응답이 JSON이 아니라 XML/HTML입니다: {}", responseBody);
            throw new RuntimeException("API 응답이 JSON이 아님: XML/HTML 데이터 반환");
        }

        ObjectMapper mapper = new ObjectMapper();
        JsonNode root = mapper.readTree(responseBody);
        JsonNode items = root.path("response").path("body").path("items").path("item");

        Map<String, Map<String, String>> shortTermData = new HashMap<>();
        for (JsonNode item : items) {
            String category = item.get("category").asText();
            String value = item.get("fcstValue").asText();
            String timeKey = item.get("fcstDate").asText() + item.get("fcstTime").asText();
            shortTermData.computeIfAbsent(timeKey, k -> new HashMap<>()).put(category, value);
        }

        // TMP 데이터를 기반으로 날짜별 TMN/TMX 계산
        Map<String, Map<String, String>> dailyTemperatures = calculateDailyTemperatures(shortTermData);

        // 단기 예보 데이터에 TMN/TMX 추가
        dailyTemperatures.forEach((date, tempValues) -> {
            shortTermData.computeIfAbsent(date, k -> new HashMap<>()).putAll(tempValues);
        });

        return shortTermData;
    }


    /* *
     * 중기 육상 예보
     * @param regId
     * @param tmFc
     * @return
     * */
    public LongWeatherDto getLongWeatherForecast(String regId, String tmFc) throws IOException {
        URI url = UriComponentsBuilder.fromUriString(apiUrl2 + "/getMidLandFcst")
                .queryParam("serviceKey", apiKey)
                .queryParam("numOfRows", 60)
                .queryParam("pageNo", 1)
                .queryParam("dataType", "JSON")
                .queryParam("regId", regId)
                .queryParam("tmFc", tmFc)
                .build(true)
                .toUri();

        log.info("중기 육상 예보  URL: {}", url); // URL 로깅

        ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.GET, null, String.class);

        log.info("중기 육상 API 호출 URL: {}", url); // API 호출 정보 로깅
        String responseBody = response.getBody();
        log.info("중기 육상 API 응답 데이터: {}", responseBody); // API 응답 데이터 로깅

        if (responseBody.trim().startsWith("<")) {
            log.error("API 응답이 JSON이 아니라 XML/HTML입니다: {}", responseBody);
            throw new RuntimeException("API 응답이 JSON이 아님: XML/HTML 데이터 반환");
        }

        // JSON 응답 파싱
        ObjectMapper mapper = new ObjectMapper();
        mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        return mapper.readValue(responseBody, LongWeatherDto.class);
    }


    /* *
     * 중기 기온 예보
     * @param regId
     * @param tmFc
     * @return
     * */
    public LongWeatherTemperatureDto getLongWeatherTemperature(String regIdTemp, String tmFcTemp) throws IOException {
        URI url = UriComponentsBuilder.fromUriString(apiUrl2 + "/getMidTa")
                .queryParam("serviceKey", apiKey)
                .queryParam("numOfRows", 60)
                .queryParam("pageNo", 1)
                .queryParam("dataType", "JSON")
                .queryParam("regId", regIdTemp)
                .queryParam("tmFc", tmFcTemp)
                .build(true)
                .toUri();

        log.info("중기 기온 예보 URL: {}", url); // URL 로깅

        ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.GET, null, String.class);

        log.info("중기 기온 API 호출 URL: {}", url); // API 호출 정보 로깅
        String responseBody = response.getBody();
        log.info("중기 기온 API 응답 데이터: {}", responseBody); // API 응답 데이터 로깅

        if (responseBody.trim().startsWith("<")) {
            log.error("API 응답이 JSON이 아니라 XML/HTML입니다: {}", responseBody);
            throw new RuntimeException("API 응답이 JSON이 아님: XML/HTML 데이터 반환");
        }

        // JSON 응답 파싱
        ObjectMapper mapper = new ObjectMapper();
        mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        return mapper.readValue(responseBody, LongWeatherTemperatureDto.class);
    }

}

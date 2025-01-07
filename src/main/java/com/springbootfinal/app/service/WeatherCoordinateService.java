package com.springbootfinal.app.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springbootfinal.app.domain.WeatherCoordinate;
import com.springbootfinal.app.mapper.WeatherCoordinateMapper;

@Service
public class WeatherCoordinateService {

	@Autowired
    private WeatherCoordinateMapper weatherCoordinateMapper;

	public WeatherCoordinate getCoordinatesByKorCode(String korCode) {
	    return weatherCoordinateMapper.getCoordinatesByKorCode(korCode);
	}
}

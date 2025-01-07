package com.springbootfinal.app.service;

import com.springbootfinal.app.mapper.MainMapper;
import com.sun.tools.javac.Main;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Slf4j
public class MainService {
	
	@Autowired
	private MainMapper mainMapper;
	
	public List<Main> mainList() {
		//log.info("MainService: mainList()");
		return mainMapper.mainList();
	}
}

package com.springbootfinal.app.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class InquiryDto {
	private Long inquiryNo;
	private Long userNo;
	private String title;
	private String content;
	private String status;
	private LocalDateTime inquiryDate;


}

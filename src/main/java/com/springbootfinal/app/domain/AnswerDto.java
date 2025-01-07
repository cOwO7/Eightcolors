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
public class AnswerDto {
    private Long answerNo;
    private Long inquiryNo;
    private Long adminUserNo;
    private String content;
    private LocalDateTime answerDate;
}

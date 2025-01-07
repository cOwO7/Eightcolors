package com.springbootfinal.app.service;

import com.springbootfinal.app.domain.AnswerDto;
import com.springbootfinal.app.mapper.AnswersMapper;
import org.springframework.stereotype.Service;

@Service
public class AnswerService {

    private final AnswersMapper answersMapper;
    private final InquiryService inquiryService;

    public AnswerService(AnswersMapper answersMapper, InquiryService inquiryService) {
        this.answersMapper = answersMapper;
        this.inquiryService = inquiryService;
    }

    public void addAnswer(AnswerDto answerDto) {
        answersMapper.insertAnswer(answerDto);
        inquiryService.updateInquiryStatus(answerDto.getInquiryNo(), "answered");
    }

    public AnswerDto getAnswerByInquiryId(Long inquiryNo) {
        return answersMapper.getAnswerByInquiryId(inquiryNo);
    }
}


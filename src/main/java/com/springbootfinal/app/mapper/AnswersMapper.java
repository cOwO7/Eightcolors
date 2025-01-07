package com.springbootfinal.app.mapper;

import com.springbootfinal.app.domain.AnswerDto;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AnswersMapper {

    void insertAnswer(AnswerDto answerDto);

    AnswerDto getAnswerByInquiryId(Long inquiryNo);
}


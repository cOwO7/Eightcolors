package com.springbootfinal.app.mapper;

import com.springbootfinal.app.domain.InquiryDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface InquiriesMapper {

    void insertInquiry(InquiryDto inquiryDto);

    List<InquiryDto> getAllInquiries();

    InquiryDto getInquiryById(Long inquiryNo);

    void updateInquiryStatus(@Param("inquiryNo") Long inquiryNo, @Param("status") String status);
}

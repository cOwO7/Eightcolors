package com.springbootfinal.app.service;

import com.springbootfinal.app.domain.InquiryDto;
import com.springbootfinal.app.mapper.InquiriesMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class InquiryService {

    private final InquiriesMapper inquiriesMapper;

    public InquiryService(InquiriesMapper inquiriesMapper) {
        this.inquiriesMapper = inquiriesMapper;
    }

    public void addInquiry(InquiryDto inquiryDto) {
        inquiryDto.setStatus("pending");
        inquiriesMapper.insertInquiry(inquiryDto);
    }

    public List<InquiryDto> getAllInquiries() {
        return inquiriesMapper.getAllInquiries();
    }

    public InquiryDto getInquiryById(Long inquiryNo) {
        return inquiriesMapper.getInquiryById(inquiryNo);
    }

    public void updateInquiryStatus(Long inquiryNo, String status) {
        inquiriesMapper.updateInquiryStatus(inquiryNo, status);
    }
}


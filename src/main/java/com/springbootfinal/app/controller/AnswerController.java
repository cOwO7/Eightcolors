package com.springbootfinal.app.controller;

import com.springbootfinal.app.domain.AnswerDto;
import com.springbootfinal.app.service.AnswerService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/answers")
public class AnswerController {

    private final AnswerService answerService;

    public AnswerController(AnswerService answerService) {
        this.answerService = answerService;
    }

    @PostMapping
    public ResponseEntity<String> createAnswer(@RequestBody AnswerDto answerDto) {
        answerService.addAnswer(answerDto);
        return ResponseEntity.ok("답변이 등록되었습니다.");
    }

    @GetMapping("/{inquiryId}")
    public ResponseEntity<AnswerDto> getAnswerByInquiryId(@PathVariable Long inquiryId) {
        return ResponseEntity.ok(answerService.getAnswerByInquiryId(inquiryId));
    }
}


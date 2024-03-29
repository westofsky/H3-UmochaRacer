package com.example.backend.domain.global.model.enums;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;

@Getter
@RequiredArgsConstructor
public enum ResultCode {
    SUCCESS(1000, HttpStatus.OK, "성공"),

    NO_KEYWORD_EXIST(2001, HttpStatus.BAD_REQUEST, "키워드에 해당하는 정보가 없습니다."),

    NO_COMMENT_EXIST_FOR_ID(3001, HttpStatus.BAD_REQUEST, "option type과 id에 해당하는 커멘트가 없습니다."),
    NO_DETAIL_EXIST_FOR_ID(3002, HttpStatus.BAD_REQUEST, "해당하는 id의 상세 정보가 존재하지 않습니다."),
    NO_CAR_INFORMATION_WITH_ID(3003, HttpStatus.BAD_REQUEST, "id에 해당하는 자동차 부품 정보가 없습니다."),

    PAGE_NOT_FOUND(4101, HttpStatus.BAD_REQUEST, "페이지 정보를 정확히 입력해 주세요."),
    PAGE_SIZE_ERROR(4102, HttpStatus.BAD_REQUEST, "페이지 사이즈 정보를 정확히 입력해 주세요."),
    END_PAGE(4103, HttpStatus.ACCEPTED, "마지막 페이지입니다!"),
    SALES_NOT_FOUND(4104, HttpStatus.BAD_REQUEST, "판매 정보가 없습니다."),

    FAIL_TO_READ_SQL_FILE(5000, HttpStatus.INTERNAL_SERVER_ERROR , "SQL 파일을 읽는 데 실패했습니다." ),

    ILLEGAL_ARGUMENT(10001, HttpStatus.INTERNAL_SERVER_ERROR, "해당 요청을 처리할 수 없습니다.")
    ;

    private final int code;
    private final HttpStatus httpStatus;
    private final String message;
}

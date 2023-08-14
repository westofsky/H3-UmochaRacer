package com.example.backend.domain.information.service.strategy;

import com.example.backend.domain.global.exception.RestApiException;
import com.example.backend.domain.global.model.enums.ResultCode;
import com.example.backend.domain.information.dto.CommentResponse;
import com.example.backend.domain.information.dto.CommonResponse;
import com.example.backend.domain.information.mapper.InformationMapper;
import com.example.backend.domain.information.model.car.entity.ExteriorColor;
import com.example.backend.domain.information.model.car.repository.ExteriorColorRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class ExteriorColorStrategy implements InformationStrategy {
    private final ExteriorColorRepository exteriorColorRepository;
    private final InformationMapper informationMapper;

    @Override
    public List<CommonResponse> findAll() {
        List<ExteriorColor> all = (List<ExteriorColor>) exteriorColorRepository.findAll();
        return all.stream().map(informationMapper::map).collect(Collectors.toList());
    }

    @Override
    public StrategyName getStrategyName() {
        return StrategyName.EXTERIOR_COLOR;
    }

    @Override
    public CommentResponse findCommentById(long id) {
        String comment = exteriorColorRepository.findExteriorColorCommentById(id);
        if (comment == null) throw new RestApiException(ResultCode.NO_COMMENT_EXIST_FOR_ID);
        return CommentResponse.builder()
                .comment(comment)
                .build();
    }

    @Override
    public Long findDetailId(long id) {
        return null;
    }
}

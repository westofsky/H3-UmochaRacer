package com.example.backend.domain.sale.entity;

import com.example.backend.domain.information.entity.option.entity.AdditionalOption;
import org.springframework.data.annotation.Id;
import org.springframework.data.jdbc.core.mapping.AggregateReference;
import org.springframework.data.relational.core.mapping.Table;

@Table("SALES_OPTION")
public class SalesOption {
    @Id
    private Long id;
    private AggregateReference<Sales,Long> salesId;
    private AggregateReference<AdditionalOption, Long> optionId;
}

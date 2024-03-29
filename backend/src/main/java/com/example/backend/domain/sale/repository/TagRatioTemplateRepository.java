package com.example.backend.domain.sale.repository;

import com.example.backend.domain.sale.entity.RatioSummary;
import com.example.backend.domain.sale.mapper.SelectionRatioRowMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class TagRatioTemplateRepository {
    private final JdbcTemplate jdbcTemplate;

    public List<Long> findRelatedTagListWithOption(Long tagId, String category, Long optionId) {
        String query = String.format("SELECT tag_id FROM TAG_%s WHERE %s_id = %d AND tag_id = %d",
                category.toUpperCase(), category, optionId, tagId);
        return jdbcTemplate.query(query, (rs, n) ->
                rs.getLong("tag_id")
        );
    }

    @Cacheable(cacheNames = "TagSelectionCount")
    public List<RatioSummary> findBaseOptionCount(Long tagId, String category, Long optionId) {
        String category_id = category + "_id";
        String query = "SELECT * FROM (SELECT m." + category_id + " AS id, COUNT(*) AS select_count FROM MODEL m \n" +
                "JOIN SALES s ON s.model_id = m.id \n" +
                " WHERE m.trim_id = 1 AND " + tagId + " IN (tag1, tag2, tag3)\n" +
                "GROUP BY m." + category_id + " WITH ROLLUP) AS count_table \n" +
                "WHERE id = " + optionId + " OR id IS NULL";

        return jdbcTemplate.query(query, new SelectionRatioRowMapper());
    }

    public List<RatioSummary> findColorWheelOptionCount(Long tagId, String category, Long optionId) {
        String category_id = category + "_id";
        String query = "SELECT * FROM (SELECT " + category_id + " AS id, COUNT(*) AS select_count FROM SALES \n" +
                "WHERE (tag1 = " + tagId + " OR tag2 = " + tagId + " OR tag3 = " + tagId + " )\n" +
                "GROUP BY " + category_id + " WITH ROLLUP) AS count_table \n" +
                "WHERE id = " + optionId + " OR id IS NULL";

        return jdbcTemplate.query(query, new SelectionRatioRowMapper());
    }

    @Cacheable(cacheNames = "TagSelectionCount")
    public List<RatioSummary> findAdditionalOptionCount(Long tagId, String category, Long optionId) {
        String category_id = category + "_id";
        String query = "SELECT * FROM (SELECT so." + category_id + " AS id, COUNT(*) AS select_count FROM MODEL m \n" +
                "INNER JOIN SALES s ON s.model_id = m.id \n" +
                "INNER JOIN SALES_OPTIONS so ON s.id = so.sales_id \n" +
                " WHERE m.trim_id = 1 AND \n" +
                tagId + " IN (s.tag1, s.tag2, s.tag3) \n" +
                "GROUP BY so." + category_id + " WITH ROLLUP) AS count_table \n" +
                "WHERE id = " + optionId + " OR id IS NULL";

        return jdbcTemplate.query(query, new SelectionRatioRowMapper());
    }
}

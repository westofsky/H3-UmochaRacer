package com.example.backend.domain.information.model.option.repository;

import com.example.backend.domain.information.model.option.entity.Wheel;
import org.springframework.data.jdbc.repository.query.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface WheelRepository extends CrudRepository<Wheel, Long> {
    @Query("SELECT comment FROM WHEEL WHERE id = :id")
    Optional<String> findWheelCommentById(long id);

    @Query("SELECT detail_id FROM WHEEL WHERE id = :id")
    Optional<Long> findDetailIdById(long id);
}

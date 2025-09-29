package com.skillsprint.repository;

import com.skillsprint.model.Progress;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;
import java.util.List;

public interface ProgressRepository extends JpaRepository<Progress, Long> {
    Optional<Progress> findByUserIdAndSkillId(Long userId, Long skillId);
    List<Progress> findByUserId(Long userId);
}

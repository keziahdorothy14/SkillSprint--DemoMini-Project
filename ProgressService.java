package com.skillsprint.service;

import com.skillsprint.model.Progress;
import com.skillsprint.repository.ProgressRepository;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class ProgressService {
    private final ProgressRepository repo;
    public ProgressService(ProgressRepository repo) { this.repo = repo; }
    public Progress setProgress(Long userId, Long skillId, int percent) {
        return repo.findByUserIdAndSkillId(userId, skillId)
                .map(p -> { p.setPercent(percent); return repo.save(p); })
                .orElseGet(() -> repo.save(new Progress(userId, skillId, percent)));
    }
    public List<Progress> getForUser(Long userId) { return repo.findByUserId(userId); }
}

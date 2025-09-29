package com.skillsprint.service;

import com.skillsprint.model.Skill;
import com.skillsprint.repository.SkillRepository;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class SkillService {
    private final SkillRepository repo;
    public SkillService(SkillRepository repo) { this.repo = repo; }
    public List<Skill> all() { return repo.findAll(); }
    public Optional<Skill> find(Long id) { return repo.findById(id); }
    public Skill save(Skill s) { return repo.save(s); }
}

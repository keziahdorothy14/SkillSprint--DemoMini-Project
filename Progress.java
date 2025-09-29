package com.skillsprint.model;

import jakarta.persistence.*;

@Entity
public class Progress {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private Long userId;
    private Long skillId;
    private int percent; // 0-100
    public Progress() {}
    public Progress(Long userId, Long skillId, int percent) {
        this.userId = userId; this.skillId = skillId; this.percent = percent;
    }
    public Long getId() { return id; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public Long getSkillId() { return skillId; }
    public void setSkillId(Long skillId) { this.skillId = skillId; }
    public int getPercent() { return percent; }
    public void setPercent(int percent) { this.percent = percent; }
}

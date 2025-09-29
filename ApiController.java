package com.skillsprint.controller;

import com.skillsprint.model.Progress;
import com.skillsprint.model.User;
import com.skillsprint.service.ProgressService;
import jakarta.servlet.http.HttpSession;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
public class ApiController {
    private final ProgressService progressService;
    public ApiController(ProgressService progressService) { this.progressService = progressService; }

    @PostMapping("/progress")
    public ResponseEntity<?> setProgress(@RequestParam Long skillId, @RequestParam int percent, HttpSession session){
        User u = (User) session.getAttribute("user");
        if (u == null) return ResponseEntity.status(401).body("login required");
        Progress p = progressService.setProgress(u.getId(), skillId, percent);
        return ResponseEntity.ok(p);
    }
}

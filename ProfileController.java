package com.skillsprint.controller;

import com.skillsprint.model.User;
import com.skillsprint.service.AuthService;
import com.skillsprint.service.ProgressService;
import com.skillsprint.service.SkillService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/profile")
public class ProfileController {
    private final AuthService authService;
    private final ProgressService progressService;
    private final SkillService skillService;
    public ProfileController(AuthService authService, ProgressService progressService, SkillService skillService){
        this.authService = authService; this.progressService = progressService; this.skillService = skillService;
    }

    @GetMapping
    public String profile(Model m, HttpSession session){
        User u = (User) session.getAttribute("user"); 
        if (u == null) return "redirect:/auth/login";
        m.addAttribute("user", u);
        m.addAttribute("progress", progressService.getForUser(u.getId()));
        m.addAttribute("skills", skillService.all());
        return "profile";
    }
}

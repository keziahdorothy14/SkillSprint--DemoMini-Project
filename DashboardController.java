package com.skillsprint.controller;

import com.skillsprint.model.Skill;
import com.skillsprint.model.User;
import com.skillsprint.service.SkillService;
import com.skillsprint.service.ProgressService;
import com.skillsprint.repository.ProgressRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class DashboardController {
    private final SkillService skillService;
    private final ProgressService progressService;
    public DashboardController(SkillService skillService, ProgressService progressService){
        this.skillService = skillService; this.progressService = progressService;
    }

    @GetMapping({"/","/index"})
    public String index(HttpSession session){
        // if logged in, send to dashboard, else show public home
        if (session.getAttribute("user") != null) return "redirect:/dashboard";
        return "public_index";
    }

    @GetMapping("/dashboard")
    public String dashboard(Model m, HttpSession session){
        User u = (User) session.getAttribute("user"); 
        if (u == null) return "redirect:/auth/login";
        m.addAttribute("user", u);
        m.addAttribute("skills", skillService.all());
        m.addAttribute("progress", progressService.getForUser(u.getId()));
        return "dashboard";
    }

    // demo endpoint to create a demo user, sample progress and login
    @GetMapping("/demo/create")
    public String createDemo(HttpSession session){
        // creating demo is handled by DataLoader or SQL; here just login demo user if exists
        session.setAttribute("user", new com.skillsprint.model.User("demo","demo"));
        return "redirect:/dashboard";
    }
}

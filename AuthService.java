package com.skillsprint.service;

import com.skillsprint.model.User;
import com.skillsprint.repository.UserRepository;
import org.springframework.stereotype.Service;
import java.util.Optional;

@Service
public class AuthService {
    private final UserRepository userRepo;
    public AuthService(UserRepository userRepo) { this.userRepo = userRepo; }
    public Optional<User> login(String username, String password) {
        return userRepo.findByUsername(username)
                .filter(u -> u.getPassword().equals(password));
    }
    public User register(String username, String password) {
        User u = new User(username, password);
        return userRepo.save(u);
    }
    public User findById(Long id){ return userRepo.findById(id).orElse(null); }
}

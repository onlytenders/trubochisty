package com.trubochisty.truboserver.service;

import java.time.LocalDateTime;

import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.trubochisty.truboserver.dto.request.LoginRequest;
import com.trubochisty.truboserver.dto.request.RegisterRequest;
import com.trubochisty.truboserver.dto.response.AuthResponse;
import com.trubochisty.truboserver.dto.response.UserResponse;
import com.trubochisty.truboserver.exception.AuthException;
import com.trubochisty.truboserver.model.User;
import com.trubochisty.truboserver.repository.UserRepository;
import com.trubochisty.truboserver.security.JwtTokenProvider;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AuthService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authenticationManager;
    private final JwtTokenProvider tokenProvider;

    @Transactional
    public AuthResponse register(RegisterRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new AuthException("Email already registered");
        }

        User user = User.builder()
                .email(request.getEmail())
                .name(request.getName())
                .password(passwordEncoder.encode(request.getPassword()))
                .role(User.UserRole.ENGINEER) // Default role
                .createdAt(LocalDateTime.now())
                .build();

        user = userRepository.save(user);
        String token = tokenProvider.generateToken(createUserDetails(user));

        return AuthResponse.builder()
                .token(token)
                .user(UserResponse.fromUser(user))
                .build();
    }

    @Transactional
    public AuthResponse login(LoginRequest request) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword()));

        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new AuthException("User not found"));

        user.setLastLoginAt(LocalDateTime.now());
        user = userRepository.save(user);

        String token = tokenProvider.generateToken((UserDetails) authentication.getPrincipal());

        return AuthResponse.builder()
                .token(token)
                .user(UserResponse.fromUser(user))
                .build();
    }

    private UserDetails createUserDetails(User user) {
        return new org.springframework.security.core.userdetails.User(
                user.getEmail(),
                user.getPassword(),
                java.util.Collections.singletonList(
                        new org.springframework.security.core.authority.SimpleGrantedAuthority(
                                "ROLE_" + user.getRole().name())));
    }
} 
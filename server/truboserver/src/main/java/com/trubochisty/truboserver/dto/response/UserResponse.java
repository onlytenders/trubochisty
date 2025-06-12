package com.trubochisty.truboserver.dto.response;

import java.time.LocalDateTime;

import com.trubochisty.truboserver.model.User;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class UserResponse {
    private String id;
    private String email;
    private String name;
    private String avatarUrl;
    private String role;
    private LocalDateTime createdAt;
    private LocalDateTime lastLoginAt;

    public static UserResponse fromUser(User user) {
        return UserResponse.builder()
                .id(user.getId())
                .email(user.getEmail())
                .name(user.getName())
                .avatarUrl(user.getAvatarUrl())
                .role(user.getRole().name())
                .createdAt(user.getCreatedAt())
                .lastLoginAt(user.getLastLoginAt())
                .build();
    }
} 
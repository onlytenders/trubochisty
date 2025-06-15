package com.trubochisty.truboserver.DTO;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

/**
 * DTO для регистрации пользователя.
 */
@Data
public class SignUpRequest {

    @NotBlank(message = "Username is required")
    @Size(min = 3, max = 50)
    private String username;

    @NotBlank(message = "Password is required")
    @Size(min = 6, max = 100)
    private String password;

    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    private String email;

    @NotBlank(message = "Phone is required")
    private String phone;

    @NotBlank(message = "Role is required") // временно, по-другому сделать надо будет
    private String role;
}

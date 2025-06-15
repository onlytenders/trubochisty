package com.trubochisty.truboserver.service;

import com.trubochisty.truboserver.DTO.JwtAuthenticationResponse;
import com.trubochisty.truboserver.DTO.SignUpRequest;
import com.trubochisty.truboserver.model.User;
import com.trubochisty.truboserver.repository.IUserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import com.trubochisty.truboserver.DTO.SignInRequest;
import org.springframework.web.server.ResponseStatusException;

@Service
@RequiredArgsConstructor
public class AuthenticationService {
    private final UserService userService;
    private final JwtService jwtService;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authenticationManager;
    private final IUserRepository userRepository;
    /**
     * Аутентификация user'а
     *
     * @param request данные пользователя
     * @return токен
     */
    public JwtAuthenticationResponse signIn(SignInRequest request) {
        authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(
                request.getUsername(),
                request.getPassword()
        ));

        //System.out.println(request.getUsername() + " " + request.getPassword());

        var user = userService
                .userDetailsService()
                .loadUserByUsername(request.getUsername());

        System.out.println(user);


        var jwt = jwtService.generateToken(user);
        return new JwtAuthenticationResponse(jwt);
    }

    /**
     * Валидация при каждом request'е
     *
     * @param token токен пользователя
     * @return bool
     */
    public boolean validateToken(String token) {
        return jwtService.isTokenValidNUD(token);
    }

    public JwtAuthenticationResponse signUp(SignUpRequest request, UserDetails requester) {
        String requestedRole = request.getRole();

        /*if ("ROLE_ENGINEER".equals(requestedRole)) {
            // Проверяем, что requester это admin
            if (!(requester instanceof User user) || !"ROLE_ADMIN".equals(user.getRole())) {
                throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Only admins can create engineers");
            }
        }*/


        User user = User.builder()
                .username(request.getUsername())
                .password(passwordEncoder.encode(request.getPassword()))
                .email(request.getEmail())
                .phoneNumber(request.getPhone())
                .role(requestedRole)
                .build();

        userRepository.save(user);

        String token = jwtService.generateToken(user);

        return new JwtAuthenticationResponse(token);
    }


}
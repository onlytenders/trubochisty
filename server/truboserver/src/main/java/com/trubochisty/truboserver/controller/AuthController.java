package com.trubochisty.truboserver.controller;

import com.trubochisty.truboserver.DTO.JwtAuthenticationResponse;
import com.trubochisty.truboserver.DTO.SignInRequest;
import com.trubochisty.truboserver.DTO.SignUpRequest;
import com.trubochisty.truboserver.service.AuthenticationService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {
    private final AuthenticationService authenticationService;

    @PostMapping("/sign-in")
    public JwtAuthenticationResponse signIn(@Valid @RequestBody SignInRequest request) {
        return authenticationService.signIn(request);
    }

    @PostMapping("/validate")
    public ResponseEntity<HashMap<String, Boolean>> validate(@RequestParam("token") String token) {
        boolean isValid = authenticationService.validateToken(token);

        HashMap<String, Boolean> response = new HashMap<>();
        response.put("valid", isValid);

        if (!isValid) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        return ResponseEntity.ok(response);
    }

    @PostMapping("/sign-up")
    public ResponseEntity<JwtAuthenticationResponse> signUp(@RequestBody SignUpRequest request) {
        JwtAuthenticationResponse response = authenticationService.signUp(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @PostMapping("/refresh")
    public JwtAuthenticationResponse refreshToken(@RequestParam("refreshToken") String refreshToken) {
        return authenticationService.refreshToken(refreshToken);
    }

    @GetMapping("/me")
    public ResponseEntity<UserInfoResponse> getCurrentUser(Authentication authentication) {
        return ResponseEntity.ok(authenticationService.getUserInfo(authentication));
    }

    //хз понадобится или нет
    @PostMapping("/logout")
    public ResponseEntity<Void> logout(@RequestParam("token") String token) {
        authenticationService.logout(token);
        return ResponseEntity.noContent().build();
    }



}

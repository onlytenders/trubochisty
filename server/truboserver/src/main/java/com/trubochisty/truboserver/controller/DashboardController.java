package com.trubochisty.truboserver.controller;

import com.trubochisty.truboserver.model.Culvert;
import com.trubochisty.truboserver.service.CulvertService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/dashboardController")
@RequiredArgsConstructor
public class DashboardController {

    private final CulvertService culvertService;

    /**
     * Получить все трубы (с пагинацией)
     * GET /dashboardController/culverts?page=0&size=10
     */
    @GetMapping("/culverts")
    public Page<Culvert> getAllCulverts(Pageable pageable) {
        return culvertService.getAllCulvertsPageable(pageable);
    }

    /**
     * Получить все трубы, прикреплённые к пользователю
     * GET /dashboardController/user-culverts?userId=xxx
     */
    @GetMapping("/user-culverts")
    public Page<Culvert> getUserCulverts(@RequestParam String userId, Pageable pageable) {
        return culvertService.getCulvertsByUserId(userId, pageable);
    }
}

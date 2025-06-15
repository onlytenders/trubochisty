package com.trubochisty.truboserver.controller;

import com.trubochisty.truboserver.model.Culvert;
import com.trubochisty.truboserver.service.CulvertService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * REST для управления {@link Culvert}.
 *
 */
@RestController
@RequestMapping("/culvert")
@RequiredArgsConstructor
public class CulvertController {

    private final CulvertService culvertService;

    /**
     * test
     *
     * @return строка "Culvert API is up"
     */
    @GetMapping("/test")
    public String test() {
        return "Culvert API test";
    }

    /**
     * Получить объект {@link Culvert} по id.
     *
     * @param id уникальный идентификатор трубы
     * @return объект Culvert, если найден
     */
    @GetMapping("/{id}")
    public ResponseEntity<Culvert> getCulvert(@PathVariable String id) {
        return ResponseEntity.ok(culvertService.getCulvert(id));
    }

    /**
     * Список всех {@link Culvert}.
     *
     * @return список всех труб
     */
    @GetMapping
    public ResponseEntity<List<Culvert>> getAllCulverts() {
        return ResponseEntity.ok(culvertService.getAllCulverts());
    }

    /**
     * Найти объекты {@link Culvert} по адресу.
     *
     * @param address часть адреса для поиска
     * @return список совпадающих труб
     */
    @GetMapping("/by-address")
    public ResponseEntity<List<Culvert>> getByAddress(@RequestParam String address) {
        return ResponseEntity.ok(culvertService.getCulvertsByAddress(address));
    }

    /**
     * Создать новый {@link Culvert}.
     *
     * @param culvert объект, который нужно сохранить
     * @return созданный объект с присвоенным ID
     */
    @PostMapping
    public ResponseEntity<Culvert> createCulvert(@RequestBody Culvert culvert) {
        Culvert created = culvertService.createCulvert(culvert);
        return new ResponseEntity<>(created, HttpStatus.CREATED);
    }

    /**
     * Обновить существующий {@link Culvert} по id.
     *
     * @param id      ID объекта, который нужно обновить
     * @param culvert новые данные
     * @return обновлённый объект
     */
    @PutMapping("/{id}")
    public ResponseEntity<Culvert> updateCulvert(@PathVariable String id, @RequestBody Culvert culvert) {
        try{
            Culvert updated = culvertService.updateCulvert(id, culvert);
            return ResponseEntity.ok(updated);
        }
        catch (Exception e) {
            //по идее лучше кастом написать
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }

    /**
     * Удалить {@link Culvert} по id.
     *
     * @param id, который нужно удалить
     * @return HTTP 204 No Content, если успешно
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteCulvert(@PathVariable String id) {
        try{
            culvertService.deleteCulvert(id);
            return ResponseEntity.noContent().build();
        }
        catch (Exception e) {
            //по идее лучше кастом написать
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }
}

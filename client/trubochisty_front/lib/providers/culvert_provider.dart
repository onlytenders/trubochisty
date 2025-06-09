import 'package:flutter/foundation.dart';
import '../models/culvert_data.dart';

class CulvertProvider extends ChangeNotifier {
  final List<CulvertData> _culverts = [];
  CulvertData? _selectedCulvert;
  String _searchQuery = '';
  
  // Getters
  List<CulvertData> get culverts => List.unmodifiable(_culverts);
  CulvertData? get selectedCulvert => _selectedCulvert;
  String get searchQuery => _searchQuery;
  
  // Filtered culverts based on search
  List<CulvertData> get filteredCulverts {
    if (_searchQuery.isEmpty) return _culverts;
    return _culverts.where((culvert) => culvert.matches(_searchQuery)).toList();
  }
  
  // Initialize with sample data
  CulvertProvider() {
    _initializeSampleData();
  }
  
  void _initializeSampleData() {
    _culverts.addAll([
      CulvertData(
        address: 'ул. Ленина, 25',
        coordinates: '55.7558° N, 37.6173° E',
        road: 'М-1 "Беларусь"',
        serialNumber: '001',
        diameter: '1.5',
        length: '12.0',
        material: 'Бетон',
        pipeType: 'Круглая',
        strengthRating: 4.2,
        safetyRating: 3.8,
        maintainabilityRating: 4.0,
        generalConditionRating: 4.0,
      ),
      CulvertData(
        address: 'пр. Мира, 108',
        coordinates: '55.7697° N, 37.6398° E',
        road: 'А-108 МКАД',
        serialNumber: '002',
        diameter: '2.0',
        length: '8.5',
        material: 'Сталь',
        pipeType: 'Прямоугольная',
        strengthRating: 3.5,
        safetyRating: 3.2,
        maintainabilityRating: 3.0,
        generalConditionRating: 3.2,
      ),
      CulvertData(
        address: 'Кутузовский проспект, 45',
        coordinates: '55.7414° N, 37.5332° E',
        road: 'М-1 "Беларусь"',
        serialNumber: '003',
        diameter: '1.8',
        length: '15.2',
        material: 'Бетон',
        pipeType: 'Круглая',
        strengthRating: 4.5,
        safetyRating: 4.1,
        maintainabilityRating: 4.3,
        generalConditionRating: 4.3,
      ),
      CulvertData(
        address: 'Тверская ул., 12',
        coordinates: '55.7558° N, 37.6176° E',
        road: 'А-101',
        serialNumber: '004',
        diameter: '1.2',
        length: '6.8',
        material: 'Пластик',
        pipeType: 'Круглая',
        strengthRating: 4.8,
        safetyRating: 4.6,
        maintainabilityRating: 4.7,
        generalConditionRating: 4.7,
      ),
    ]);
    
    // Select first culvert by default
    if (_culverts.isNotEmpty) {
      _selectedCulvert = _culverts.first;
    }
  }
  
  // Methods
  void selectCulvert(CulvertData culvert) {
    _selectedCulvert = culvert;
    notifyListeners();
  }
  
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
  
  void addCulvert(CulvertData culvert) {
    _culverts.add(culvert);
    notifyListeners();
  }
  
  void updateCulvert(CulvertData updatedCulvert) {
    final index = _culverts.indexWhere((c) => c == _selectedCulvert);
    if (index != -1) {
      _culverts[index] = updatedCulvert;
      _selectedCulvert = updatedCulvert;
      notifyListeners();
    }
  }
  
  void deleteCulvert(CulvertData culvert) {
    _culverts.remove(culvert);
    if (_selectedCulvert == culvert) {
      _selectedCulvert = _culverts.isNotEmpty ? _culverts.first : null;
    }
    notifyListeners();
  }
  
  void createNewCulvert() {
    // Create a unique new culvert with a temporary unique identifier
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final newCulvert = CulvertData(
      serialNumber: 'NEW_${timestamp}',
      address: '',
      coordinates: '',
      road: '',
    );
    _culverts.insert(0, newCulvert);
    _selectedCulvert = newCulvert;
    notifyListeners();
  }
  
  // Method to save current culvert before creating new one
  void createNewCulvertWithSave() {
    // Always save current state before creating new
    // The form will handle the actual saving logic
    createNewCulvert();
  }
} 
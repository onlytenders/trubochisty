import 'package:flutter/foundation.dart';
import '../models/culvert.dart';
import '../models/culvert_data.dart';
import '../services/api_service.dart';

class CulvertProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Culvert> _culverts = [];
  List<CulvertData> _culvertDataList = [];
  CulvertData? _selectedCulvert;
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  List<Culvert> get culverts => _culverts;
  List<CulvertData> get culvertDataList => _culvertDataList;
  List<CulvertData> get filteredCulverts => _getFilteredCulverts();
  CulvertData? get selectedCulvert => _selectedCulvert;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  // Get filtered culverts based on search query
  List<CulvertData> _getFilteredCulverts() {
    if (_searchQuery.isEmpty) {
      return _culvertDataList;
    }
    
    final query = _searchQuery.toLowerCase();
    return _culvertDataList.where((culvert) {
      return culvert.address.toLowerCase().contains(query) ||
             culvert.road.toLowerCase().contains(query) ||
             culvert.serialNumber.toLowerCase().contains(query) ||
             culvert.coordinates.toLowerCase().contains(query) ||
             culvert.material.toLowerCase().contains(query) ||
             culvert.pipeType.toLowerCase().contains(query);
    }).toList();
  }

  // Update search query and filter results
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void selectCulvert(CulvertData culvert) {
    _selectedCulvert = culvert;
    notifyListeners();
  }

  void clearSelection() {
    _selectedCulvert = null;
    notifyListeners();
  }

  Future<void> loadCulverts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _culverts = await _apiService.getAllCulverts();
      // Convert Culvert objects to CulvertData for UI
      _culvertDataList = _culverts.map((culvert) => _convertCulvertToCulvertData(culvert)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createCulvert(Culvert culvert) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newCulvert = await _apiService.createCulvert(culvert);
      _culverts.add(newCulvert);
      _culvertDataList.add(_convertCulvertToCulvertData(newCulvert));
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method for creating new culvert with default data
  void createNewCulvertWithSave() {
    final newCulvertData = CulvertData();
    selectCulvert(newCulvertData);
  }

  void updateCulvert(CulvertData updatedData) {
    if (_selectedCulvert != null) {
      _selectedCulvert = updatedData;
      notifyListeners();
    }
  }

  // NEW: Method to save culvert data to backend
  Future<void> saveCulvertToBackend(CulvertData culvertData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Convert CulvertData to Culvert for API
      final culvert = _convertCulvertDataToCulvert(culvertData);
      
      // Check if this is a new culvert (no existing ID)
      Culvert? existingCulvert;
      try {
        existingCulvert = _culverts.firstWhere((c) => c.serialNumber == culvertData.serialNumber);
      } catch (e) {
        existingCulvert = null;
      }
      
      if (existingCulvert == null) {
        // Create new culvert
        final newCulvert = await _apiService.createCulvert(culvert);
        _culverts.add(newCulvert);
        _culvertDataList.add(_convertCulvertToCulvertData(newCulvert));
        
        // Update selected culvert with the new data (including ID)
        if (_selectedCulvert?.serialNumber == culvertData.serialNumber) {
          _selectedCulvert = _convertCulvertToCulvertData(newCulvert);
        }
      } else {
        // Update existing culvert
        final updatedCulvert = await _apiService.updateCulvert(existingCulvert!.id, culvert);
        final index = _culverts.indexWhere((c) => c.id == existingCulvert!.id);
        if (index != -1) {
          _culverts[index] = updatedCulvert;
          _culvertDataList[index] = _convertCulvertToCulvertData(updatedCulvert);
        }
        
        // Update selected culvert
        if (_selectedCulvert?.serialNumber == culvertData.serialNumber) {
          _selectedCulvert = _convertCulvertToCulvertData(updatedCulvert);
        }
      }
    } catch (e) {
      _error = e.toString();
      rethrow; // Re-throw so UI can handle the error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCulvertOnServer(String id, Culvert culvert) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedCulvert = await _apiService.updateCulvert(id, culvert);
      final index = _culverts.indexWhere((c) => c.id == id);
      if (index != -1) {
        _culverts[index] = updatedCulvert;
        _culvertDataList[index] = _convertCulvertToCulvertData(updatedCulvert);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Updated to accept CulvertData parameter
  Future<void> deleteCulvert(CulvertData culvertData) async {
    // For now, we can't delete culverts that don't have an ID (new ones)
    if (culvertData.serialNumber.isEmpty) {
      // Just remove from UI if it's a new culvert
      if (_selectedCulvert == culvertData) {
        clearSelection();
      }
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Find the actual culvert by serial number
      final culvert = _culverts.firstWhere(
        (c) => c.serialNumber == culvertData.serialNumber,
        orElse: () => throw Exception('Culvert not found'),
      );
      
      await _apiService.deleteCulvert(culvert.id);
      _culverts.removeWhere((c) => c.id == culvert.id);
      _culvertDataList.removeWhere((c) => c.serialNumber == culvertData.serialNumber);
      
      if (_selectedCulvert == culvertData) {
        clearSelection();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchCulverts(String query) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _culverts = await _apiService.searchCulverts(query);
      _culvertDataList = _culverts.map((culvert) => _convertCulvertToCulvertData(culvert)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Helper method to convert Culvert to CulvertData
  CulvertData _convertCulvertToCulvertData(Culvert culvert) {
    return CulvertData(
      address: culvert.address,
      coordinates: culvert.coordinates,
      road: culvert.road,
      serialNumber: culvert.serialNumber,
      pipeType: culvert.pipeType,
      material: culvert.material,
      diameter: culvert.diameter.toString(),
      length: culvert.length.toString(),
      headType: culvert.headType,
      foundationType: culvert.foundationType,
      workType: culvert.workType,
      constructionYear: culvert.constructionYear.toString(),
      lastRepairDate: culvert.lastRepairDate,
      lastInspectionDate: culvert.lastInspectionDate,
      strengthRating: culvert.strengthRating,
      safetyRating: culvert.safetyRating,
      maintainabilityRating: culvert.maintainabilityRating,
      generalConditionRating: culvert.generalConditionRating,
      defects: culvert.defects,
      photos: culvert.photos,
    );
  }

  // Helper method to convert CulvertData to Culvert for API calls
  Culvert _convertCulvertDataToCulvert(CulvertData culvertData) {
    return Culvert(
      id: '', // Backend will generate this
      address: culvertData.address,
      coordinates: culvertData.coordinates,
      road: culvertData.road,
      serialNumber: culvertData.serialNumber,
      pipeType: culvertData.pipeType,
      material: culvertData.material,
      diameter: double.tryParse(culvertData.diameter) ?? 0.0,
      length: double.tryParse(culvertData.length) ?? 0.0,
      headType: culvertData.headType,
      foundationType: culvertData.foundationType,
      workType: culvertData.workType,
      constructionYear: int.tryParse(culvertData.constructionYear) ?? DateTime.now().year,
      lastRepairDate: culvertData.lastRepairDate,
      lastInspectionDate: culvertData.lastInspectionDate,
      strengthRating: culvertData.strengthRating,
      safetyRating: culvertData.safetyRating,
      maintainabilityRating: culvertData.maintainabilityRating,
      generalConditionRating: culvertData.generalConditionRating,
      defects: culvertData.defects,
      photos: culvertData.photos,
    );
  }
} 
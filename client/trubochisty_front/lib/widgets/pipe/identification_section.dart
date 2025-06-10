import 'package:flutter/material.dart';
import '../../models/culvert_data.dart';
import '../../controllers/identification_controller.dart';
import '../form_widgets/modern_text_field.dart';
import '../form_widgets/auto_button.dart';
import '../common/pipe_section_wrapper.dart';

class IdentificationSection extends StatefulWidget {
  final CulvertData data;
  final Function(CulvertData) onDataChanged;

  const IdentificationSection({
    super.key,
    required this.data,
    required this.onDataChanged,
  });

  @override
  IdentificationSectionState createState() => IdentificationSectionState();
}

class IdentificationSectionState extends State<IdentificationSection> {
  late final TextEditingController _addressController;
  late final TextEditingController _coordinatesController;
  late final TextEditingController _roadController;
  late final TextEditingController _serialNumberController;
  
  // Controller for business logic
  late final IdentificationController _controller;

  @override
  void initState() {
    super.initState();
    
    // Initialize text controllers
    _addressController = TextEditingController(text: widget.data.address);
    _coordinatesController = TextEditingController(text: widget.data.coordinates);
    _roadController = TextEditingController(text: widget.data.road);
    _serialNumberController = TextEditingController(text: widget.data.serialNumber);
    
    // Initialize business logic controller
    _controller = IdentificationController();
  }

  @override
  void didUpdateWidget(IdentificationSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      _updateControllers();
    }
  }

  void _updateControllers() {
    _addressController.text = widget.data.address;
    _coordinatesController.text = widget.data.coordinates;
    _roadController.text = widget.data.road;
    _serialNumberController.text = widget.data.serialNumber;
  }

  /// Method to get current form data (called when saving)
  CulvertData getCurrentData() {
    return widget.data.copyWith(
      address: _addressController.text,
      coordinates: _coordinatesController.text,
      road: _roadController.text,
      serialNumber: _serialNumberController.text,
    );
  }

  void _updateData() {
    widget.onDataChanged(widget.data.copyWith(
      address: _addressController.text,
      coordinates: _coordinatesController.text,
      road: _roadController.text,
      serialNumber: _serialNumberController.text,
    ));
  }

  /// Handles GPS location fetching with proper error handling
  Future<void> _handleGetGPSLocation() async {
    setState(() {}); // Trigger rebuild to show loading state
    
    try {
      final result = await _controller.getGPSCoordinates();
      
      if (result.isSuccess) {
        _coordinatesController.text = result.data!;
        _updateData();
        _showSuccessMessage('GPS координаты получены');
      } else {
        await _handleLocationError(result.error!, 'координат');
      }
    } catch (e) {
      _showErrorMessage('Неожиданная ошибка: ${e.toString()}');
    } finally {
      setState(() {}); // Trigger rebuild to hide loading state
    }
  }

  /// Handles GPS address fetching with proper error handling
  Future<void> _handleGetGPSAddress() async {
    setState(() {}); // Trigger rebuild to show loading state
    
    try {
      final result = await _controller.getGPSAddress();
      
      if (result.isSuccess) {
        _addressController.text = result.data!;
        _updateData();
        _showSuccessMessage('Адрес определен по GPS');
      } else {
        await _handleLocationError(result.error!, 'адреса');
      }
    } catch (e) {
      _showErrorMessage('Неожиданная ошибка: ${e.toString()}');
    } finally {
      setState(() {}); // Trigger rebuild to hide loading state
    }
  }

  /// Handles location errors with appropriate user actions
  Future<void> _handleLocationError(String error, String type) async {
    if (error.contains('отключены') || error.contains('заблокирован')) {
      await _showLocationSettingsDialog(error, type);
    } else {
      _showErrorMessage(error);
    }
  }

  /// Shows a dialog to guide user to location settings
  Future<void> _showLocationSettingsDialog(String error, String type) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Проблема с геолокацией'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(error),
            const SizedBox(height: 16),
            Text(
              'Для получения $type необходимо:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text('• Включить службы геолокации'),
            const Text('• Разрешить доступ к местоположению'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Открыть настройки'),
          ),
        ],
      ),
    );

    if (result == true) {
      await _controller.openLocationSettings();
    }
  }

  /// Shows success message
  void _showSuccessMessage(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Shows error message
  void _showErrorMessage(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    _coordinatesController.dispose();
    _roadController.dispose();
    _serialNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PipeSectionWrapper(
      title: 'Идентификационные данные',
      icon: Icons.fingerprint_rounded,
      iconColor: colorScheme.primary,
      children: [
        ModernTextField(
          label: 'Адрес',
          controller: _addressController,
          icon: Icons.location_on_rounded,
          suffixWidget: AutoButton(
            isLoading: _controller.isLoadingAddress,
            onPressed: _handleGetGPSAddress,
            tooltip: 'Определить адрес по GPS',
          ),
        ),
        ModernTextField(
          label: 'Координаты',
          controller: _coordinatesController,
          icon: Icons.gps_fixed_rounded,
          suffixWidget: AutoButton(
            isLoading: _controller.isLoadingCoordinates,
            onPressed: _handleGetGPSLocation,
            tooltip: 'Получить GPS координаты',
          ),
        ),
        ModernTextField(
          label: 'Автодорога',
          controller: _roadController,
          icon: Icons.route_rounded,
        ),
        ModernTextField(
          label: 'Порядковый номер',
          controller: _serialNumberController,
          icon: Icons.tag_rounded,
        ),
      ],
    );
  }
} 
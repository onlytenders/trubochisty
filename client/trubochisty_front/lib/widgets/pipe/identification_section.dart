import 'package:flutter/material.dart';
import '../../models/culvert_data.dart';
import '../form_widgets/modern_text_field.dart';
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

  @override
  void initState() {
    super.initState();
    
    _addressController = TextEditingController(text: widget.data.address);
    _coordinatesController = TextEditingController(text: widget.data.coordinates);
    _roadController = TextEditingController(text: widget.data.road);
    _serialNumberController = TextEditingController(text: widget.data.serialNumber);
    
    // Remove listeners - only update on save, not on every keystroke
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

  // Method to get current form data (called when saving)
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
        ),
        ModernTextField(
          label: 'Координаты',
          controller: _coordinatesController,
          icon: Icons.gps_fixed_rounded,
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
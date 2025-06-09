import 'package:flutter/material.dart';
import '../../models/culvert_data.dart';
import '../form_widgets/modern_text_field.dart';
import '../form_widgets/modern_dropdown.dart';
import '../common/pipe_section_wrapper.dart';

class TechnicalSection extends StatefulWidget {
  final CulvertData data;
  final Function(CulvertData) onDataChanged;

  const TechnicalSection({
    super.key,
    required this.data,
    required this.onDataChanged,
  });

  @override
  TechnicalSectionState createState() => TechnicalSectionState();
}

class TechnicalSectionState extends State<TechnicalSection> {
  late final TextEditingController _diameterController;
  late final TextEditingController _lengthController;

  @override
  void initState() {
    super.initState();
    
    _diameterController = TextEditingController(text: widget.data.diameter);
    _lengthController = TextEditingController(text: widget.data.length);
    
    // Remove listeners - only update on save, not on every keystroke
  }

  @override
  void didUpdateWidget(TechnicalSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      _updateControllers();
    }
  }

  void _updateControllers() {
    _diameterController.text = widget.data.diameter;
    _lengthController.text = widget.data.length;
  }

  // Method to get current form data (called when saving)
  CulvertData getCurrentData() {
    return widget.data.copyWith(
      diameter: _diameterController.text,
      length: _lengthController.text,
    );
  }

  void _updateData() {
    widget.onDataChanged(widget.data.copyWith(
      diameter: _diameterController.text,
      length: _lengthController.text,
    ));
  }

  @override
  void dispose() {
    _diameterController.dispose();
    _lengthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PipeSectionWrapper(
      title: 'Технические параметры',
      icon: Icons.precision_manufacturing_rounded,
      iconColor: colorScheme.secondary,
      children: [
        ModernDropdown(
          label: 'Тип трубы',
          value: widget.data.pipeType,
          options: const ['Круглая', 'Прямоугольная', 'Малый мост'],
          icon: Icons.category_rounded,
          onChanged: (value) {
            widget.onDataChanged(widget.data.copyWith(pipeType: value!));
          },
        ),
        ModernDropdown(
          label: 'Материал',
          value: widget.data.material,
          options: const ['Бетон', 'Сталь', 'Пластик', 'Кирпич'],
          icon: Icons.construction_rounded,
          onChanged: (value) {
            widget.onDataChanged(widget.data.copyWith(material: value!));
          },
        ),
        ModernTextField(
          label: 'Диаметр/отверстие',
          controller: _diameterController,
          icon: Icons.straighten_rounded,
          suffix: 'м',
        ),
        ModernTextField(
          label: 'Длина',
          controller: _lengthController,
          icon: Icons.height_rounded,
          suffix: 'м',
        ),
      ],
    );
  }
} 
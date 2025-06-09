import 'package:flutter/material.dart';
import '../../models/culvert_data.dart';
import '../form_widgets/modern_text_field.dart';
import '../common/pipe_section_wrapper.dart';

class AdditionalSection extends StatefulWidget {
  final CulvertData data;
  final Function(CulvertData) onDataChanged;

  const AdditionalSection({
    super.key,
    required this.data,
    required this.onDataChanged,
  });

  @override
  AdditionalSectionState createState() => AdditionalSectionState();
}

class AdditionalSectionState extends State<AdditionalSection> {
  late final TextEditingController _constructionYearController;

  @override
  void initState() {
    super.initState();
    
    _constructionYearController = TextEditingController(text: widget.data.constructionYear);
  }

  @override
  void didUpdateWidget(AdditionalSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      _updateControllers();
    }
  }

  void _updateControllers() {
    _constructionYearController.text = widget.data.constructionYear;
  }

  // Method to get current form data (called when saving)
  CulvertData getCurrentData() {
    return widget.data.copyWith(
      constructionYear: _constructionYearController.text,
    );
  }

  void _updateData() {
    widget.onDataChanged(widget.data.copyWith(
      constructionYear: _constructionYearController.text,
    ));
  }

  @override
  void dispose() {
    _constructionYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PipeSectionWrapper(
      title: 'Дополнительные данные',
      icon: Icons.event_note_rounded,
      iconColor: colorScheme.tertiary,
      children: [
        ModernTextField(
          label: 'Год постройки',
          controller: _constructionYearController,
          icon: Icons.calendar_today_rounded,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
} 
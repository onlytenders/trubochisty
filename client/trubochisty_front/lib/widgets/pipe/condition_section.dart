import 'package:flutter/material.dart';
import '../../models/culvert_data.dart';
import '../common/pipe_section_wrapper.dart';

class ConditionSection extends StatefulWidget {
  final CulvertData data;
  final Function(CulvertData) onDataChanged;

  const ConditionSection({
    super.key,
    required this.data,
    required this.onDataChanged,
  });

  @override
  State<ConditionSection> createState() => _ConditionSectionState();
}

class _ConditionSectionState extends State<ConditionSection> {
  void _updateRating(String type, double value) {
    switch (type) {
      case 'strength':
        widget.onDataChanged(widget.data.copyWith(strengthRating: value));
        break;
      case 'safety':
        widget.onDataChanged(widget.data.copyWith(safetyRating: value));
        break;
      case 'maintainability':
        widget.onDataChanged(widget.data.copyWith(maintainabilityRating: value));
        break;
      default:
        widget.onDataChanged(widget.data.copyWith(generalConditionRating: value));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PipeSectionWrapper(
      title: 'Состояние трубы',
      icon: Icons.assessment_rounded,
      iconColor: colorScheme.tertiary,
      children: [
        _buildRatingSlider('Прочность', widget.data.strengthRating, 'strength'),
        _buildRatingSlider('Безопасность', widget.data.safetyRating, 'safety'),
        _buildRatingSlider('Ремонтопригодность', widget.data.maintainabilityRating, 'maintainability'),
        _buildRatingSlider('Общее состояние', widget.data.generalConditionRating, 'general'),
      ],
    );
  }

  Widget _buildRatingSlider(String label, double value, String type) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${value.toStringAsFixed(1)}/5.0',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: colorScheme.primary,
            inactiveTrackColor: colorScheme.outline.withOpacity(0.3),
            thumbColor: colorScheme.primary,
            overlayColor: colorScheme.primary.withOpacity(0.1),
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: 1.0,
            max: 5.0,
            divisions: 8,
            onChanged: (newValue) => _updateRating(type, newValue),
          ),
        ),
      ],
    );
  }
} 
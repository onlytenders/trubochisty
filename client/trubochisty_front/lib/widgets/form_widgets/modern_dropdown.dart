import 'package:flutter/material.dart';

class ModernDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final IconData icon;
  final ValueChanged<String?> onChanged;

  const ModernDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: colorScheme.primary.withOpacity(0.7)),
          filled: true,
          fillColor: colorScheme.surface.withOpacity(0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
          labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        items: options.map((option) => DropdownMenuItem(
          value: option,
          child: Text(option, style: TextStyle(color: colorScheme.onSurface)),
        )).toList(),
        onChanged: onChanged,
        dropdownColor: colorScheme.surface,
        icon: Icon(Icons.keyboard_arrow_down_rounded, color: colorScheme.primary),
      ),
    );
  }
} 
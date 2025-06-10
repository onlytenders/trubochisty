import 'package:flutter/material.dart';

class ModernTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String? suffix;
  final Widget? suffixWidget;
  final TextInputType? keyboardType;
  final VoidCallback? onSuffixPressed;

  const ModernTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    this.suffix,
    this.suffixWidget,
    this.keyboardType,
    this.onSuffixPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: colorScheme.onSurface),
        decoration: InputDecoration(
          labelText: label,
          suffixText: suffixWidget == null ? suffix : null,
          suffixIcon: suffixWidget,
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
      ),
    );
  }
} 
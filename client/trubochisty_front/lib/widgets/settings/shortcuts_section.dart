import 'package:flutter/material.dart';
import '../../services/shortcuts_service.dart';
import '../common/settings_section_wrapper.dart';

class ShortcutsSection extends StatefulWidget {
  const ShortcutsSection({super.key});

  @override
  State<ShortcutsSection> createState() => _ShortcutsSectionState();
}

class _ShortcutsSectionState extends State<ShortcutsSection> {
  bool _showShortcuts = false;

  @override
  Widget build(BuildContext context) {
    // Don't show shortcuts section if no shortcuts are available (like on web)
    if (!ShortcutsService.hasShortcuts) {
      return const SizedBox.shrink();
    }
    
    final colorScheme = Theme.of(context).colorScheme;
    
    return SettingsSectionWrapper(
      title: ShortcutsService.getShortcutType(),
      icon: ShortcutsService.isDesktop || ShortcutsService.isWeb 
          ? Icons.keyboard_rounded 
          : Icons.touch_app_rounded,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Column(
            children: [
              _buildToggleButton(colorScheme),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: _showShortcuts 
                    ? _buildShortcutsList() 
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton(ColorScheme colorScheme) {
    return InkWell(
      onTap: () {
        setState(() {
          _showShortcuts = !_showShortcuts;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.help_outline_rounded,
              color: colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Показать все ${ShortcutsService.isDesktop || ShortcutsService.isWeb ? "сокращения" : "жесты"}',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              _showShortcuts 
                  ? Icons.keyboard_arrow_up_rounded 
                  : Icons.keyboard_arrow_down_rounded,
              color: colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcutsList() {
    final shortcuts = ShortcutsService.getAvailableShortcuts();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: shortcuts.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8, 
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: colorScheme.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    entry.key,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    entry.value,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
} 
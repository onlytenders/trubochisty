import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../common/settings_section_wrapper.dart';

class ThemeSection extends StatelessWidget {
  const ThemeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return SettingsSectionWrapper(
          title: 'Внешний вид',
          icon: Icons.palette_rounded,
          children: [
            _buildThemeOption(
              'Светлая тема',
              Icons.light_mode_rounded,
              ThemeMode.light,
              themeProvider,
              context,
            ),
            _buildThemeOption(
              'Тёмная тема',
              Icons.dark_mode_rounded,
              ThemeMode.dark,
              themeProvider,
              context,
            ),
            _buildThemeOption(
              'Системная тема',
              Icons.brightness_auto_rounded,
              ThemeMode.system,
              themeProvider,
              context,
            ),
          ],
        );
      },
    );
  }

  Widget _buildThemeOption(
    String title,
    IconData icon,
    ThemeMode mode,
    ThemeProvider themeProvider,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = themeProvider.themeMode == mode;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => themeProvider.setThemeMode(mode),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected 
                  ? colorScheme.primaryContainer.withOpacity(0.3)
                  : colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected 
                    ? colorScheme.primary.withOpacity(0.5)
                    : colorScheme.outline.withOpacity(0.1),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected 
                      ? colorScheme.primary 
                      : colorScheme.onSurface.withOpacity(0.7),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected 
                          ? colorScheme.primary 
                          : colorScheme.onSurface,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle_rounded,
                    color: colorScheme.primary,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 
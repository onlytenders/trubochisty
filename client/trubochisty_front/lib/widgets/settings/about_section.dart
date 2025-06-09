import 'package:flutter/material.dart';
import '../common/settings_section_wrapper.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SettingsSectionWrapper(
      title: 'О приложении',
      icon: Icons.info_outline_rounded,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.tertiaryContainer.withOpacity(0.3),
                colorScheme.surfaceVariant.withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primary,
                          colorScheme.secondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.water_rounded,
                      color: colorScheme.onPrimary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TruboСhisty',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Система управления трубами',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildInfoRow('Версия', '1.0.0', theme, colorScheme),
              const SizedBox(height: 12),
              _buildInfoRow('Сборка', '2024.01.15', theme, colorScheme),
              const SizedBox(height: 12),
              _buildInfoRow('Разработчик', 'TruboСhisty Team', theme, colorScheme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    String label, 
    String value, 
    ThemeData theme, 
    ColorScheme colorScheme,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
} 
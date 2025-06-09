import 'package:flutter/material.dart';

class SettingsHeader extends StatelessWidget {
  final bool isFullScreen;

  const SettingsHeader({
    super.key,
    this.isFullScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        isFullScreen ? MediaQuery.of(context).padding.top + 16 : 24,
        24,
        16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer.withOpacity(0.3),
            colorScheme.secondaryContainer.withOpacity(0.3),
          ],
        ),
        borderRadius: isFullScreen 
            ? null 
            : const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
      ),
      child: Row(
        children: [
          if (isFullScreen)
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: colorScheme.onSurface,
              ),
            ),
          if (isFullScreen) const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.settings_rounded,
              color: colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Настройки',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  'Управление аккаунтом и приложением',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          if (!isFullScreen)
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.close_rounded,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
        ],
      ),
    );
  }
} 
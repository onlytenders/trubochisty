import 'package:flutter/material.dart';

class DangerButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const DangerButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.errorContainer.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.error.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: colorScheme.error,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: colorScheme.error,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
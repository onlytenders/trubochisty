import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../common/settings_section_wrapper.dart';
import '../common/user_avatar.dart';
import '../common/danger_button.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final user = authProvider.user!;
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return SettingsSectionWrapper(
          title: 'Аккаунт',
          icon: Icons.person_rounded,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primaryContainer.withOpacity(0.3),
                    colorScheme.secondaryContainer.withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.1),
                ),
              ),
              child: Row(
                children: [
                  UserAvatar(user: user, size: 48),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildRoleBadge(user.role, theme, colorScheme),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            DangerButton(
              title: 'Выйти из аккаунта',
              icon: Icons.logout_rounded,
              onTap: () async {
                await authProvider.signOut();
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildRoleBadge(String role, ThemeData theme, ColorScheme colorScheme) {
    final color = _getRoleColor(role);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        _getRoleDisplayName(role),
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.red;
      case 'engineer':
        return Colors.blue;
      case 'viewer':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getRoleDisplayName(String role) {
    switch (role) {
      case 'admin':
        return 'Администратор';
      case 'engineer':
        return 'Инженер';
      case 'viewer':
        return 'Наблюдатель';
      default:
        return role;
    }
  }
} 
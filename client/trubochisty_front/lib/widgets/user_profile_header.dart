import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import 'settings/settings_screen.dart';

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final user = authProvider.user;
        if (user == null) return const SizedBox.shrink();

        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primaryContainer.withOpacity(0.3),
                colorScheme.secondaryContainer.withOpacity(0.2),
              ],
            ),
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outline.withOpacity(0.1),
              ),
            ),
          ),
          child: Row(
            children: [
              _buildAvatar(user, colorScheme),
              const SizedBox(width: 12),
              Expanded(
                child: _buildUserInfo(user, theme, colorScheme),
              ),
              _buildSettingsButton(context, colorScheme),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatar(User user, ColorScheme colorScheme) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: user.avatarUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                user.avatarUrl!,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildInitialsAvatar(user, colorScheme),
              ),
            )
          : _buildInitialsAvatar(user, colorScheme),
    );
  }

  Widget _buildInitialsAvatar(User user, ColorScheme colorScheme) {
    return Center(
      child: Text(
        user.initials,
        style: TextStyle(
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildUserInfo(User user, ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          user.name,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _getRoleColor(user.role).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getRoleColor(user.role).withOpacity(0.3),
                ),
              ),
              child: Text(
                _getRoleDisplayName(user.role),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: _getRoleColor(user.role),
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsButton(BuildContext context, ColorScheme colorScheme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showSettings(context),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.surface.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.settings_rounded,
            size: 20,
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ),
    );
  }

  void _showSettings(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 768;
    
    if (isMobile) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const SettingsScreen(isFullScreen: true),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => const SettingsScreen(isFullScreen: false),
      );
    }
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
        return 'Админ';
      case 'engineer':
        return 'Инженер';
      case 'viewer':
        return 'Просмотр';
      default:
        return role;
    }
  }
} 
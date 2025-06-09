import 'package:flutter/material.dart';
import '../../models/user.dart';

class UserAvatar extends StatelessWidget {
  final User user;
  final double size;

  const UserAvatar({
    super.key,
    required this.user,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(size / 2),
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
              borderRadius: BorderRadius.circular(size / 2),
              child: Image.network(
                user.avatarUrl!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildInitialsAvatar(),
              ),
            )
          : _buildInitialsAvatar(),
    );
  }

  Widget _buildInitialsAvatar() {
    return Builder(
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        
        return Center(
          child: Text(
            user.initials,
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: size * 0.35,
            ),
          ),
        );
      },
    );
  }
} 
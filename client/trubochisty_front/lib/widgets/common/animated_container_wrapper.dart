import 'package:flutter/material.dart';

class AnimatedContainerWrapper extends StatelessWidget {
  final Widget child;
  final bool isFullScreen;

  const AnimatedContainerWrapper({
    super.key,
    required this.child,
    this.isFullScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: isFullScreen ? BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer.withOpacity(0.1),
            colorScheme.secondaryContainer.withOpacity(0.1),
          ],
        ),
      ) : null,
      child: child,
    );
  }
} 
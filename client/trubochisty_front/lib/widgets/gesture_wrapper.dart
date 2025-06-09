import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/shortcuts_service.dart';

class GestureWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback? onOpenSidebar;
  final VoidCallback? onCloseSidebar;
  final bool sidebarVisible;

  const GestureWrapper({
    super.key,
    required this.child,
    this.onOpenSidebar,
    this.onCloseSidebar,
    this.sidebarVisible = false,
  });

  @override
  State<GestureWrapper> createState() => _GestureWrapperState();
}

class _GestureWrapperState extends State<GestureWrapper>
    with TickerProviderStateMixin {
  late AnimationController _swipeAnimationController;
  late Animation<double> _swipeAnimation;

  @override
  void initState() {
    super.initState();
    _swipeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _swipeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _swipeAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _swipeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ShortcutsService.isMobile) {
      return GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        onTap: _onTap,
        onDoubleTap: _onDoubleTap,
        child: AnimatedBuilder(
          animation: _swipeAnimation,
          builder: (context, _) {
            return Transform.translate(
              offset: Offset(_swipeAnimation.value * 10, 0),
              child: widget.child,
            );
          },
        ),
      );
    } else {
      return widget.child;
    }
  }

  void _onPanStart(DragStartDetails details) {
    // Reset animation
    _swipeAnimationController.reset();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final dx = details.delta.dx;
    
    // Animate on swipe for visual feedback
    if (dx.abs() > 2) {
      _swipeAnimationController.forward().then((_) {
        _swipeAnimationController.reverse();
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond.dx;
    
    // Swipe right to open sidebar
    if (velocity > 500 && !widget.sidebarVisible) {
      widget.onOpenSidebar?.call();
      _showGestureHint('Боковая панель открыта');
    }
    // Swipe left to close sidebar
    else if (velocity < -500 && widget.sidebarVisible) {
      widget.onCloseSidebar?.call();
      _showGestureHint('Боковая панель закрыта');
    }
    // Swipe down to refresh
    else if (details.velocity.pixelsPerSecond.dy > 800) {
      _refreshCulverts();
    }
  }

  void _onTap() {
    // Single tap - basic selection handled by child widgets
  }

  void _onDoubleTap() {
    // Double tap to toggle theme
    context.read<ThemeProvider>().toggleTheme();
    _showGestureHint('Тема переключена');
  }

  void _refreshCulverts() {
    // Add haptic feedback
    HapticFeedback.mediumImpact();
    
    // Simulate refresh - in a real app, this would refresh data from server
    _showGestureHint('Список обновлён');
  }

  void _showGestureHint(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.touch_app_rounded,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(message),
          ],
        ),
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 150,
          left: 20,
          right: 20,
        ),
      ),
    );
  }
} 
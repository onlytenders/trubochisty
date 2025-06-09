import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/animated_container_wrapper.dart';
import 'settings_header.dart';
import 'account_section.dart';
import 'theme_section.dart';
import 'shortcuts_section.dart';
import 'about_section.dart';

class SettingsScreen extends StatefulWidget {
  final bool isFullScreen;

  const SettingsScreen({
    super.key,
    this.isFullScreen = false,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: widget.isFullScreen 
          ? const Offset(1.0, 0) 
          : const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isFullScreen) {
      return _buildFullScreenSettings();
    } else {
      return _buildModalSettings();
    }
  }

  Widget _buildFullScreenSettings() {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: _buildSettingsContent(),
        ),
      ),
    );
  }

  Widget _buildModalSettings() {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 500,
              maxHeight: 700,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: _buildSettingsContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsContent() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedContainerWrapper(
      isFullScreen: widget.isFullScreen,
      child: Column(
        children: [
          SettingsHeader(isFullScreen: widget.isFullScreen),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AccountSection(),
                  const SizedBox(height: 32),
                  const ThemeSection(),
                  const SizedBox(height: 32),
                  const ShortcutsSection(),
                  const SizedBox(height: 32),
                  const AboutSection(),
                  if (!widget.isFullScreen) const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          if (!widget.isFullScreen) _buildModalActions(),
        ],
      ),
    );
  }

  Widget _buildModalActions() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Закрыть'),
            ),
          ),
        ],
      ),
    );
  }
} 
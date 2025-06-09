import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/culvert_provider.dart';
import '../widgets/culvert_sidebar.dart';
import '../widgets/pipe_card.dart';
import '../widgets/gesture_wrapper.dart';
import '../widgets/settings/settings_screen.dart';
import '../services/shortcuts_service.dart';

class CulvertManagementScreen extends StatefulWidget {
  const CulvertManagementScreen({super.key});

  @override
  State<CulvertManagementScreen> createState() => _CulvertManagementScreenState();
}

class _CulvertManagementScreenState extends State<CulvertManagementScreen>
    with TickerProviderStateMixin {
  bool _isSidebarOpen = false;
  late AnimationController _sidebarAnimationController;
  late AnimationController _headerAnimationController;
  late Animation<Offset> _sidebarSlideAnimation;
  late Animation<double> _headerFadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _sidebarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _sidebarSlideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _sidebarAnimationController,
      curve: Curves.easeInOut,
    ));

    _headerFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start header animation
    _headerAnimationController.forward();
  }

  @override
  void dispose() {
    _sidebarAnimationController.dispose();
    _headerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1200;
    final isDesktop = screenWidth >= 1200;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: GestureWrapper(
          sidebarVisible: _isSidebarOpen,
          onOpenSidebar: _openSidebar,
          onCloseSidebar: _closeSidebar,
          child: Row(
            children: [
              // Sidebar - Always visible on desktop, overlay on mobile
              if (isDesktop || (isTablet && !_isSidebarOpen))
                const CulvertSidebar(),
              
              // Main content area
              Expanded(
                child: Stack(
                  children: [
                    // Main content
                    _buildMainContent(isMobile, isTablet, isDesktop),
                    
                    // Mobile sidebar overlay
                    if (isMobile && _isSidebarOpen)
                      _buildMobileSidebar(),
                    
                    // Mobile header with search icon
                    if (isMobile)
                      _buildMobileHeader(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openSidebar() {
    setState(() {
      _isSidebarOpen = true;
    });
    _sidebarAnimationController.forward();
  }

  void _closeSidebar() {
    _sidebarAnimationController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _isSidebarOpen = false;
        });
      }
    });
  }

  Widget _buildMainContent(bool isMobile, bool isTablet, bool isDesktop) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      constraints: BoxConstraints(
        maxWidth: isDesktop ? 1200 : double.infinity,
      ),
      child: Center(
        child: Consumer<CulvertProvider>(
          builder: (context, provider, _) {
            if (provider.selectedCulvert == null) {
              return _buildEmptyState();
            }
            
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.05, 0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    )),
                    child: child,
                  ),
                );
              },
              child: Padding(
                key: ValueKey('${provider.selectedCulvert!.serialNumber}_${provider.selectedCulvert!.address}'),
                padding: EdgeInsets.only(
                  top: isMobile ? 60 : 0, // Account for mobile header
                  left: isMobile ? 16 : 24,
                  right: isMobile ? 16 : 24,
                  bottom: 16,
                ),
                child: PipeCard(
                  initialData: provider.selectedCulvert,
                  onDataChanged: provider.updateCulvert,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMobileHeader() {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: _headerFadeAnimation,
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: colorScheme.surface.withOpacity(0.95),
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outline.withOpacity(0.1),
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _openSidebar,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.search_rounded,
                      color: colorScheme.primary,
                      size: 28,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Consumer<CulvertProvider>(
                  builder: (context, provider, _) {
                    final culvert = provider.selectedCulvert;
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Column(
                        key: ValueKey('${culvert?.serialNumber ?? 'empty'}_${culvert?.address ?? ''}'),
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            culvert?.displayTitle ?? 'Выберите трубу',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (culvert?.road.isNotEmpty ?? false)
                            Text(
                              culvert!.road,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.7),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Settings button for mobile
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _showSettings,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.settings_rounded,
                      color: colorScheme.onSurface.withOpacity(0.7),
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileSidebar() {
    return Positioned.fill(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: Colors.black.withOpacity(_isSidebarOpen ? 0.6 : 0),
        child: GestureDetector(
          onTap: _closeSidebar,
          child: Material(
            color: Colors.transparent,
            child: SlideTransition(
              position: _sidebarSlideAnimation,
              child: Align(
                alignment: Alignment.centerLeft,
                child: CulvertSidebar(
                  isMobile: true,
                  onClose: _closeSidebar,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primaryContainer.withOpacity(0.2),
                            colorScheme.secondaryContainer.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.water_rounded,
                        size: 64,
                        color: colorScheme.primary.withOpacity(0.7),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, (1 - value) * 20),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  children: [
                    Text(
                      'Выберите трубу для просмотра',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.8),
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      ShortcutsService.isMobile 
                          ? 'Свайпните вправо или нажмите на иконку поиска'
                          : 'Используйте боковую панель для поиска и выбора трубы',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (ShortcutsService.isDesktop) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colorScheme.primary.withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          '${ShortcutsService.modifierKey}+N для создания новой трубы',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.primary,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(isFullScreen: true),
      ),
    );
  }
} 
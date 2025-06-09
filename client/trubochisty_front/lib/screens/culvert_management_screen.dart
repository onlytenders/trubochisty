import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/culvert_provider.dart';
import '../widgets/culvert_sidebar.dart';
import '../widgets/pipe_card.dart';

class CulvertManagementScreen extends StatefulWidget {
  const CulvertManagementScreen({super.key});

  @override
  State<CulvertManagementScreen> createState() => _CulvertManagementScreenState();
}

class _CulvertManagementScreenState extends State<CulvertManagementScreen> {
  bool _isSidebarOpen = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1200;
    final isDesktop = screenWidth >= 1200;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
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
    );
  }

  Widget _buildMainContent(bool isMobile, bool isTablet, bool isDesktop) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: isDesktop ? 1200 : double.infinity,
      ),
      child: Center(
        child: Consumer<CulvertProvider>(
          builder: (context, provider, _) {
            if (provider.selectedCulvert == null) {
              return _buildEmptyState();
            }
            
            return Padding(
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
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _isSidebarOpen = true;
                });
              },
              icon: Icon(
                Icons.search_rounded,
                color: colorScheme.primary,
                size: 28,
              ),
              tooltip: 'Поиск труб',
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Consumer<CulvertProvider>(
                builder: (context, provider, _) {
                  final culvert = provider.selectedCulvert;
                  return Column(
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileSidebar() {
    return Positioned.fill(
      child: Material(
        color: Colors.black54,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _isSidebarOpen = false;
            });
          },
          child: Container(
            color: Colors.transparent,
            child: Align(
              alignment: Alignment.centerLeft,
              child: CulvertSidebar(
                isMobile: true,
                onClose: () {
                  setState(() {
                    _isSidebarOpen = false;
                  });
                },
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
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.water_rounded,
                size: 64,
                color: colorScheme.primary.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
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
              'Используйте боковую панель для поиска и выбора трубы',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 
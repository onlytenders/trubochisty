import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/culvert_data.dart';
import '../providers/culvert_provider.dart';
import 'user_profile_header.dart';

class CulvertSidebar extends StatefulWidget {
  final bool isMobile;
  final VoidCallback? onClose;

  const CulvertSidebar({
    super.key,
    this.isMobile = false,
    this.onClose,
  });

  @override
  State<CulvertSidebar> createState() => _CulvertSidebarState();
}

class _CulvertSidebarState extends State<CulvertSidebar>
    with TickerProviderStateMixin {
  late TextEditingController _searchController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    
    _fadeController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: widget.isMobile ? double.infinity : 380,
        height: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: widget.isMobile ? null : [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(2, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            const UserProfileHeader(),
            _buildHeader(colorScheme),
            _buildSearchBar(colorScheme),
            Expanded(
              child: _buildCulvertList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 10,
        20,
        10,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          if (widget.isMobile) ...[
            IconButton(
              onPressed: widget.onClose,
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Icon(
            Icons.water_rounded,
            color: colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Трубы',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                Consumer<CulvertProvider>(
                  builder: (context, provider, _) {
                    final count = provider.filteredCulverts.length;
                    return Text(
                      '$count ${_getPluralForm(count)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Consumer<CulvertProvider>(
            builder: (context, provider, _) {
              return IconButton(
                onPressed: () {
                  provider.createNewCulvertWithSave();
                  if (widget.isMobile) {
                    widget.onClose?.call();
                  }
                },
                icon: Icon(
                  Icons.add_rounded,
                  color: colorScheme.primary,
                ),
                tooltip: 'Добавить трубу',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withOpacity(0.1),
          ),
        ),
      ),
      child: Consumer<CulvertProvider>(
        builder: (context, provider, _) {
          return TextField(
            controller: _searchController,
            onChanged: provider.updateSearchQuery,
            decoration: InputDecoration(
              hintText: 'Поиск труб...',
              prefixIcon: Icon(
                Icons.search_rounded,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        provider.updateSearchQuery('');
                      },
                      icon: Icon(
                        Icons.clear_rounded,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    )
                  : null,
              filled: true,
              fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCulvertList() {
    return Consumer<CulvertProvider>(
      builder: (context, provider, _) {
        final culverts = provider.filteredCulverts;
        
        if (culverts.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: culverts.length,
          itemBuilder: (context, index) {
            final culvert = culverts[index];
            final isSelected = provider.selectedCulvert == culvert;
            
            return _buildCulvertTile(culvert, isSelected, provider);
          },
        );
      },
    );
  }

  Widget _buildCulvertTile(
    CulvertData culvert, 
    bool isSelected, 
    CulvertProvider provider,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected 
            ? colorScheme.primaryContainer.withOpacity(0.3)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isSelected 
            ? Border.all(color: colorScheme.primary.withOpacity(0.3))
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            provider.selectCulvert(culvert);
            if (widget.isMobile) {
              widget.onClose?.call();
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getConditionColor(culvert.generalConditionRating)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.water_rounded,
                        size: 20,
                        color: _getConditionColor(culvert.generalConditionRating),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            culvert.displayTitle,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (culvert.road.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              culvert.road,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.7),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle_rounded,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoChip(
                      '${culvert.material} • ${culvert.pipeType}',
                      Icons.info_outline_rounded,
                      colorScheme,
                    ),
                    const Spacer(),
                    _buildRatingChip(
                      culvert.generalConditionRating,
                      colorScheme,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingChip(double rating, ColorScheme colorScheme) {
    final color = _getConditionColor(rating);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        rating.toStringAsFixed(1),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 10,
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
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Ничего не найдено',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Попробуйте изменить поисковый запрос',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getConditionColor(double rating) {
    if (rating >= 4.0) return Colors.green;
    if (rating >= 3.0) return Colors.orange;
    return Colors.red;
  }

  String _getPluralForm(int count) {
    if (count % 10 == 1 && count % 100 != 11) return 'труба';
    if (count % 10 >= 2 && count % 10 <= 4 && (count % 100 < 10 || count % 100 >= 20)) return 'трубы';
    return 'труб';
  }
} 
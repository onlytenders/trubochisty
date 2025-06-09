import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/culvert_data.dart';
import 'form_widgets/modern_text_field.dart';
import 'form_widgets/modern_dropdown.dart';

class PipeCard extends StatefulWidget {
  final CulvertData? initialData;
  final Function(CulvertData)? onDataChanged;
  
  const PipeCard({
    super.key,
    this.initialData,
    this.onDataChanged,
  });

  @override
  State<PipeCard> createState() => _PipeCardState();
}

class _PipeCardState extends State<PipeCard> with TickerProviderStateMixin {
  late CulvertData _culvertData;
  
  // Controllers for form fields
  late final TextEditingController _addressController;
  late final TextEditingController _coordinatesController;
  late final TextEditingController _roadController;
  late final TextEditingController _serialNumberController;
  late final TextEditingController _diameterController;
  late final TextEditingController _lengthController;
  late final TextEditingController _constructionYearController;
  
  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _culvertData = widget.initialData ?? CulvertData();
    
    // Initialize controllers
    _addressController = TextEditingController(text: _culvertData.address);
    _coordinatesController = TextEditingController(text: _culvertData.coordinates);
    _roadController = TextEditingController(text: _culvertData.road);
    _serialNumberController = TextEditingController(text: _culvertData.serialNumber);
    _diameterController = TextEditingController(text: _culvertData.diameter);
    _lengthController = TextEditingController(text: _culvertData.length);
    _constructionYearController = TextEditingController(text: _culvertData.constructionYear);
    
    // Add listeners
    _addressController.addListener(() => _updateData(() => _culvertData.address = _addressController.text));
    _coordinatesController.addListener(() => _updateData(() => _culvertData.coordinates = _coordinatesController.text));
    _roadController.addListener(() => _updateData(() => _culvertData.road = _roadController.text));
    _serialNumberController.addListener(() => _updateData(() => _culvertData.serialNumber = _serialNumberController.text));
    _diameterController.addListener(() => _updateData(() => _culvertData.diameter = _diameterController.text));
    _lengthController.addListener(() => _updateData(() => _culvertData.length = _lengthController.text));
    _constructionYearController.addListener(() => _updateData(() => _culvertData.constructionYear = _constructionYearController.text));
    
    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void didUpdateWidget(PipeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialData != oldWidget.initialData && widget.initialData != null) {
      _updateControllers(widget.initialData!);
    }
  }

  void _updateControllers(CulvertData data) {
    _culvertData = data;
    _addressController.text = data.address;
    _coordinatesController.text = data.coordinates;
    _roadController.text = data.road;
    _serialNumberController.text = data.serialNumber;
    _diameterController.text = data.diameter;
    _lengthController.text = data.length;
    _constructionYearController.text = data.constructionYear;
  }
  
  void _updateData(VoidCallback update) {
    update();
    widget.onDataChanged?.call(_culvertData);
  }

  @override
  void dispose() {
    _addressController.dispose();
    _coordinatesController.dispose();
    _roadController.dispose();
    _serialNumberController.dispose();
    _diameterController.dispose();
    _lengthController.dispose();
    _constructionYearController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return SafeArea(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            margin: const EdgeInsets.all(20),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height - 100,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.surface.withOpacity(0.9),
                  colorScheme.surfaceVariant.withOpacity(0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.05),
                  blurRadius: 40,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withOpacity(0.7),
                    border: Border.all(
                      color: colorScheme.outline.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: _buildHeader(colorScheme),
                      ),
                      
                      // Scrollable Content
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildIdentificationSection(colorScheme),
                              const SizedBox(height: 24),
                              _buildTechnicalSection(colorScheme),
                              const SizedBox(height: 24),
                              _buildAdditionalSection(colorScheme),
                              const SizedBox(height: 24),
                              _buildConditionSection(colorScheme),
                              const SizedBox(height: 32),
                              _buildActionButtons(colorScheme),
                              SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeader(ColorScheme colorScheme) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer.withOpacity(0.3),
            colorScheme.secondaryContainer.withOpacity(0.3),
          ],
        ),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.water_rounded,
              color: colorScheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Данные о трубе',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Сбор полевых данных о водопропускных трубах',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdentificationSection(ColorScheme colorScheme) {
    return _buildSection(
      'Идентификационные данные',
      Icons.fingerprint_rounded,
      colorScheme.primary,
      [
        ModernTextField(
          label: 'Адрес',
          controller: _addressController,
          icon: Icons.location_on_rounded,
        ),
        ModernTextField(
          label: 'Координаты',
          controller: _coordinatesController,
          icon: Icons.gps_fixed_rounded,
        ),
        ModernTextField(
          label: 'Автодорога',
          controller: _roadController,
          icon: Icons.route_rounded,
        ),
        ModernTextField(
          label: 'Порядковый номер',
          controller: _serialNumberController,
          icon: Icons.tag_rounded,
        ),
      ],
    );
  }

  Widget _buildTechnicalSection(ColorScheme colorScheme) {
    return _buildSection(
      'Технические параметры',
      Icons.precision_manufacturing_rounded,
      colorScheme.secondary,
      [
        ModernDropdown(
          label: 'Тип трубы',
          value: _culvertData.pipeType,
          options: const ['Круглая', 'Прямоугольная', 'Малый мост'],
          icon: Icons.category_rounded,
          onChanged: (value) {
            _updateData(() => _culvertData.pipeType = value!);
          },
        ),
        ModernDropdown(
          label: 'Материал',
          value: _culvertData.material,
          options: const ['Бетон', 'Сталь', 'Пластик', 'Кирпич'],
          icon: Icons.construction_rounded,
          onChanged: (value) {
            _updateData(() => _culvertData.material = value!);
          },
        ),
        ModernTextField(
          label: 'Диаметр/отверстие',
          controller: _diameterController,
          icon: Icons.straighten_rounded,
          suffix: 'м',
        ),
        ModernTextField(
          label: 'Длина',
          controller: _lengthController,
          icon: Icons.height_rounded,
          suffix: 'м',
        ),
      ],
    );
  }

  Widget _buildAdditionalSection(ColorScheme colorScheme) {
    return _buildSection(
      'Дополнительные данные',
      Icons.event_note_rounded,
      colorScheme.tertiary,
      [
        ModernTextField(
          label: 'Год постройки',
          controller: _constructionYearController,
          icon: Icons.calendar_today_rounded,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildConditionSection(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer.withOpacity(0.1),
            colorScheme.tertiaryContainer.withOpacity(0.1),
          ],
        ),
        border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics_rounded, color: colorScheme.primary),
              const SizedBox(width: 12),
              Text(
                'Оценка состояния',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildRatingSlider('Прочность', _culvertData.strengthRating, colorScheme.primary),
          _buildRatingSlider('Безопасность', _culvertData.safetyRating, colorScheme.secondary),
          _buildRatingSlider('Ремонтопригодность', _culvertData.maintainabilityRating, colorScheme.tertiary),
          _buildRatingSlider('Общее состояние', _culvertData.generalConditionRating, colorScheme.primary),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, Color accentColor, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: accentColor.withOpacity(0.05),
        border: Border.all(
          color: accentColor.withOpacity(0.1),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          iconColor: accentColor,
          collapsedIconColor: accentColor,
          children: children,
        ),
      ),
    );
  }

  Widget _buildRatingSlider(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  value.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: color,
              inactiveTrackColor: color.withOpacity(0.2),
              thumbColor: color,
              overlayColor: color.withOpacity(0.1),
            ),
            child: Slider(
              value: value,
              min: 1.0,
              max: 5.0,
              divisions: 8,
              onChanged: (newValue) {
                setState(() {
                  if (label == 'Прочность') {
                    _culvertData.strengthRating = newValue;
                  } else if (label == 'Безопасность') {
                    _culvertData.safetyRating = newValue;
                  } else if (label == 'Ремонтопригодность') {
                    _culvertData.maintainabilityRating = newValue;
                  } else if (label == 'Общее состояние') {
                    _culvertData.generalConditionRating = newValue;
                  }
                });
                widget.onDataChanged?.call(_culvertData);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // Save functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Данные сохранены')),
              );
            },
            icon: const Icon(Icons.save_rounded),
            label: const Text('Сохранить'),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // Reset functionality
              _updateControllers(CulvertData());
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Сбросить'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
} 
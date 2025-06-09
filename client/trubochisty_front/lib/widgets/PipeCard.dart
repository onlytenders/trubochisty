import 'package:flutter/material.dart';
import 'dart:ui';

// Data model for culvert information
class CulvertData {
  // Identifying information
  String address;
  String coordinates;
  String road;
  String serialNumber;
  
  // Technical parameters
  String pipeType;
  String material;
  String diameter;
  String length;
  String headType;
  String foundationType;
  String workType;
  
  // Additional information
  String constructionYear;
  DateTime? lastRepairDate;
  DateTime? lastInspectionDate;
  
  // Condition ratings
  double strengthRating;
  double safetyRating;
  double maintainabilityRating;
  double generalConditionRating;
  
  // Defects and photos
  List<String> defects;
  List<String> photos;
  
  CulvertData({
    this.address = '',
    this.coordinates = '',
    this.road = '',
    this.serialNumber = '',
    this.pipeType = 'Круглая',
    this.material = 'Бетон',
    this.diameter = '',
    this.length = '',
    this.headType = 'Стандартная',
    this.foundationType = 'Стандартный',
    this.workType = 'Обследование',
    this.constructionYear = '',
    this.lastRepairDate,
    this.lastInspectionDate,
    this.strengthRating = 3.0,
    this.safetyRating = 3.0,
    this.maintainabilityRating = 3.0,
    this.generalConditionRating = 3.0,
    this.defects = const [],
    this.photos = const [],
  });
  
  // Convert to JSON for backend
  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'coordinates': coordinates,
      'road': road,
      'serialNumber': serialNumber,
      'pipeType': pipeType,
      'material': material,
      'diameter': diameter,
      'length': length,
      'headType': headType,
      'foundationType': foundationType,
      'workType': workType,
      'constructionYear': constructionYear,
      'lastRepairDate': lastRepairDate?.toIso8601String(),
      'lastInspectionDate': lastInspectionDate?.toIso8601String(),
      'strengthRating': strengthRating,
      'safetyRating': safetyRating,
      'maintainabilityRating': maintainabilityRating,
      'generalConditionRating': generalConditionRating,
      'defects': defects,
      'photos': photos,
    };
  }
  
  // Create from JSON for backend
  factory CulvertData.fromJson(Map<String, dynamic> json) {
    return CulvertData(
      address: json['address'] ?? '',
      coordinates: json['coordinates'] ?? '',
      road: json['road'] ?? '',
      serialNumber: json['serialNumber'] ?? '',
      pipeType: json['pipeType'] ?? 'Круглая',
      material: json['material'] ?? 'Бетон',
      diameter: json['diameter'] ?? '',
      length: json['length'] ?? '',
      headType: json['headType'] ?? 'Стандартная',
      foundationType: json['foundationType'] ?? 'Стандартный',
      workType: json['workType'] ?? 'Обследование',
      constructionYear: json['constructionYear'] ?? '',
      lastRepairDate: json['lastRepairDate'] != null 
          ? DateTime.parse(json['lastRepairDate']) 
          : null,
      lastInspectionDate: json['lastInspectionDate'] != null 
          ? DateTime.parse(json['lastInspectionDate']) 
          : null,
      strengthRating: (json['strengthRating'] ?? 3.0).toDouble(),
      safetyRating: (json['safetyRating'] ?? 3.0).toDouble(),
      maintainabilityRating: (json['maintainabilityRating'] ?? 3.0).toDouble(),
      generalConditionRating: (json['generalConditionRating'] ?? 3.0).toDouble(),
      defects: List<String>.from(json['defects'] ?? []),
      photos: List<String>.from(json['photos'] ?? []),
    );
  }
}

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
  // Data model instance
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
    
    // Initialize data model
    _culvertData = widget.initialData ?? CulvertData();
    
    // Initialize controllers with data
    _addressController = TextEditingController(text: _culvertData.address);
    _coordinatesController = TextEditingController(text: _culvertData.coordinates);
    _roadController = TextEditingController(text: _culvertData.road);
    _serialNumberController = TextEditingController(text: _culvertData.serialNumber);
    _diameterController = TextEditingController(text: _culvertData.diameter);
    _lengthController = TextEditingController(text: _culvertData.length);
    _constructionYearController = TextEditingController(text: _culvertData.constructionYear);
    
    // Add listeners to update data model
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
  
  void _updateData(VoidCallback update) {
    update();
    widget.onDataChanged?.call(_culvertData);
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
                      // Fixed Header
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: _buildModernHeader(colorScheme),
                      ),
                      
                      // Scrollable Content
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Modern Sections
                              _buildModernSection(
                                'Идентификационные данные',
                                Icons.fingerprint_rounded,
                                colorScheme.primary,
                                [
                                  _buildModernTextField('Адрес', _addressController, Icons.location_on_rounded),
                                  _buildModernTextField('Координаты', _coordinatesController, Icons.gps_fixed_rounded),
                                  _buildModernTextField('Автодорога', _roadController, Icons.route_rounded),
                                  _buildModernTextField('Порядковый номер', _serialNumberController, Icons.tag_rounded),
                                ],
                              ),
                              
                              const SizedBox(height: 24),
                              
                              _buildModernSection(
                                'Технические параметры',
                                Icons.precision_manufacturing_rounded,
                                colorScheme.secondary,
                                [
                                  _buildModernDropdown('Тип трубы', _culvertData.pipeType, ['Круглая', 'Прямоугольная', 'Малый мост'], Icons.category_rounded, (value) {
                                    _updateData(() => _culvertData.pipeType = value!);
                                  }),
                                  _buildModernDropdown('Материал', _culvertData.material, ['Бетон', 'Сталь', 'Пластик', 'Кирпич'], Icons.construction_rounded, (value) {
                                    _updateData(() => _culvertData.material = value!);
                                  }),
                                  _buildModernTextField('Диаметр/отверстие', _diameterController, Icons.straighten_rounded, suffix: 'м'),
                                  _buildModernTextField('Длина', _lengthController, Icons.height_rounded, suffix: 'м'),
                                  _buildModernDropdown('Тип головки', _culvertData.headType, ['Стандартная', 'Крыльчатая', 'Стенка'], Icons.architecture_rounded, (value) {
                                    _updateData(() => _culvertData.headType = value!);
                                  }),
                                  _buildModernDropdown('Тип фундамента', _culvertData.foundationType, ['Стандартный', 'Каменный', 'Бетонный'], Icons.foundation_rounded, (value) {
                                    _updateData(() => _culvertData.foundationType = value!);
                                  }),
                                  _buildModernDropdown('Тип работы', _culvertData.workType, ['Обследование', 'Ремонт', 'Замена'], Icons.build_circle_rounded, (value) {
                                    _updateData(() => _culvertData.workType = value!);
                                  }),
                                ],
                              ),
                              
                              const SizedBox(height: 24),
                              
                              _buildModernSection(
                                'Дополнительные данные',
                                Icons.event_note_rounded,
                                colorScheme.tertiary,
                                [
                                  _buildModernTextField('Год постройки', _constructionYearController, Icons.calendar_today_rounded, keyboardType: TextInputType.number),
                                  _buildModernDatePicker('Дата последнего ремонта', Icons.build_rounded, (date) {
                                    _updateData(() => _culvertData.lastRepairDate = date);
                                  }),
                                  _buildModernDatePicker('Дата последнего обследования', Icons.search_rounded, (date) {
                                    _updateData(() => _culvertData.lastInspectionDate = date);
                                  }),
                                ],
                              ),
                              
                              const SizedBox(height: 24),
                              
                              _buildConditionAssessment(colorScheme),
                              
                              const SizedBox(height: 24),
                              
                              _buildDefectsSection(colorScheme),
                              
                              const SizedBox(height: 24),
                              
                              _buildPhotosSection(colorScheme),
                              
                              const SizedBox(height: 32),
                              
                              // Modern Action Buttons
                              _buildModernActionButtons(colorScheme),
                              
                              // Bottom padding for iOS
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
  
  Widget _buildModernHeader(ColorScheme colorScheme) {
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
  
  Widget _buildModernSection(String title, IconData icon, Color accentColor, List<Widget> children) {
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
  
  Widget _buildModernTextField(String label, TextEditingController controller, IconData icon, {String? suffix, TextInputType? keyboardType}) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: colorScheme.onSurface),
        decoration: InputDecoration(
          labelText: label,
          suffixText: suffix,
          prefixIcon: Icon(icon, color: colorScheme.primary.withOpacity(0.7)),
          filled: true,
          fillColor: colorScheme.surface.withOpacity(0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
          labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
  
  Widget _buildModernDropdown(String label, String value, List<String> options, IconData icon, ValueChanged<String?> onChanged) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: colorScheme.primary.withOpacity(0.7)),
          filled: true,
          fillColor: colorScheme.surface.withOpacity(0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
          labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        items: options.map((option) => DropdownMenuItem(
          value: option,
          child: Text(option, style: TextStyle(color: colorScheme.onSurface)),
        )).toList(),
        onChanged: onChanged,
        dropdownColor: colorScheme.surface,
        icon: Icon(Icons.keyboard_arrow_down_rounded, color: colorScheme.primary),
      ),
    );
  }
  
  Widget _buildModernDatePicker(String label, IconData icon, Function(DateTime?) onDateSelected) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: colorScheme.primary.withOpacity(0.7)),
          suffixIcon: Icon(Icons.calendar_today_rounded, color: colorScheme.primary.withOpacity(0.7)),
          filled: true,
          fillColor: colorScheme.surface.withOpacity(0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
          labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        readOnly: true,
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          onDateSelected(date);
        },
      ),
    );
  }
  
  Widget _buildConditionAssessment(ColorScheme colorScheme) {
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
          _buildModernRatingSlider('Прочность', _culvertData.strengthRating, colorScheme.primary, (value) {
            _updateData(() => _culvertData.strengthRating = value);
          }),
          _buildModernRatingSlider('Безопасность', _culvertData.safetyRating, colorScheme.secondary, (value) {
            _updateData(() => _culvertData.safetyRating = value);
          }),
          _buildModernRatingSlider('Ремонтопригодность', _culvertData.maintainabilityRating, colorScheme.tertiary, (value) {
            _updateData(() => _culvertData.maintainabilityRating = value);
          }),
          _buildModernRatingSlider('Общее состояние', _culvertData.generalConditionRating, colorScheme.error, (value) {
            _updateData(() => _culvertData.generalConditionRating = value);
          }),
        ],
      ),
    );
  }
  
  Widget _buildModernRatingSlider(String label, double value, Color color, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${value.toInt()}/5',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: color,
              inactiveTrackColor: color.withOpacity(0.2),
              thumbColor: color,
              overlayColor: color.withOpacity(0.1),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(
              value: value,
              min: 1,
              max: 5,
              divisions: 4,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDefectsSection(ColorScheme colorScheme) {
    return _buildModernSection(
      'Дефекты и необходимые работы',
      Icons.warning_rounded,
      colorScheme.error,
      [
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: colorScheme.errorContainer.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.error.withOpacity(0.2)),
          ),
          child: _culvertData.defects.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.list_alt_rounded, color: colorScheme.error.withOpacity(0.5), size: 32),
                      const SizedBox(height: 8),
                      Text(
                        'Список дефектов появится здесь',
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _culvertData.defects.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        '• ${_culvertData.defects[index]}',
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
                    );
                  },
                ),
        ),
        const SizedBox(height: 16),
        _buildModernButton(
          'Добавить дефект',
          Icons.add_circle_outline_rounded,
          colorScheme.error,
          () {
            // TODO: Open defect dialog
            _updateData(() => _culvertData.defects.add('Новый дефект'));
          },
        ),
      ],
    );
  }
  
  Widget _buildPhotosSection(ColorScheme colorScheme) {
    return _buildModernSection(
      'Фото и диаграммы',
      Icons.photo_library_rounded,
      colorScheme.tertiary,
      [
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: colorScheme.tertiaryContainer.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.tertiary.withOpacity(0.2)),
          ),
          child: _culvertData.photos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate_rounded, color: colorScheme.tertiary.withOpacity(0.5), size: 32),
                      const SizedBox(height: 8),
                      Text(
                        'Фото не добавлены',
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _culvertData.photos.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(Icons.image_rounded, size: 40, color: colorScheme.primary),
                    );
                  },
                ),
        ),
        const SizedBox(height: 16),
        _buildModernButton(
          'Добавить фото',
          Icons.add_a_photo_rounded,
          colorScheme.tertiary,
          () {
            // TODO: Open camera/gallery
            _updateData(() => _culvertData.photos.add('new_photo_${DateTime.now().millisecondsSinceEpoch}.jpg'));
          },
        ),
      ],
    );
  }
  
  Widget _buildModernButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return FilledButton.tonalIcon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
  
  Widget _buildModernActionButtons(ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: _saveCulvertData,
            icon: const Icon(Icons.save_rounded),
            label: const Text('Сохранить данные'),
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: FilledButton.tonalIcon(
            onPressed: _generateReport,
            icon: const Icon(Icons.description_rounded),
            label: const Text('Сгенерировать отчет'),
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.secondaryContainer,
              foregroundColor: colorScheme.onSecondaryContainer,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  void _saveCulvertData() {
    // Now you can easily send data to backend
    final jsonData = _culvertData.toJson();
    print('Saving culvert data: $jsonData');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Данные о трубе успешно сохранены!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
  
  void _generateReport() {
    // Generate report with structured data
    final jsonData = _culvertData.toJson();
    print('Generating report with data: $jsonData');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Генерация отчета начата...'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
  
  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _addressController.dispose();
    _coordinatesController.dispose();
    _roadController.dispose();
    _serialNumberController.dispose();
    _diameterController.dispose();
    _lengthController.dispose();
    _constructionYearController.dispose();
    super.dispose();
  }
}
import 'package:flutter/material.dart';
import 'dart:ui';
import '../../models/culvert_data.dart';
import 'pipe_header.dart';
import 'identification_section.dart';
import 'technical_section.dart';
import 'additional_section.dart';
import 'condition_section.dart';
import 'action_buttons.dart';

class PipeFormCard extends StatefulWidget {
  final CulvertData? initialData;
  final Function(CulvertData)? onDataChanged;
  
  const PipeFormCard({
    super.key,
    this.initialData,
    this.onDataChanged,
  });

  @override
  State<PipeFormCard> createState() => _PipeFormCardState();
}

class _PipeFormCardState extends State<PipeFormCard> with TickerProviderStateMixin {
  late CulvertData _culvertData;
  late CulvertData _originalData; // Track original data to detect changes
  
  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Use keys to access section states
  final GlobalKey<IdentificationSectionState> _identificationKey = 
      GlobalKey<IdentificationSectionState>();
  final GlobalKey<TechnicalSectionState> _technicalKey = 
      GlobalKey<TechnicalSectionState>();
  final GlobalKey<AdditionalSectionState> _additionalKey = 
      GlobalKey<AdditionalSectionState>();

  @override
  void initState() {
    super.initState();
    
    _culvertData = widget.initialData ?? CulvertData();
    _originalData = _culvertData; // Store original for comparison
    
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
  void didUpdateWidget(PipeFormCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialData != oldWidget.initialData && widget.initialData != null) {
      setState(() {
        _culvertData = widget.initialData!;
        _originalData = widget.initialData!;
      });
    }
  }

  void _updateData(CulvertData updatedData) {
    // Only update rating changes in real-time (sliders)
    // Text field changes are handled on save only
    setState(() {
      _culvertData = updatedData;
    });
  }

  void _handleSave() {
    // Collect data from all sections
    var updatedData = _culvertData;
    
    if (_identificationKey.currentState != null) {
      updatedData = _identificationKey.currentState!.getCurrentData();
    }
    if (_technicalKey.currentState != null) {
      updatedData = _technicalKey.currentState!.getCurrentData();
    }
    if (_additionalKey.currentState != null) {
      updatedData = _additionalKey.currentState!.getCurrentData();
    }
    
    setState(() {
      _culvertData = updatedData;
      _originalData = updatedData;
    });
    widget.onDataChanged?.call(updatedData);
  }

  @override
  void dispose() {
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
                      // Scrollable Content (now includes header)
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header (now scrolls with content)
                              PipeHeader(),
                              const SizedBox(height: 24),
                              
                              IdentificationSection(
                                data: _culvertData,
                                onDataChanged: _updateData,
                                key: _identificationKey,
                              ),
                              const SizedBox(height: 24),
                              TechnicalSection(
                                data: _culvertData,
                                onDataChanged: _updateData,
                                key: _technicalKey,
                              ),
                              const SizedBox(height: 24),
                              AdditionalSection(
                                data: _culvertData,
                                onDataChanged: _updateData,
                                key: _additionalKey,
                              ),
                              const SizedBox(height: 24),
                              ConditionSection(
                                data: _culvertData,
                                onDataChanged: _updateData,
                              ),
                              const SizedBox(height: 32),
                              ActionButtons(
                                data: _culvertData,
                                onSave: _handleSave,
                              ),
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
} 
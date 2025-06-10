import 'package:flutter/material.dart';
import '../../models/culvert_data.dart';
import '../form_widgets/modern_text_field.dart';
import '../common/pipe_section_wrapper.dart';

class AdditionalSection extends StatefulWidget {
  final CulvertData data;
  final Function(CulvertData) onDataChanged;

  const AdditionalSection({
    super.key,
    required this.data,
    required this.onDataChanged,
  });

  @override
  AdditionalSectionState createState() => AdditionalSectionState();
}

class AdditionalSectionState extends State<AdditionalSection> {
  late final TextEditingController _constructionYearController;

  @override
  void initState() {
    super.initState();
    
    _constructionYearController = TextEditingController(text: widget.data.constructionYear);
  }

  @override
  void didUpdateWidget(AdditionalSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      _updateControllers();
    }
  }

  void _updateControllers() {
    _constructionYearController.text = widget.data.constructionYear;
  }

  // Method to get current form data (called when saving)
  CulvertData getCurrentData() {
    return widget.data.copyWith(
      constructionYear: _constructionYearController.text,
    );
  }

  void _updateData() {
    widget.onDataChanged(widget.data.copyWith(
      constructionYear: _constructionYearController.text,
    ));
  }

  void _addPhoto() {
    // This would normally open image picker
    // For now, we'll just add a placeholder
    final updatedPhotos = List<String>.from(widget.data.photos);
    updatedPhotos.add('photo_${DateTime.now().millisecondsSinceEpoch}.jpg');
    widget.onDataChanged(widget.data.copyWith(photos: updatedPhotos));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.camera_alt, color: Colors.white),
            SizedBox(width: 8),
            Text('Фото добавлено (функция будет реализована)'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _removePhoto(int index) {
    final updatedPhotos = List<String>.from(widget.data.photos);
    updatedPhotos.removeAt(index);
    widget.onDataChanged(widget.data.copyWith(photos: updatedPhotos));
  }

  @override
  void dispose() {
    _constructionYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PipeSectionWrapper(
      title: 'Дополнительные данные',
      icon: Icons.event_note_rounded,
      iconColor: colorScheme.tertiary,
      children: [
        ModernTextField(
          label: 'Год постройки',
          controller: _constructionYearController,
          icon: Icons.calendar_today_rounded,
          keyboardType: TextInputType.number,
        ),
        
        // Photo upload section
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.photo_library_rounded,
                    color: colorScheme.primary.withOpacity(0.7),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Фотографии трубы',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${widget.data.photos.length}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Photo grid
              if (widget.data.photos.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (int i = 0; i < widget.data.photos.length; i++)
                      _buildPhotoCard(i, colorScheme),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              
              // Add photo button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _addPhoto,
                  icon: Icon(Icons.add_a_photo_rounded, color: colorScheme.primary),
                  label: Text(
                    'Добавить фото',
                    style: TextStyle(color: colorScheme.primary),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: colorScheme.primary.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoCard(int index, ColorScheme colorScheme) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Stack(
        children: [
          // Photo placeholder
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.image_rounded,
                  color: colorScheme.primary.withOpacity(0.7),
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  'Фото ${index + 1}',
                  style: TextStyle(
                    fontSize: 10,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          // Remove button
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => _removePhoto(index),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 12,
                  color: colorScheme.onErrorContainer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 
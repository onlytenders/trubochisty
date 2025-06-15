import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/culvert_data.dart';
import '../../providers/culvert_provider.dart';

class ActionButtons extends StatelessWidget {
  final CulvertData data;
  final VoidCallback? onSave;

  const ActionButtons({
    super.key,
    required this.data,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer.withOpacity(0.2),
            colorScheme.secondaryContainer.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Consumer<CulvertProvider>(
            builder: (context, provider, _) {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: provider.isLoading ? null : () => _handleSave(context),
                  icon: provider.isLoading 
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_rounded),
                  label: Text(provider.isLoading ? 'Сохранение...' : 'Сохранить данные'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showDeleteDialog(context),
              icon: Icon(
                Icons.delete_outline_rounded,
                color: colorScheme.error,
              ),
              label: Text(
                'Удалить',
                style: TextStyle(color: colorScheme.error),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: colorScheme.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSave(BuildContext context) async {
    // First, collect form data from parent component
    if (onSave != null) {
      onSave!();
    }
    
    // Validate required fields
    if (!_validateCulvertData(context)) {
      return;
    }
    
    final provider = context.read<CulvertProvider>();
    
    try {
      // Save to backend API
      await provider.saveCulvertToBackend(data);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                const Text('Данные успешно сохранены в базу данных!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Text('Ошибка сохранения: ${e.toString()}'),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  bool _validateCulvertData(BuildContext context) {
    final errors = <String>[];
    
    // Check if fields are empty or only contain whitespace
    if (data.address.trim().isEmpty) {
      errors.add('Адрес');
    }
    if (data.coordinates.trim().isEmpty) {
      errors.add('Координаты');
    }
    if (data.road.trim().isEmpty) {
      errors.add('Дорога');
    }
    if (data.serialNumber.trim().isEmpty) {
      errors.add('Серийный номер');
    }
    
    // Validate numeric fields
    if (data.diameter.trim().isEmpty) {
      errors.add('Диаметр');
    } else {
      final diameter = double.tryParse(data.diameter);
      if (diameter == null || diameter <= 0) {
        errors.add('Диаметр (должно быть положительным числом)');
      }
    }
    
    if (data.length.trim().isEmpty) {
      errors.add('Длина');
    } else {
      final length = double.tryParse(data.length);
      if (length == null || length <= 0) {
        errors.add('Длина (должно быть положительным числом)');
      }
    }
    
    if (data.constructionYear.trim().isEmpty) {
      errors.add('Год постройки');
    } else {
      final year = int.tryParse(data.constructionYear);
      if (year == null || year < 1900 || year > DateTime.now().year) {
        errors.add('Год постройки (должно быть числом между 1900 и ${DateTime.now().year})');
      }
    }
    
    if (errors.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.warning, color: Colors.white),
                  const SizedBox(width: 8),
                  const Text('Заполните обязательные поля:'),
                ],
              ),
              const SizedBox(height: 4),
              Text('• ${errors.join('\n• ')}'),
            ],
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 4),
        ),
      );
      return false;
    }
    
    return true;
  }

  void _showDeleteDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить трубу'),
        content: Text('Вы уверены, что хотите удалить трубу "${data.displayTitle}"? Это действие нельзя отменить.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _handleDelete(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.error,
            ),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  void _handleDelete(BuildContext context) {
    final provider = context.read<CulvertProvider>();
    provider.deleteCulvert(data);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.delete, color: Colors.white),
            const SizedBox(width: 8),
            Text('Труба "${data.displayTitle}" удалена'),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }
} 
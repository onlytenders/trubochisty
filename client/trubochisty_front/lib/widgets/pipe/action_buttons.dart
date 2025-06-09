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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _handleSave(context),
              icon: const Icon(Icons.save_rounded),
              label: const Text('Сохранить данные'),
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

  void _handleSave(BuildContext context) {
    if (onSave != null) {
      onSave!();
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            const Text('Данные успешно сохранены!'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
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
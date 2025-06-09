import 'package:flutter/material.dart';
import '../models/culvert_data.dart';
import 'pipe/pipe_form_card.dart';

class PipeCard extends StatelessWidget {
  final CulvertData? initialData;
  final Function(CulvertData)? onDataChanged;
  
  const PipeCard({
    super.key,
    this.initialData,
    this.onDataChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PipeFormCard(
      initialData: initialData,
      onDataChanged: onDataChanged,
    );
  }
} 
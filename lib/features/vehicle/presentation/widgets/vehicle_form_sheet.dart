/// `ListBrandsActivity` / `ListModelsActivity`).
library;

import 'package:flutter/material.dart';

import '../../domain/entities/vehicle_entities.dart';

class VehicleFormSheet extends StatefulWidget {
  const VehicleFormSheet({
    required this.brands,
    required this.onModelsForBrand,
    required this.models,
    required this.onSubmit,
    super.key,
  });

  final List<Brand> brands;
  final Future<void> Function(String brandId) onModelsForBrand;
  final List<VehicleModel> models;
  final void Function(Vehicle) onSubmit;

  @override
  State<VehicleFormSheet> createState() => _VehicleFormSheetState();
}

class _VehicleFormSheetState extends State<VehicleFormSheet> {
  final _plate = TextEditingController();
  final _color = TextEditingController();
  String? _brandId;
  String? _modelId;

  @override
  void dispose() {
    _plate.dispose();
    _color.dispose();
    super.dispose();
  }

  Future<void> _pickBrand(String? brandId) async {
    if (brandId == null) return;
    setState(() {
      _brandId = brandId;
      _modelId = null;
    });
    await widget.onModelsForBrand(brandId);
  }

  void _submit() {
    if (_brandId == null) return;
    final model = widget.models.firstWhere(
      (m) => m.id == _modelId,
      orElse: () => widget.models.isNotEmpty
          ? widget.models.first
          : const VehicleModel(id: '', brandId: '', name: ''),
    );
    widget.onSubmit(
      Vehicle(
        id: '',
        plate: _plate.text.trim().isEmpty ? null : _plate.text.trim(),
        brandId: _brandId,
        modelId: model.id.isEmpty ? null : model.id,
        color: _color.text.trim().isEmpty ? null : _color.text.trim(),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Add vehicle', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            key: ValueKey('brand-$_brandId'),
            initialValue: _brandId,
            decoration: const InputDecoration(labelText: 'Brand'),
            items: [
              for (final b in widget.brands)
                DropdownMenuItem(value: b.id, child: Text(b.name)),
            ],
            onChanged: _pickBrand,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            key: ValueKey('model-$_modelId'),
            initialValue: _modelId,
            decoration: const InputDecoration(labelText: 'Model'),
            items: [
              for (final m in widget.models)
                DropdownMenuItem(value: m.id, child: Text(m.name)),
            ],
            onChanged: (value) => setState(() => _modelId = value),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _plate,
            decoration: const InputDecoration(labelText: 'Plate'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _color,
            decoration: const InputDecoration(labelText: 'Color'),
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: _submit, child: const Text('Save')),
        ],
      ),
    );
  }
}

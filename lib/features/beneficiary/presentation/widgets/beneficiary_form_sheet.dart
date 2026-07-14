/// Bottom sheet form to create/edit a beneficiary (AFILIADO
/// `DetailBeneficiaryActivity` + `obtener_parentescos` relationship picker).
library;

import 'package:flutter/material.dart';

import '../../domain/entities/beneficiary_entities.dart';

class BeneficiaryFormSheet extends StatefulWidget {
  const BeneficiaryFormSheet({
    required this.relationships,
    required this.existing,
    required this.onSubmit,
    super.key,
  });

  final List<Relationship> relationships;
  final Beneficiary? existing;
  final void Function(Beneficiary) onSubmit;

  @override
  State<BeneficiaryFormSheet> createState() => _BeneficiaryFormSheetState();
}

class _BeneficiaryFormSheetState extends State<BeneficiaryFormSheet> {
  late final TextEditingController _name;
  late final TextEditingController _document;
  String? _relationshipId;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.existing?.name ?? '');
    _document = TextEditingController(text: widget.existing?.documentNumber ?? '');
    _relationshipId = widget.existing?.relationship;
  }

  @override
  void dispose() {
    _name.dispose();
    _document.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    widget.onSubmit(Beneficiary(
      id: widget.existing?.id ?? '',
      name: name,
      relationship: _relationshipId,
      documentNumber: _document.text.trim().isEmpty ? null : _document.text.trim(),
    ));
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
          Text(
            widget.existing == null ? 'Add beneficiary' : 'Edit beneficiary',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            key: ValueKey('rel-$_relationshipId'),
            initialValue: _relationshipId,
            decoration: const InputDecoration(labelText: 'Relationship'),
            items: [
              for (final r in widget.relationships)
                DropdownMenuItem(value: r.id, child: Text(r.name)),
            ],
            onChanged: (value) => setState(() => _relationshipId = value),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _document,
            decoration: const InputDecoration(labelText: 'Document number'),
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: _submit, child: const Text('Save')),
        ],
      ),
    );
  }
}
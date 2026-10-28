import 'package:flutter/material.dart';
import 'package:smart_greenhouse/domain/models/device.dart';
import 'package:smart_greenhouse/domain/validators.dart';
import 'package:smart_greenhouse/ui/widgets/app_text_field.dart';

/// Дані, введені у формі пристрою.
typedef DeviceFormResult = ({String name, String zone, DeviceType type});

/// Діалог створення/редагування пристрою.
class DeviceFormDialog extends StatefulWidget {
  const DeviceFormDialog({super.key, this.initial});

  final Device? initial;

  static Future<DeviceFormResult?> show(
    BuildContext context, {
    Device? initial,
  }) => showDialog<DeviceFormResult>(
    context: context,
    builder: (_) => DeviceFormDialog(initial: initial),
  );

  @override
  State<DeviceFormDialog> createState() => _DeviceFormDialogState();
}

class _DeviceFormDialogState extends State<DeviceFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.initial?.name);
  late final _zone = TextEditingController(text: widget.initial?.zone);
  late DeviceType _type = widget.initial?.type ?? DeviceType.fan;

  @override
  void dispose() {
    _name.dispose();
    _zone.dispose();
    super.dispose();
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.pop<DeviceFormResult>(context, (
      name: _name.text.trim(),
      zone: _zone.text.trim(),
      type: _type,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initial == null ? 'Новий пристрій' : 'Редагування'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                label: 'Назва',
                icon: Icons.label_outline,
                controller: _name,
                validator: (v) => Validators.required(v, 'Назва'),
              ),
              AppTextField(
                label: 'Зона',
                icon: Icons.place_outlined,
                controller: _zone,
                validator: (v) => Validators.required(v, 'Зона'),
              ),
              DropdownButtonFormField<DeviceType>(
                initialValue: _type,
                decoration: const InputDecoration(labelText: 'Тип'),
                items: [
                  for (final t in DeviceType.values)
                    DropdownMenuItem(value: t, child: Text(t.label)),
                ],
                onChanged: (t) => setState(() => _type = t ?? _type),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Скасувати'),
        ),
        FilledButton(onPressed: _save, child: const Text('Зберегти')),
      ],
    );
  }
}

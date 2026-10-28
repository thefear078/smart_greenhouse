import 'package:flutter/material.dart';

/// Діалог з одним текстовим полем і валідацією.
Future<String?> textPromptDialog(
  BuildContext context, {
  required String title,
  required String initial,
  FormFieldValidator<String>? validator,
}) => showDialog<String>(
  context: context,
  builder: (_) =>
      _PromptDialog(title: title, initial: initial, validator: validator),
);

class _PromptDialog extends StatefulWidget {
  const _PromptDialog({
    required this.title,
    required this.initial,
    this.validator,
  });

  final String title;
  final String initial;
  final FormFieldValidator<String>? validator;

  @override
  State<_PromptDialog> createState() => _PromptDialogState();
}

class _PromptDialogState extends State<_PromptDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _controller = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pop(context, _controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          validator: widget.validator,
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

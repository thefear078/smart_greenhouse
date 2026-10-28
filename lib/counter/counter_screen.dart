import 'package:flutter/material.dart';
import 'package:smart_greenhouse/counter/counter_command.dart';

/// Екран лабораторної №1: лічильник, що змінюється введеним числом.
class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  final TextEditingController _controller = TextEditingController();
  int _counter = 0;
  String? _error;
  String _lastAction = 'Введіть число та натисніть «Застосувати»';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final command = CounterCommand.parse(_controller.text);
    setState(() {
      switch (command) {
        case AddCommand(:final value):
          _counter += value;
          _error = null;
          _lastAction = 'Додано ${value >= 0 ? '+' : ''}$value';
        case ResetCommand():
          _counter = 0;
          _error = null;
          _lastAction = 'Лічильник обнулено заклинанням 🪄';
        case InvalidCommand(:final message):
          _error = message;
      }
    });
    if (command is InvalidCommand) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(command.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
    } else {
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Лабораторна №1 — лічильник')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Поточне значення', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Text(
                      '$_counter',
                      key: ValueKey<int>(_counter),
                      style: theme.textTheme.displayLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(_lastAction, textAlign: TextAlign.center),
                  const SizedBox(height: 32),
                  TextField(
                    key: const Key('counterInput'),
                    controller: _controller,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submit(),
                    onChanged: (_) {
                      if (_error != null) setState(() => _error = null);
                    },
                    decoration: InputDecoration(
                      labelText: 'Число або команда',
                      hintText: 'Напр.: 5, -3 або Avada Kedavra',
                      errorText: _error,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.edit),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      key: const Key('submitButton'),
                      onPressed: _submit,
                      icon: const Icon(Icons.check),
                      label: const Text('Застосувати'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

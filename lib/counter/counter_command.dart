/// Результат розбору рядка, введеного користувачем.
sealed class CounterCommand {
  const CounterCommand();

  /// Команда, що скидає лічильник до нуля.
  static const String resetPhrase = 'Avada Kedavra';

  /// Розбирає [raw] і повертає відповідну команду.
  ///
  /// * ціле число (у т. ч. від'ємне) -> [AddCommand];
  /// * точний рядок `Avada Kedavra` -> [ResetCommand];
  /// * усе інше -> [InvalidCommand] з поясненням.
  static CounterCommand parse(String raw) {
    final input = raw.trim();
    if (input.isEmpty) {
      return const InvalidCommand('Поле порожнє — введіть ціле число');
    }
    if (raw == resetPhrase) {
      return const ResetCommand();
    }
    final value = int.tryParse(input);
    if (value != null) {
      return AddCommand(value);
    }
    if (double.tryParse(input.replaceAll(',', '.')) != null) {
      return InvalidCommand('«$input» — дробове число, потрібне ціле');
    }
    return InvalidCommand('«$input» — не число і не команда');
  }
}

class AddCommand extends CounterCommand {
  const AddCommand(this.value);

  final int value;
}

class ResetCommand extends CounterCommand {
  const ResetCommand();
}

class InvalidCommand extends CounterCommand {
  const InvalidCommand(this.message);

  final String message;
}

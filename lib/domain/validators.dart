/// Бізнес-правила валідації форм. Повертають текст помилки або `null`.
abstract final class Validators {
  static final RegExp _email = RegExp(
    r'^[\w.+-]+@[\w-]+(\.[\w-]+)*\.[a-z]{2,}$',
  );
  static final RegExp _digits = RegExp(r'\d');

  static String? name(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return "Введіть ім'я";
    if (v.length < 2) return "Ім'я надто коротке";
    if (_digits.hasMatch(v)) return "Ім'я не може містити цифр";
    return null;
  }

  static String? email(String? value) {
    final v = value?.trim().toLowerCase() ?? '';
    if (v.isEmpty) return 'Введіть email';
    if (!v.contains('@')) return 'Email має містити символ @';
    if (!_email.hasMatch(v)) return 'Некоректний email (приклад: me@mail.com)';
    return null;
  }

  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Введіть пароль';
    if (v.length < 8) return 'Пароль — мінімум 8 символів';
    return null;
  }

  static String? Function(String?) confirm(String Function() original) =>
      (value) => value == original() ? null : 'Паролі не збігаються';

  static String? required(String? value, String field) =>
      (value?.trim().isEmpty ?? true) ? 'Заповніть поле «$field»' : null;
}

/// Загальна помилка доступу до даних, яку UI може показати користувачу.
class RepositoryException implements Exception {
  const RepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}

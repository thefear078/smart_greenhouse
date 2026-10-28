/// Користувач застосунку. Пароль зберігається лише у вигляді хешу.
class User {
  const User({
    required this.name,
    required this.email,
    required this.passwordHash,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json['name'] as String,
    email: json['email'] as String,
    passwordHash: json['passwordHash'] as String,
  );

  final String name;
  final String email;
  final String passwordHash;

  User copyWith({String? name}) =>
      User(name: name ?? this.name, email: email, passwordHash: passwordHash);

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'passwordHash': passwordHash,
  };
}

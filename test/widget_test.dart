import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  testWidgets('invalid registration shows errors and stays', (tester) async {
    await tester.pumpWidget(await buildApp());
    await tapOn(tester, find.text('Немає акаунта? Зареєструватися'));
    await typeInto(tester, "Ім'я", 'Kost1a');
    await typeInto(tester, 'Email', 'no-at-sign');
    await typeInto(tester, 'Пароль', '123');
    await tapOn(tester, find.text('Створити акаунт'));
    expect(find.text("Ім'я не може містити цифр"), findsOneWidget);
    expect(find.text('Email має містити символ @'), findsOneWidget);
    expect(find.text('Пароль — мінімум 8 символів'), findsOneWidget);
    expect(find.text('Реєстрація'), findsOneWidget);
  });

  testWidgets('register -> CRUD -> logout -> wrong login -> login', (
    tester,
  ) async {
    await tester.pumpWidget(await buildApp());
    await tapOn(tester, find.text('Немає акаунта? Зареєструватися'));
    await typeInto(tester, "Ім'я", 'Kostiantyn');
    await typeInto(tester, 'Email', 'k@lpnu.ua');
    await typeInto(tester, 'Пароль', 'secret123');
    await typeInto(tester, 'Підтвердіть пароль', 'secret123');
    await tapOn(tester, find.text('Створити акаунт'));
    expect(find.text('Датчики'), findsOneWidget);

    // Create
    await tapOn(tester, find.byTooltip('Додати пристрій'));
    await typeInto(tester, 'Назва', 'Зволожувач');
    await typeInto(tester, 'Зона', 'Зона D');
    await tapOn(tester, find.text('Зберегти'));
    expect(find.text('Зволожувач'), findsOneWidget);

    // Update
    await tapOn(tester, find.text('Зволожувач'));
    await typeInto(tester, 'Назва', 'Зволожувач 2');
    await tapOn(tester, find.text('Зберегти'));
    expect(find.text('Зволожувач 2'), findsOneWidget);

    // Delete
    await tapOn(tester, find.byTooltip('Видалити').last);
    await tapOn(tester, find.text('Видалити'));
    expect(find.text('Зволожувач 2'), findsNothing);

    // Logout and login
    await tapOn(tester, find.byTooltip('Профіль'));
    expect(find.text('k@lpnu.ua'), findsWidgets);
    await tapOn(tester, find.text('Вийти'));
    await typeInto(tester, 'Email', 'k@lpnu.ua');
    await typeInto(tester, 'Пароль', 'wrongpass');
    await tapOn(tester, find.text('Увійти'));
    expect(find.text('Невірний email або пароль'), findsOneWidget);
    await typeInto(tester, 'Пароль', 'secret123');
    await tapOn(tester, find.text('Увійти'));
    expect(find.text('Датчики'), findsOneWidget);
  });
}

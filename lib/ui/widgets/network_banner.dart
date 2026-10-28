import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_greenhouse/logic/network/network_cubit.dart';
import 'package:smart_greenhouse/ui/theme/app_theme.dart';

/// Червона плашка, поки немає мережі (стан — з [NetworkCubit]).
/// Якщо застосунок стартував офлайн — показує попереджувальний діалог.
class NetworkBanner extends StatelessWidget {
  const NetworkBanner({required this.child, super.key});

  final Widget child;

  static Future<void> _warn(BuildContext context) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.wifi_off, color: AppColors.danger),
      title: const Text('Немає підключення'),
      content: const Text(
        'Ви увійшли за збереженою сесією, але мережа недоступна. '
        'Застосунок працює в режимі обмеженої функціональності: '
        'показано збережені дані, зміни недоступні.',
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Зрозуміло'),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NetworkCubit, NetworkState>(
      listenWhen: (a, b) => !a.checked && b.checked && !b.online,
      listener: (context, _) => _warn(context),
      builder: (context, state) => Column(
        children: [
          if (!state.online)
            const Material(
              color: AppColors.danger,
              child: SafeArea(
                bottom: false,
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.sm),
                    child: Text(
                      'Немає з\'єднання з інтернетом · обмежений режим',
                      key: Key('offlineBanner'),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

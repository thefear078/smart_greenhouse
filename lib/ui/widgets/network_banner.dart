import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_greenhouse/domain/services/network_monitor.dart';
import 'package:smart_greenhouse/ui/theme/app_theme.dart';

/// Обгортка, що показує червону плашку, поки немає мережі.
/// Якщо [warnOnStart] і старт офлайн — показує попереджувальний діалог.
class NetworkBanner extends StatefulWidget {
  const NetworkBanner({
    required this.monitor,
    required this.child,
    super.key,
    this.warnOnStart = true,
  });

  final INetworkMonitor monitor;
  final Widget child;
  final bool warnOnStart;

  @override
  State<NetworkBanner> createState() => _NetworkBannerState();
}

class _NetworkBannerState extends State<NetworkBanner> {
  bool _online = true;
  StreamSubscription<bool>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = widget.monitor.onStatusChange.listen(
      (online) => setState(() => _online = online),
    );
    unawaited(_checkInitial());
  }

  Future<void> _checkInitial() async {
    final online = await widget.monitor.isOnline();
    if (!mounted) return;
    setState(() => _online = online);
    if (!online && widget.warnOnStart) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.wifi_off, color: AppColors.danger),
          title: const Text('Немає підключення'),
          content: const Text(
            'Ви увійшли за збереженою сесією, але мережа недоступна. '
            'Застосунок працює в режимі обмеженої функціональності: '
            'дані з датчиків не оновлюються.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Зрозуміло'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    unawaited(_sub?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          child: _online
              ? const SizedBox(width: double.infinity)
              : Material(
                  color: AppColors.danger,
                  child: SafeArea(
                    bottom: false,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: const Text(
                        'Немає з\'єднання з інтернетом · обмежений режим',
                        key: Key('offlineBanner'),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
        ),
        Expanded(child: widget.child),
      ],
    );
  }
}

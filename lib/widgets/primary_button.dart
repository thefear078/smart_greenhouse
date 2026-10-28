import 'package:flutter/material.dart';

/// Основна кнопка на всю ширину; [isLoading] показує індикатор.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.isLoading = false,
    this.outlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final Widget child = isLoading
        ? const SizedBox.square(
            dimension: 22,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
            ],
          );
    final style = ButtonStyle(
      minimumSize: WidgetStateProperty.all(const Size.fromHeight(52)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    final action = isLoading ? null : onPressed;
    return outlined
        ? OutlinedButton(onPressed: action, style: style, child: child)
        : FilledButton(onPressed: action, style: style, child: child);
  }
}

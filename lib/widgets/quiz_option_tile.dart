import 'package:flutter/material.dart';

enum OptionState { idle, correct, incorrect, revealed }

/// An animated tile for a single quiz answer option.
class QuizOptionTile extends StatelessWidget {
  final String text;
  final OptionState state;
  final VoidCallback? onTap;

  const QuizOptionTile({
    super.key,
    required this.text,
    this.state = OptionState.idle,
    this.onTap,
  });

  Color _bgColor() {
    switch (state) {
      case OptionState.correct:
        return const Color(0xFFD1FAE5);
      case OptionState.incorrect:
        return const Color(0xFFFEE2E2);
      case OptionState.revealed:
        return const Color(0xFFF0FDF4);
      case OptionState.idle:
        return Colors.white;
    }
  }

  Color _borderColor() {
    switch (state) {
      case OptionState.correct:
        return const Color(0xFF10B981);
      case OptionState.incorrect:
        return const Color(0xFFEF4444);
      case OptionState.revealed:
        return const Color(0xFF10B981);
      case OptionState.idle:
        return const Color(0xFFE2E8F0);
    }
  }

  Color _textColor() {
    switch (state) {
      case OptionState.correct:
        return const Color(0xFF065F46);
      case OptionState.incorrect:
        return const Color(0xFF991B1B);
      case OptionState.revealed:
        return const Color(0xFF065F46);
      case OptionState.idle:
        return const Color(0xFF0F172A);
    }
  }

  Widget? _trailingIcon() {
    switch (state) {
      case OptionState.correct:
        return const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 22);
      case OptionState.incorrect:
        return const Icon(Icons.cancel_rounded, color: Color(0xFFEF4444), size: 22);
      case OptionState.revealed:
        return const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF10B981), size: 22);
      case OptionState.idle:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: _bgColor(),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _borderColor(), width: state == OptionState.idle ? 1 : 2),
        boxShadow: state != OptionState.idle
            ? [
                BoxShadow(
                  color: _borderColor().withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: state == OptionState.idle ? onTap : null,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 15,
                      color: _textColor(),
                      fontWeight: state != OptionState.idle ? FontWeight.w600 : FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                ),
                if (_trailingIcon() != null) ...[
                  const SizedBox(width: 12),
                  _trailingIcon()!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

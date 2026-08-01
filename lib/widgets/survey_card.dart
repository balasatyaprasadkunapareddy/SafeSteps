import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../utils/app_theme.dart';

/// Streams survey insights from Firestore (or local fallback) and displays
/// them in an animated, auto-advancing spotlight card.
class SurveyCard extends StatefulWidget {
  const SurveyCard({super.key});

  @override
  State<SurveyCard> createState() => _SurveyCardState();
}

class _SurveyCardState extends State<SurveyCard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: DatabaseService().getSurveyInsightStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const _SurveyCardSkeleton();
        }

        final items = snapshot.data ?? [];
        if (items.isEmpty) return const SizedBox.shrink();

        final item = items[_currentIndex % items.length];

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _SurveyCardContent(
            key: ValueKey(_currentIndex),
            stat: item['stat'] as String? ?? '',
            message: item['message'] as String? ?? '',
            category: item['category'] as String? ?? '',
            currentIndex: _currentIndex,
            total: items.length,
            onNext: () => setState(() => _currentIndex = (_currentIndex + 1) % items.length),
            onPrev: () => setState(() => _currentIndex = (_currentIndex - 1 + items.length) % items.length),
          ),
        );
      },
    );
  }
}

class _SurveyCardContent extends StatelessWidget {
  final String stat;
  final String message;
  final String category;
  final int currentIndex;
  final int total;
  final VoidCallback onNext;
  final VoidCallback onPrev;

  const _SurveyCardContent({
    super.key,
    required this.stat,
    required this.message,
    required this.category,
    required this.currentIndex,
    required this.total,
    required this.onNext,
    required this.onPrev,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E40AF), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.analytics_outlined, size: 14, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      'Survey Spotlight',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (total > 1) ...[
                GestureDetector(
                  onTap: onPrev,
                  child: const Icon(Icons.chevron_left, color: Colors.white70, size: 20),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    '${currentIndex + 1}/$total',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
                GestureDetector(
                  onTap: onNext,
                  child: const Icon(Icons.chevron_right, color: Colors.white70, size: 20),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stat,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      message,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SurveyCardSkeleton extends StatelessWidget {
  const _SurveyCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

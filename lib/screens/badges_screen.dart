import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../services/database_service.dart';
import '../utils/app_theme.dart';
import '../widgets/badge_card.dart';

class BadgesScreen extends StatefulWidget {
  final void Function(int index)? onNavigate;

  const BadgesScreen({super.key, this.onNavigate});

  @override
  State<BadgesScreen> createState() => _BadgesScreenState();
}

class _BadgesScreenState extends State<BadgesScreen> {
  @override
  Widget build(BuildContext context) {
    final profile = DatabaseService().localProfile;
    final earnedBadges = profile.earnedBadges;
    final isWide = MediaQuery.of(context).size.width >= 700;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: const Text('My Badges'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${earnedBadges.length}/${AppData.badges.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 32 : 20,
              vertical: 16,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Trophy Header ────────────────────────────────
                _TrophyHeader(
                  unlocked: earnedBadges.length,
                  total: AppData.badges.length,
                ),
                const SizedBox(height: 24),

                // ── Leaderboard ──────────────────────────────────
                _LeaderboardSection(),
                const SizedBox(height: 24),

                // ── All Badges ───────────────────────────────────
                Text(
                  'Your Achievements',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'Complete quizzes and modules to unlock badges.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
              ]),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 32 : 20,
            ),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWide ? 3 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.78,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final badge = AppData.badges[index];
                  final isUnlocked = earnedBadges.contains(badge.id);
                  return BadgeCard(
                    badge: badge,
                    isUnlocked: isUnlocked,
                  );
                },
                childCount: AppData.badges.length,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 32),
            sliver: SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 32 : 20,
                  vertical: 24,
                ),
                child: _NextBadgeHint(earnedBadges: earnedBadges),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Trophy Header ────────────────────────────────────────────────────────────

class _TrophyHeader extends StatelessWidget {
  final int unlocked;
  final int total;

  const _TrophyHeader({required this.unlocked, required this.total});

  @override
  Widget build(BuildContext context) {
    final progress = unlocked / total;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🏆', style: TextStyle(fontSize: 32)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$unlocked of $total Badges Unlocked',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: Colors.white.withOpacity(0.25),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${(progress * 100).round()}% complete',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Leaderboard ─────────────────────────────────────────────────────────────

class _LeaderboardSection extends StatelessWidget {
  const _LeaderboardSection();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: DatabaseService().getLeaderboardStream(),
      builder: (context, snapshot) {
        final items = snapshot.data ?? [];
        if (items.isEmpty && snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(height: 80, child: Center(child: CircularProgressIndicator()));
        }
        if (items.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Leaderboard',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final medal = index == 0
                      ? '🥇'
                      : index == 1
                          ? '🥈'
                          : index == 2
                              ? '🥉'
                              : '${index + 1}.';
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 32,
                          child: Text(
                            medal,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item['name'] as String? ?? 'Anonymous',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${item['score']}%',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primary,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              'Lv ${item['level']}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─── Next Badge Hint ──────────────────────────────────────────────────────────

class _NextBadgeHint extends StatelessWidget {
  final List<String> earnedBadges;

  const _NextBadgeHint({required this.earnedBadges});

  @override
  Widget build(BuildContext context) {
    final next = AppData.badges.where((b) => !earnedBadges.contains(b.id)).firstOrNull;

    if (next == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.secondary.withOpacity(0.3)),
        ),
        child: const Row(
          children: [
            Text('🌟', style: TextStyle(fontSize: 24)),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'You have unlocked all badges! You are a SafeSteps Champion!',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF065F46),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: next.color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: next.color.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Text(next.emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Next: ${next.title}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: next.color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  next.unlockCondition,
                  style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

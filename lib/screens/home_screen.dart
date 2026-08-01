import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../services/database_service.dart';
import '../utils/app_theme.dart';
import '../widgets/survey_card.dart';
import '../widgets/category_card.dart';
import 'learn_screen.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int index)? onNavigate;

  const HomeScreen({super.key, this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserProfileNotifier _profileNotifier;

  @override
  void initState() {
    super.initState();
    _profileNotifier = UserProfileNotifier(DatabaseService().localProfile);
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 700;
    final profile = DatabaseService().localProfile;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: isWide ? 80 : 70,
            floating: true,
            snap: true,
            backgroundColor: AppTheme.surface,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(
                left: isWide ? 32 : 20,
                bottom: 14,
              ),
              title: Row(
                children: [
                  const Text(
                    'SafeSteps',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('🚸', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 32 : 20,
              vertical: 8,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Welcome Banner ────────────────────────────────────
                _WelcomeBanner(profile: profile),
                const SizedBox(height: 24),

                // ── Survey Spotlight ──────────────────────────────────
                const SurveyCard(),
                const SizedBox(height: 28),

                // ── Quick Actions ─────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.bolt_rounded,
                        label: 'Quick Quiz',
                        color: AppTheme.warning,
                        onTap: () {
                          if (widget.onNavigate != null) {
                            widget.onNavigate!(2);
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const QuizScreen(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.menu_book_rounded,
                        label: 'Learn Rules',
                        color: AppTheme.secondary,
                        onTap: () {
                          if (widget.onNavigate != null) {
                            widget.onNavigate!(1);
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LearnScreen(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // ── Learning Modules ──────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Learning Modules',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    TextButton(
                      onPressed: () => widget.onNavigate?.call(1),
                      child: const Text('See all'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _ModuleGrid(
                  profile: profile,
                  onModuleTap: (module) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LessonDetailScreen(module: module),
                      ),
                    ).then((_) => setState(() {}));
                  },
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Welcome Banner ──────────────────────────────────────────────────────────

class _WelcomeBanner extends StatelessWidget {
  final dynamic profile;

  const _WelcomeBanner({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('🏆', style: TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back, Explorer!',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      profile.levelTitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Lv ${profile.level}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${profile.xp} XP',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${profile.xpToNextLevel} XP',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: profile.levelProgress.clamp(0.0, 1.0),
                        minHeight: 6,
                        backgroundColor: Colors.white.withOpacity(0.25),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _StatChip(
                icon: Icons.quiz_rounded,
                label: '${profile.quizzesTaken} Quizzes',
              ),
              const SizedBox(width: 8),
              _StatChip(
                icon: Icons.workspace_premium,
                label: '${profile.earnedBadges.length} Badges',
              ),
              const SizedBox(width: 8),
              _StatChip(
                icon: Icons.local_library_outlined,
                label: '${profile.completedModules.length}/4 Modules',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Quick Action Button ──────────────────────────────────────────────────────

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Module Grid ──────────────────────────────────────────────────────────────

class _ModuleGrid extends StatelessWidget {
  final dynamic profile;
  final void Function(LessonModule) onModuleTap;

  const _ModuleGrid({required this.profile, required this.onModuleTap});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 700;
    final crossAxis = isWide ? 4 : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxis,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: isWide ? 0.78 : 0.82,
      ),
      itemCount: AppData.lessonModules.length,
      itemBuilder: (context, index) {
        final module = AppData.lessonModules[index];
        final isCompleted = profile.completedModules.contains(module.id);
        return CategoryCard(
          module: module,
          isCompleted: isCompleted,
          onTap: () => onModuleTap(module),
        );
      },
    );
  }
}

// ─── Notifier helper (lightweight state) ─────────────────────────────────────

class UserProfileNotifier extends ValueNotifier<dynamic> {
  UserProfileNotifier(super.value);
}
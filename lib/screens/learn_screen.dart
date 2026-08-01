import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../services/database_service.dart';
import '../utils/app_theme.dart';
import 'quiz_screen.dart';
import 'signs_screen.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 700;
    final profile = DatabaseService().localProfile;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: const Text('Learn'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Chip(
              label: Text(
                '${profile.completedModules.length}/${AppData.lessonModules.length} done',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
              backgroundColor: AppTheme.primary.withOpacity(0.08),
              side: const BorderSide(color: AppTheme.primary, width: 1),
              padding: const EdgeInsets.symmetric(horizontal: 4),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: isWide ? 32 : 20,
          vertical: 16,
        ),
        children: [
          // Traffic Signs Library CTA
          _SignsLibraryCTA(context),
          const SizedBox(height: 24),

          Text(
            'Safety Modules',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Tap any module to explore the rules. Complete all 4 to earn your Champion badge!',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),

          ...AppData.lessonModules.map((module) {
            final isCompleted = profile.completedModules.contains(module.id);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ModuleListTile(
                module: module,
                isCompleted: isCompleted,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LessonDetailScreen(module: module),
                    ),
                  ).then((_) => setState(() {}));
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _SignsLibraryCTA(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SignsScreen()),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.secondary.withOpacity(0.4)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.secondary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.signpost_outlined,
                  color: AppTheme.secondary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Traffic Sign Library',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.secondary,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Explore 17 Indian road signs with details',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppTheme.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Module List Tile ─────────────────────────────────────────────────────────

class _ModuleListTile extends StatelessWidget {
  final LessonModule module;
  final bool isCompleted;
  final VoidCallback onTap;

  const _ModuleListTile({
    required this.module,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isCompleted
                  ? module.color.withOpacity(0.4)
                  : AppTheme.border,
              width: isCompleted ? 1.5 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: module.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      module.emoji,
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            module.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (isCompleted) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: module.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '✓ Done',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: module.color,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        module.subtitle,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: isCompleted ? 1.0 : 0.0,
                        backgroundColor: AppTheme.border,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(module.color),
                        minHeight: 3,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppTheme.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  LESSON DETAIL SCREEN
// ═══════════════════════════════════════════════════════════════════════════

class LessonDetailScreen extends StatefulWidget {
  final LessonModule module;

  const LessonDetailScreen({super.key, required this.module});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  bool _isMarkingComplete = false;
  bool _isAlreadyComplete = false;

  @override
  void initState() {
    super.initState();
    _isAlreadyComplete = DatabaseService()
        .localProfile
        .completedModules
        .contains(widget.module.id);
  }

  Future<void> _markComplete() async {
    setState(() => _isMarkingComplete = true);
    final updated =
        await DatabaseService().markModuleComplete(widget.module.id);
    DatabaseService().updateLocalProfile(updated);
    if (mounted) {
      setState(() {
        _isMarkingComplete = false;
        _isAlreadyComplete = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Module completed! +25 XP earned 🎉'),
          backgroundColor: widget.module.color,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final module = widget.module;
    final isWide = MediaQuery.of(context).size.width >= 700;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: module.color,
            foregroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                module.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      module.color,
                      module.color.withOpacity(0.7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Text(
                    module.emoji,
                    style: const TextStyle(fontSize: 72),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(isWide ? 32 : 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  module.subtitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
                const SizedBox(height: 24),
                ...module.rules.asMap().entries.map((entry) {
                  final index = entry.key;
                  final rule = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _RuleCard(
                      index: index + 1,
                      rule: rule,
                      accentColor: module.color,
                    ),
                  );
                }),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const QuizScreen()),
                          );
                        },
                        icon: const Icon(Icons.quiz_rounded, size: 18),
                        label: const Text('Take Quiz'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isAlreadyComplete || _isMarkingComplete
                            ? null
                            : _markComplete,
                        icon: _isMarkingComplete
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white),
                              )
                            : Icon(
                                _isAlreadyComplete
                                    ? Icons.check_circle_rounded
                                    : Icons.done_rounded,
                                size: 18,
                              ),
                        label: Text(
                          _isAlreadyComplete ? 'Completed!' : 'Mark Done',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _isAlreadyComplete ? module.color : null,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
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

class _RuleCard extends StatelessWidget {
  final int index;
  final LessonRule rule;
  final Color accentColor;

  const _RuleCard({
    required this.index,
    required this.rule,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(rule.icon, size: 16, color: accentColor),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rule.heading,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  rule.body,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.5,
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



import 'package:flutter/material.dart';
import 'screens/badges_screen.dart';
import 'screens/home_screen.dart';
import 'screens/learn_screen.dart';
import 'screens/quiz_screen.dart';
import 'utils/app_theme.dart';

/// AppShell handles the responsive navigation layout:
/// - Mobile (< 700px): BottomNavigationBar with 4 tabs
/// - Desktop (≥ 700px): NavigationRail sidebar with constrained content area
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  void _onNavigate(int index) {
    setState(() => _currentIndex = index);
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return HomeScreen(onNavigate: _onNavigate);
      case 1:
        return const LearnScreen();
      case 2:
        return const QuizScreen();
      case 3:
        return BadgesScreen(onNavigate: _onNavigate);
      default:
        return HomeScreen(onNavigate: _onNavigate);
    }
  }

  static const List<_NavItem> _navItems = [
    _NavItem(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      label: 'Home',
    ),
    _NavItem(
      icon: Icons.menu_book_outlined,
      selectedIcon: Icons.menu_book_rounded,
      label: 'Learn',
    ),
    _NavItem(
      icon: Icons.quiz_outlined,
      selectedIcon: Icons.quiz_rounded,
      label: 'Quiz',
    ),
    _NavItem(
      icon: Icons.workspace_premium_outlined,
      selectedIcon: Icons.workspace_premium_rounded,
      label: 'Badges',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 700;

    if (isWide) {
      return _DesktopLayout(
        currentIndex: _currentIndex,
        onNavigate: _onNavigate,
        navItems: _navItems,
        child: _buildScreen(_currentIndex),
      );
    }

    return _MobileLayout(
      currentIndex: _currentIndex,
      onNavigate: _onNavigate,
      navItems: _navItems,
      child: _buildScreen(_currentIndex),
    );
  }
}

// ─── Mobile Layout ────────────────────────────────────────────────────────────

class _MobileLayout extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onNavigate;
  final List<_NavItem> navItems;
  final Widget child;

  const _MobileLayout({
    required this.currentIndex,
    required this.onNavigate,
    required this.navItems,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: KeyedSubtree(
          key: ValueKey(currentIndex),
          child: child,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: onNavigate,
          elevation: 0,
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          animationDuration: const Duration(milliseconds: 300),
          destinations: navItems
              .map(
                (item) => NavigationDestination(
                  icon: Icon(item.icon),
                  selectedIcon: Icon(item.selectedIcon),
                  label: item.label,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

// ─── Desktop Layout ───────────────────────────────────────────────────────────

class _DesktopLayout extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onNavigate;
  final List<_NavItem> navItems;
  final Widget child;

  const _DesktopLayout({
    required this.currentIndex,
    required this.onNavigate,
    required this.navItems,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: Row(
        children: [
          // ── Sidebar ────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 16,
                  offset: const Offset(4, 0),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // App logo / brand
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 20),
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Center(
                            child: Text('🚸', style: TextStyle(fontSize: 24)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'SafeSteps',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: NavigationRail(
                      selectedIndex: currentIndex,
                      onDestinationSelected: onNavigate,
                      labelType: NavigationRailLabelType.all,
                      backgroundColor: Colors.transparent,
                      minWidth: 80,
                      groupAlignment: -1,
                      destinations: navItems
                          .map(
                            (item) => NavigationRailDestination(
                              icon: Icon(item.icon),
                              selectedIcon: Icon(item.selectedIcon),
                              label: Text(item.label),
                              padding: const EdgeInsets.symmetric(vertical: 4),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Main Content ───────────────────────────────────────
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: KeyedSubtree(
                    key: ValueKey(currentIndex),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Nav Item model ───────────────────────────────────────────────────────────

class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

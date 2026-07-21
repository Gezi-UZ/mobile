import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/theme.dart';
import 'quick_actions_bottom_sheet.dart';

/// Item de configuração para cada aba da bottom nav.
class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  /// Índice da branch no [StatefulNavigationShell] (null = não navega).
  final int branchIndex;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.branchIndex,
  });
}

/// Itens das 4 abas reais — o slot central é o FAB "+".
const _navItems = [
  _NavItem(
    label: 'Início',
    icon: Icons.home_outlined,
    activeIcon: Icons.home_rounded,
    branchIndex: 0,
  ),
  _NavItem(
    label: 'Recargas',
    icon: Icons.bolt_outlined,
    activeIcon: Icons.bolt_rounded,
    branchIndex: 1,
  ),
  // índice 2 reservado para o FAB central
  _NavItem(
    label: 'Documentos',
    icon: Icons.description_outlined,
    activeIcon: Icons.description_rounded,
    branchIndex: 3,
  ),
  _NavItem(
    label: 'Perfil',
    icon: Icons.person_outline_rounded,
    activeIcon: Icons.person_rounded,
    branchIndex: 4,
  ),
];

/// Shell com a Bottom Navigation Bar persistente.
/// Envolve as páginas principais da aplicação.
class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: navigationShell,
      bottomNavigationBar: _GezBottomNavBar(
        currentBranchIndex: navigationShell.currentIndex,
        onTap: (branchIndex) => navigationShell.goBranch(
          branchIndex,
          initialLocation: branchIndex == navigationShell.currentIndex,
        ),
      ),
    );
  }
}

class _GezBottomNavBar extends StatelessWidget {
  final int currentBranchIndex;
  final ValueChanged<int> onTap;

  const _GezBottomNavBar({
    required this.currentBranchIndex,
    required this.onTap,
  });

  void _openQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const QuickActionsBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border(
          top: BorderSide(
            color: Colors.black.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              // Posição 0: Início
              Expanded(
                child: _NavBarItem(
                  item: _navItems[0],
                  isSelected: currentBranchIndex == _navItems[0].branchIndex,
                  onTap: () => onTap(_navItems[0].branchIndex),
                ),
              ),
              // Posição 1: Recargas
              Expanded(
                child: _NavBarItem(
                  item: _navItems[1],
                  isSelected: currentBranchIndex == _navItems[1].branchIndex,
                  onTap: () => onTap(_navItems[1].branchIndex),
                ),
              ),
              // Posição 2: FAB "+" central
              _FabCenterButton(
                onTap: () => _openQuickActions(context),
              ),
              // Posição 3: Documentos
              Expanded(
                child: _NavBarItem(
                  item: _navItems[2],
                  isSelected: currentBranchIndex == _navItems[2].branchIndex,
                  onTap: () => onTap(_navItems[2].branchIndex),
                ),
              ),
              // Posição 4: Perfil
              Expanded(
                child: _NavBarItem(
                  item: _navItems[3],
                  isSelected: currentBranchIndex == _navItems[3].branchIndex,
                  onTap: () => onTap(_navItems[3].branchIndex),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Botão central em forma de círculo com gradiente laranja e ícone "+".
class _FabCenterButton extends StatelessWidget {
  final VoidCallback onTap;

  const _FabCenterButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFF6A00), Color(0xFFE84300)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6A00).withValues(alpha: 0.40),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Indicador pill quando activo
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: isSelected ? 32 : 0,
              height: 3,
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 4),
            Icon(
              isSelected ? item.activeIcon : item.icon,
              size: 24,
              color: isSelected ? AppTheme.primaryOrange : const Color(0xFFAAAAAA),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppTheme.primaryOrange : const Color(0xFFAAAAAA),
                fontFamily: 'Inter',
              ),
              child: Text(item.label),
            ),
          ],
        ),
      ),
    );
  }
}

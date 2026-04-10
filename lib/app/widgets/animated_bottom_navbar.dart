import 'dart:ui';
import 'package:flutter/material.dart';

class AnimatedBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AnimatedBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<AnimatedBottomNavBar> createState() => _AnimatedBottomNavBarState();
}

class _AnimatedBottomNavBarState extends State<AnimatedBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final activeColor = const Color(0xFF2563EB);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      margin: EdgeInsets.fromLTRB(24, 0, 24, 20 + bottomPadding),
      height: 70,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [],
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home_rounded, 'Home'),
          _buildNavItem(1, Icons.search_rounded, 'Search'),
          _buildNavItem(2, Icons.account_balance_wallet_rounded, 'Wallet'),
          _buildNavItem(3, Icons.newspaper_rounded, 'News'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = widget.currentIndex == index;
    final activeColor = const Color(0xFF2563EB);

    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? activeColor.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: isSelected ? activeColor : Colors.grey.withOpacity(0.8),
                size: 26,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: activeColor,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

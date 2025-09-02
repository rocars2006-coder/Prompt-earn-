import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigationWidget({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        border: Border(
          top: BorderSide(
            color: AppTheme.borderColor,
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.secondaryDark,
        selectedItemColor: AppTheme.accentColor,
        unselectedItemColor: AppTheme.textTertiary,
        selectedLabelStyle: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: currentIndex == 0
                  ? AppTheme.accentColor
                  : AppTheme.textTertiary,
              size: 24,
            ),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'add_circle_outline',
              color: currentIndex == 1
                  ? AppTheme.accentColor
                  : AppTheme.textTertiary,
              size: 24,
            ),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                CustomIconWidget(
                  iconName: 'leaderboard',
                  color: currentIndex == 2
                      ? AppTheme.accentColor
                      : AppTheme.textTertiary,
                  size: 24,
                ),
                if (currentIndex == 2)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: currentIndex == 3
                  ? AppTheme.accentColor
                  : AppTheme.textTertiary,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

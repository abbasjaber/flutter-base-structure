import 'package:app/utils/theme.dart';
import 'package:app/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onRefresh;
  final bool showMenu;
  final bool showBackButton;

  const CommonAppBar({
    super.key,
    required this.title,
    this.actions,
    this.onRefresh,
    this.showMenu = true,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: PrimeColors.pureWhite,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: PrimeColors.primaryRed,
      elevation: 0,
      centerTitle: true,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: PrimeColors.pureWhite,
              ),
              onPressed: () => context.pop(),
            )
          : null,
      actions: [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CommonBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isTmrUser;

  const CommonBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isTmrUser = true,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: PrimeColors.pureWhite,
      elevation: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            icon: AppIcons.homeIcon(
              size: 24,
              color: currentIndex == 0
                  ? PrimeColors.primaryRed
                  : PrimeColors.lightGray,
            ),
            onTap: () => onTap(0),
            isActive: currentIndex == 0,
          ),
          // _buildNavItem(
          //   icon: isTmrUser
          //       ? AppIcons.historyIcon(
          //           size: 24,
          //           color: currentIndex == 1
          //               ? PrimeColors.primaryRed
          //               : PrimeColors.lightGray,
          //         )
          //       : AppIcons.shoppingCartIcon(
          //           size: 24,
          //           color: currentIndex == 1
          //               ? PrimeColors.primaryRed
          //               : PrimeColors.lightGray,
          //         ),
          //   onTap: () => onTap(1),
          //   isActive: currentIndex == 1,
          // ),
          // _buildNavItem(
          //   icon: AppIcons.analyticsIcon(
          //     size: 24,
          //     color: currentIndex == 2
          //         ? PrimeColors.primaryRed
          //         : PrimeColors.lightGray,
          //   ),
          //   onTap: () => onTap(2),
          //   isActive: currentIndex == 2,
          // ),
          _buildNavItem(
            icon: AppIcons.userIcon(
              size: 24,
              color: currentIndex == 1
                  ? PrimeColors.primaryRed
                  : PrimeColors.lightGray,
            ),
            onTap: () => onTap(1),
            isActive: currentIndex == 1,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required Widget icon,
    required VoidCallback onTap,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isActive
              ? PrimeColors.primaryRed.withValues(alpha: 0.1)
              : Colors.transparent,
        ),
        child: icon,
      ),
    );
  }
}

class CommonFloatingActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  const CommonFloatingActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: PrimeColors.primaryRed,
      foregroundColor: PrimeColors.pureWhite,
      elevation: 4,
      icon: Icon(icon),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

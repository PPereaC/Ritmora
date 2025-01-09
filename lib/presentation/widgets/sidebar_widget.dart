import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

class CustomMusicSidebar extends StatelessWidget {
  const CustomMusicSidebar({super.key});

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    final items = [
      _SidebarItem(icon: Iconsax.home_2_outline, route: '/'),
      _SidebarItem(icon: Iconsax.heart_outline, route: '/favorites'),
      _SidebarItem(icon: Iconsax.music_library_2_outline, route: '/library'),
      _SidebarItem(icon: Iconsax.setting_3_outline, route: '/settings'),
    ];

    return Container(
      width: 80,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: colors.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(5, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: colors.surface.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Divider(color: Colors.white, height: 1),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: items.map((item) {
                        return _SidebarIconItem(
                          icon: item.icon,
                          route: item.route,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SidebarItem {
  final IconData icon;
  final String route;

  _SidebarItem({
    required this.icon,
    required this.route,
  });
}

class _SidebarIconItem extends StatelessWidget {
  final IconData icon;
  final String route;

  const _SidebarIconItem({
    required this.icon,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.toString();
    final isSelected = currentRoute == route;
    final colors = Theme.of(context).colorScheme;
  
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected 
                ? colors.primary.withOpacity(0.9) 
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected ? [
              BoxShadow(
                color: colors.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              )
            ] : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => context.go(route),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  icon,
                  size: 26,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
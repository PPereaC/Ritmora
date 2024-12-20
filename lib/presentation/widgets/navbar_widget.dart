import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/data/nav_bar_items.dart';

class Navbar extends ConsumerStatefulWidget {
  const Navbar({super.key});

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends ConsumerState<Navbar> {
  int selectedIndex = 0;

  void onItemTapped(int index) async {
    setState(() {
      selectedIndex = index;
    });

    switch (index){
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/library');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
  
    return Container(
      color: Colors.transparent,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.lerp(colors.onSurface, colors.primary, 0.1) ?? colors.onSurface,
                Color.lerp(colors.onSurface, colors.secondary, 0.2) ?? colors.onSurface,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withOpacity(0.2),
                offset: const Offset(0, 10),
                blurRadius: 24,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: colors.primary.withOpacity(0.05),
                offset: const Offset(0, 4),
                blurRadius: 12,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                offset: const Offset(0, -2),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              bottomNavItems.length,
              (index) {
                final isSelected = selectedIndex == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  child: InkWell(
                    onTap: () => onItemTapped(index),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(bottom: 8),
                          height: 5,
                          width: isSelected ? 20 : 0,
                          decoration: BoxDecoration(
                            color: colors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        Icon(
                          bottomNavItems[index].icon,
                          size: 28,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
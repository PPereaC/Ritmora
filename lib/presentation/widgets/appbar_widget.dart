import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey[900],
      elevation: 0,
      title: Row(
        children: [
          // Imagen circular (logo)
          Image.asset(
            'assets/images/logo.png',
            width: 45,
            height: 45,
            fit: BoxFit.cover,
          ),
          
          const SizedBox(width: 12),
          
          // Texto
          const Text(
            'MUSIC',
            style: TextStyle(
              fontFamily: 'Appbar',
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
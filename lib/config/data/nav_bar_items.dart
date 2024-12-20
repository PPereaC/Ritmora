
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class NavItemModel {
  final String title;
  final IconData icon;

  NavItemModel({required this.title, required this.icon});
  
}

List<NavItemModel> bottomNavItems = [
  NavItemModel(title: 'Inicio', icon: Iconsax.home_2_outline),
  NavItemModel(title: 'Favoritas', icon: Iconsax.heart_outline),
  NavItemModel(title: 'Biblioteca', icon: Iconsax.music_library_2_outline),
  NavItemModel(title: 'Ajustes', icon: Iconsax.setting_3_outline),
];

import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class NavItemModel {
  final String title;
  final IconData icon;
  final IconData iconSelected;

  NavItemModel({required this.title, required this.icon, required this.iconSelected});
  
}

List<NavItemModel> bottomNavItems = [
  NavItemModel(title: 'Inicio', icon: Iconsax.home_2_outline, iconSelected: Iconsax.home_2_bold),
  NavItemModel(title: 'Buscar', icon: Iconsax.search_normal_outline, iconSelected: Iconsax.search_normal_bold),
  NavItemModel(title: 'Biblioteca', icon: Iconsax.music_library_2_outline, iconSelected: Iconsax.music_library_2_bold),
];
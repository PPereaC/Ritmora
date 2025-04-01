
import 'package:flutter/cupertino.dart';
import 'package:icons_plus/icons_plus.dart';

class NavItemModel {
  final String title;
  final IconData icon;
  final IconData iconSelected;

  NavItemModel({required this.title, required this.icon, required this.iconSelected});
  
}

List<NavItemModel> bottomNavItems = [
  NavItemModel(title: 'Inicio', icon: MingCute.home_4_line, iconSelected: MingCute.home_4_fill),
  NavItemModel(title: 'Buscar', icon: MingCute.search_line, iconSelected: MingCute.search_fill),
  NavItemModel(title: 'Biblioteca', icon: MingCute.music_3_line, iconSelected: MingCute.music_3_fill),
];
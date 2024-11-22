import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/utils/responsive.dart';
import '../widgets/widget.dart';

class RootScreen extends StatelessWidget {

  final StatefulNavigationShell navigationShell;

  const RootScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {

    final isMobile = Responsive.isMobile(context);
    // ignore: unused_local_variable
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: navigationShell,
      bottomNavigationBar: isMobile ? const Navbar() : const SizedBox(),
    );
  }
}
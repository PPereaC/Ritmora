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
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      body: const Center(
        child: Text('Root Screen'),
      ),
      bottomNavigationBar: isMobile ? const Navbar() : const SizedBox(),
    );
  }
}
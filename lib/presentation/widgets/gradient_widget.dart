// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';

class GradientWidget extends ConsumerWidget {
  const GradientWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final size = MediaQuery.of(context).size;
    final colorProvider = ref.watch(songColorProvider);

    return Positioned(
      left: -50,
      top: -50,
      child: Container(
        height: size.height * 0.8,
        width: size.width * 1.5,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.5,
            colors: [
              colorProvider.withOpacity(0.7),
              colorProvider.withOpacity(0.3),
              Colors.transparent,
            ],
            stops: const [0.0, 0.4, 0.9],
          ),
        ),
      ),
    );
  }
}
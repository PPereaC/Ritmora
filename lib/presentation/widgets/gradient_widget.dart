import 'package:flutter/material.dart';

class GradientWidget extends StatelessWidget {
  const GradientWidget({super.key});

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

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
              colors.primary.withOpacity(0.7),
              colors.primary.withOpacity(0.3),
              Colors.transparent,
            ],
            stops: const [0.0, 0.4, 0.9],
          ),
        ),
      ),
    );
  }
}
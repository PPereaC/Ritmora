import 'package:flutter/material.dart';

class MusicProgressBar extends StatefulWidget {
  final Duration currentPosition;
  final Duration duration;
  final ValueChanged<Duration>? onChanged;
  final Function(Duration)? onChangeEnd;

  const MusicProgressBar({
    super.key,
    required this.currentPosition,
    required this.duration,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  State<MusicProgressBar> createState() => _MusicProgressBarState();
}

class _MusicProgressBarState extends State<MusicProgressBar> {
  double? dragValue;
  bool isDragging = false;

  void _updateProgressPosition(double dx, BoxConstraints constraints) {
    // Calcular el valor normalizado (0.0 a 1.0) basado en la posición horizontal
    final double normalizedValue = (dx / constraints.maxWidth).clamp(0.0, 1.0);
    
    // Actualizar el valor de arrastre
    setState(() {
      dragValue = normalizedValue;
    });
    
    // Calcular la nueva duración y notificar
    if (widget.duration.inMilliseconds > 0) {
      final newPosition = Duration(
        milliseconds: (widget.duration.inMilliseconds * normalizedValue).round(),
      );
      widget.onChanged?.call(newPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = isDragging
        ? dragValue!
        : widget.duration.inMilliseconds > 0
            ? widget.currentPosition.inMilliseconds / widget.duration.inMilliseconds
            : 0.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onHorizontalDragStart: (DragStartDetails details) {
            setState(() {
              isDragging = true;
              // Inicializar dragValue con la posición actual
              dragValue = widget.currentPosition.inMilliseconds / widget.duration.inMilliseconds;
            });
            _updateProgressPosition(details.localPosition.dx, constraints);
          },
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            _updateProgressPosition(details.localPosition.dx, constraints);
          },
          onHorizontalDragEnd: (DragEndDetails details) {
            if (dragValue != null) {
              final newPosition = Duration(
                milliseconds: (widget.duration.inMilliseconds * dragValue!).round(),
              );
              widget.onChangeEnd?.call(newPosition);
            }
            
            setState(() {
              isDragging = false;
              dragValue = null;
            });
          },
          onTapDown: (TapDownDetails details) {
            _updateProgressPosition(details.localPosition.dx, constraints);
            // Notificar el cambio final inmediatamente en tap
            if (dragValue != null) {
              final newPosition = Duration(
                milliseconds: (widget.duration.inMilliseconds * dragValue!).round(),
              );
              widget.onChangeEnd?.call(newPosition);
            }
          },
          child: Container(
            height: 36,
            width: double.infinity,
            color: Colors.transparent,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Barra de fondo
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
                // Barra de progreso
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: constraints.maxWidth * progress,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  ),
                ),
                // Punto de control
                Positioned(
                  left: (constraints.maxWidth * progress) - (isDragging ? 8 : 6),
                  child: Container(
                    height: isDragging ? 16 : 12,
                    width: isDragging ? 16 : 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ModernProgressBar extends StatefulWidget {
  final Duration currentPosition;
  final Duration duration;
  final ValueChanged<Duration>? onChanged;
  final Function(Duration)? onChangeEnd;
  final Color accentColor;
  final Color backgroundColor;

  const ModernProgressBar({
    super.key,
    required this.currentPosition,
    required this.duration,
    this.onChanged,
    this.onChangeEnd,
    this.accentColor = Colors.white,
    this.backgroundColor = Colors.white24,
  });

  @override
  State<ModernProgressBar> createState() => _ModernProgressBarState();
}

class _ModernProgressBarState extends State<ModernProgressBar> with SingleTickerProviderStateMixin {
  double? dragValue;
  bool isDragging = false;
  late AnimationController _scaleController;
  
  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }
  
  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _updateProgressPosition(double dx, BoxConstraints constraints) {
    final double normalizedValue = (dx / constraints.maxWidth).clamp(0.0, 1.0);
    
    setState(() {
      dragValue = normalizedValue;
    });
    
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
              dragValue = widget.currentPosition.inMilliseconds / 
                  (widget.duration.inMilliseconds > 0 ? widget.duration.inMilliseconds : 1);
            });
            _scaleController.forward();
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
            
            _scaleController.reverse();
            setState(() {
              isDragging = false;
              dragValue = null;
            });
          },
          onTapDown: (TapDownDetails details) {
            _updateProgressPosition(details.localPosition.dx, constraints);
            if (dragValue != null) {
              final newPosition = Duration(
                milliseconds: (widget.duration.inMilliseconds * dragValue!).round(),
              );
              widget.onChangeEnd?.call(newPosition);
              setState(() {
                dragValue = null;
              });
            }
          },
          child: Container(
            height: 40,
            width: double.infinity,
            color: Colors.transparent,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Barra de fondo con diseño moderno
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: widget.backgroundColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                // Barra de progreso con degradado y forma elegante
                Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: constraints.maxWidth * progress,
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.accentColor,
                          widget.accentColor.withOpacity(0.8),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: widget.accentColor.withOpacity(0.3),
                          blurRadius: 4,
                          spreadRadius: 0.5,
                        ),
                      ],
                    ),
                  ),
                ),

                // Indicador de progreso con efecto de brillo
                AnimatedBuilder(
                  animation: _scaleController,
                  builder: (context, child) {
                    final scale = 1.0 + (_scaleController.value * 0.4);
                    return Positioned(
                      left: (constraints.maxWidth * progress) - 6,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: isDragging ? 1.0 : (progress > 0.01 ? 0.8 : 0.0),
                        child: Transform.scale(
                          scale: isDragging ? scale : 1.0,
                          child: Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: widget.accentColor,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: widget.accentColor.withOpacity(0.4),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                ),
                
                // Área de toque ampliada para mejor experiencia de usuario
                Positioned.fill(
                  child: Container(
                    color: Colors.transparent,
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

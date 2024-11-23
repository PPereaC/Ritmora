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

class _MusicProgressBarState extends State<MusicProgressBar> with SingleTickerProviderStateMixin {
  double? dragValue;
  bool isDragging = false;
  late AnimationController _animationController;
  double _lastProgress = 0.0;
  // ignore: unused_field
  double _targetProgress = 0.0;
  bool _isAnimating = false;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150), // Duración corta para cada paso
    );
    _animationController.addListener(() {
      setState(() {});
    });
  }

  void _animateToProgress(double targetProgress) async {
    if (_isAnimating) return;
    _isAnimating = true;
    
    const steps = 8; // Número de pasos intermedios
    final startProgress = _lastProgress;
    final totalDiff = targetProgress - startProgress;
    
    for (var i = 1; i <= steps; i++) {
      if (!mounted || isDragging) break;
      
      // Calculamos el siguiente punto intermedio
      final nextProgress = startProgress + (totalDiff * (i / steps));
      
      // Animamos hasta ese punto
      await _animationController.animateTo(
        nextProgress,
        duration: Duration(milliseconds: 150 + (i * 50)), // Duración incrementa con cada paso
        curve: Curves.easeOutCubic,
      );
      
      // Pequeña pausa entre pasos
      await Future.delayed(const Duration(milliseconds: 20));
    }
    
    _lastProgress = targetProgress;
    _isAnimating = false;
  }

  @override
  void didUpdateWidget(MusicProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (!isDragging) {
      final newProgress = widget.currentPosition.inSeconds /
          (widget.duration.inSeconds == 0 ? 1 : widget.duration.inSeconds);
      
      if ((newProgress - _lastProgress).abs() > 0.01) {
        _targetProgress = newProgress;
        _animateToProgress(newProgress);
      }
    }
  }

  double get _progress {
    if (isDragging) return dragValue ?? 0.0;
    return _animationController.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (DragStartDetails details) {
        isDragging = true;
        _animationController.stop();
        setState(() {});
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        final box = context.findRenderObject() as RenderBox;
        final dx = details.localPosition.dx;
        final newValue = (dx / box.size.width).clamp(0.0, 1.0);
        dragValue = newValue;
        _lastProgress = newValue;
        final newDuration = Duration(
          seconds: (widget.duration.inSeconds * newValue).round(),
        );
        widget.onChanged?.call(newDuration);
        setState(() {});
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        if (dragValue != null) {
          final newDuration = Duration(
            seconds: (widget.duration.inSeconds * dragValue!).round(),
          );
          widget.onChangeEnd?.call(newDuration);
          _animationController.value = dragValue!;
        }
        isDragging = false;
        dragValue = null;
        setState(() {});
      },
      child: Container(
        height: 36,
        width: double.infinity,
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 3,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: (MediaQuery.of(context).size.width - 40) * _progress,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              ),
            ),
            Positioned(
              left: (MediaQuery.of(context).size.width - 40) * _progress,
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
  }
}
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class MusicProgressBar extends StatelessWidget {
  final Duration currentPosition;
  final Duration duration;
  final Function(Duration) onChangeEnd;

  const MusicProgressBar({
    super.key,
    required this.currentPosition,
    required this.duration,
    required this.onChangeEnd,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 2.0,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 4.0,
          pressedElevation: 8.0,
        ),
        overlayShape: const RoundSliderOverlayShape(
          overlayRadius: 12.0,
        ),
        activeTrackColor: Colors.blue,
        inactiveTrackColor: Colors.grey.withOpacity(0.3),
        thumbColor: Colors.blue,
        overlayColor: Colors.blue.withOpacity(0.2),
      ),
      child: Slider(
        min: 0.0,
        max: duration.inMilliseconds.toDouble(),
        value: currentPosition.inMilliseconds.toDouble(),
        onChanged: (value) {
          final position = Duration(milliseconds: value.round());
          onChangeEnd(position);
        },
      ),
    );
  }
}
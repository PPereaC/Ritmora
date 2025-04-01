import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final songColorProvider = StateNotifierProvider<SongColorNotifier, Color>((ref) {
  return SongColorNotifier();
});

class SongColorNotifier extends StateNotifier<Color> {
  SongColorNotifier() : super(Colors.black);

  void updateColor(Color color) {
    state = color;
  }
}
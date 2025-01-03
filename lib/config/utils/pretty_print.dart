import 'package:flutter/foundation.dart';

void printERROR(dynamic text, {String tag = "Apolo Music"}) {
  if (kReleaseMode) return;
  debugPrint("\x1B[31m[$tag]: $text\x1B[0m");
}

void printWarning(dynamic text, {String tag = 'Apolo Music'}) {
  if (kReleaseMode) return;
  debugPrint("\x1B[33m[$tag]: $text\x1B[34m");
}

void printINFO(dynamic text, {String tag = 'Apolo Music'}) {
  if (kReleaseMode) return;
  debugPrint("\x1B[32m[$tag]: $text\x1B[34m");
}
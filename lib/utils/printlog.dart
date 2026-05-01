import 'dart:convert';

import 'package:flutter/foundation.dart';

enum LogType { general, success, error }

void printLog(dynamic output, {LogType type = LogType.general}) {
  final generalColor = '36m'; // cyan
  final errorColor = '31m'; // red
  final successColor = '32m'; // green

  String color = generalColor;
  switch (type) {
    case LogType.success:
      color = successColor;
      break;
    case LogType.error:
      color = errorColor;
      break;
    default:
      break;
  }

  try {
    debugPrint('\x1B[$color${jsonEncode(output)}\x1B[0m');
  } catch (_) {
    final value = output.toString();
    int maxLogSize = 1000;
    for (int i = 0; i <= value.length / maxLogSize; i++) {
      int start = i * maxLogSize;
      int end = (i + 1) * maxLogSize;
      end = end > value.length ? value.length : end;
      if (kDebugMode) {
        print('\x1B[$color${value.substring(start, end)}\x1B[0m');
      }
    }
  }
}

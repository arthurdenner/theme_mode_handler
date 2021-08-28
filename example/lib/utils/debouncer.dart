// Extracted from https://medium.com/fantageek/how-to-debounce-action-in-flutter-ed7177843407

import 'dart:async';
import 'package:flutter/foundation.dart';

class Debouncer {
  Debouncer({required this.ms});

  final int ms;

  Timer? _timer;

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer(Duration(milliseconds: ms), action);
  }
}

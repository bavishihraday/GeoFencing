import 'package:flutter/foundation.dart';

// Not used in this project so far. Use ValueNotifier for classes with 1 values
class Counter with ChangeNotifier {
  int value = 0;

  void increment() {
    value++;
    notifyListeners();
  }
  void decrement() {
    value--;
    notifyListeners();
  }
}

Counter counterProvider = Counter();

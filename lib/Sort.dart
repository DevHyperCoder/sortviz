import 'dart:async';

import 'package:sortviz/sorters/bubble.dart';
import 'package:sortviz/sorters/merge.dart';

class Sort {
  List<int> _array = [];
  int _delay = 100;
  StreamController arrayController = StreamController();

  dispose() {
    arrayController.close();
  }

  setArray(arr) {
    _array = arr;
    arrayController.add(arr);
  }

  setDelay(delay) {
    _delay = delay;
  }

  sort(String algo) async {
    if (algo == "Bubble") {
      await bubbleSort(_array, _delay, () {
        arrayController.add(_array);
      });
    } else if (algo == "Merge") {
      await mergeSort(_array, _delay, () {
        arrayController.add(_array);
      });
    }
  }
}

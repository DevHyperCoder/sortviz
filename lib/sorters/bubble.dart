bubbleSort(List<int> list, int delay, fn) async {
  if (list.length == 0) return;

  int n = list.length;
  int i, step;
  for (step = 0; step < n; step++) {
    for (i = 0; i < n - step - 1; i++) {
      if (list[i] > list[i + 1]) {
        swap(list, i);
        await Future.delayed(Duration(milliseconds: delay));
        fn();
      }
    }
  }
}

void swap(List list, int i) {
  int temp = list[i];
  list[i] = list[i + 1];
  list[i + 1] = temp;
}

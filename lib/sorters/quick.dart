_quickSort(List<int> list, int low, int high, delay, fn) async {
  if (low < high) {
    int pi = await partition(list, low, high, delay, fn);

    await _quickSort(list, low, pi - 1, delay, fn);
    await _quickSort(list, pi + 1, high, delay, fn);
  }
}

partition(List<int> list, low, high, delay, fn) async {
  // Base check
  if (list.isEmpty) {
    return 0;
  }
  // Take our last element as pivot and counter i one less than low
  int pivot = list[high];

  int i = low - 1;
  for (int j = low; j < high; j++) {
    // When j is < than pivot element we increment i and swap arr[i] and arr[j]
    if (list[j] < pivot) {
      i++;
      swap(list, i, j);
      await Future.delayed(Duration(milliseconds: delay));
      fn();
    }
  }
  // Swap the last element and place in front of the i'th element
  swap(list, i + 1, high);
  await Future.delayed(Duration(milliseconds: delay));
  fn();
  return i + 1;
}

// Swapping using a temp variable
void swap(List list, int i, int j) {
  int temp = list[i];
  list[i] = list[j];
  list[j] = temp;
}

quickSort(List<int> list, int delay, fn) async {
  int high = list.length - 1;
  int low = 0;
  await _quickSort(list, low, high, delay, fn);
}

merge(List<int> list, int leftIndex, int middleIndex, int rightIndex, int delay,
    fn) async {
  int leftSize = middleIndex - leftIndex + 1;
  int rightSize = rightIndex - middleIndex;

  List leftList = List.filled(leftSize, 0);
  List rightList = List.filled(rightSize, 0);

  for (int i = 0; i < leftSize; i++) leftList[i] = list[leftIndex + i];
  for (int j = 0; j < rightSize; j++) rightList[j] = list[middleIndex + j + 1];

  int i = 0, j = 0;
  int k = leftIndex;

  while (i < leftSize && j < rightSize) {
    if (leftList[i] <= rightList[j]) {
      list[k] = leftList[i];
      await Future.delayed(Duration(milliseconds: delay));
      fn();
      i++;
    } else {
      list[k] = rightList[j];
      await Future.delayed(Duration(milliseconds: delay));
      fn();
      j++;
    }
    k++;
  }

  while (i < leftSize) {
    list[k] = leftList[i];
    await Future.delayed(Duration(milliseconds: delay));
    fn();
    i++;
    k++;
  }

  while (j < rightSize) {
    list[k] = rightList[j];
    await Future.delayed(Duration(milliseconds: delay));
    fn();
    j++;
    k++;
  }
}

_mergeSort(List<int> list, int leftIndex, int rightIndex, int delay, fn) async {
  if (leftIndex < rightIndex) {
    int middleIndex = (rightIndex + leftIndex) ~/ 2;

    await _mergeSort(list, leftIndex, middleIndex, delay, fn);
    await _mergeSort(list, middleIndex + 1, rightIndex, delay, fn);

    await merge(list, leftIndex, middleIndex, rightIndex, delay, fn);
  }
}

mergeSort(List<int> list, int delay, fn) async {
  await _mergeSort(list, 0, list.length - 1, delay, fn);
}

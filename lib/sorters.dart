// SORTERS

merge(List<int> list, int leftIndex, int middleIndex, int rightIndex) async {
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
      await Future.delayed(Duration(milliseconds: settings.milliDelay));
      setState(() {
        array = list;
      });
      i++;
    } else {
      list[k] = rightList[j];
      await Future.delayed(Duration(milliseconds: settings.milliDelay));
      setState(() {
        array = list;
      });
      j++;
    }
    k++;
  }

  while (i < leftSize) {
    list[k] = leftList[i];
    await Future.delayed(Duration(milliseconds: settings.milliDelay));
    setState(() {
      array = list;
    });
    i++;
    k++;
  }

  while (j < rightSize) {
    list[k] = rightList[j];
    await Future.delayed(Duration(milliseconds: settings.milliDelay));
    setState(() {
      array = list;
    });
    j++;
    k++;
  }
}

mergeSort(List<int> list, int leftIndex, int rightIndex) async {
  if (leftIndex < rightIndex) {
    int middleIndex = (rightIndex + leftIndex) ~/ 2;

    await mergeSort(list, leftIndex, middleIndex);
    await mergeSort(list, middleIndex + 1, rightIndex);

    await merge(list, leftIndex, middleIndex, rightIndex);
  }
}

bubbleSort(List<int> list) async {
  if (list.length == 0) return;

  int n = list.length;
  int i, step;
  for (step = 0; step < n; step++) {
    for (i = 0; i < n - step - 1; i++) {
      if (list[i] > list[i + 1]) {
        swap(list, i);
        await Future.delayed(Duration(milliseconds: settings.milliDelay));
        setState(() {
          array = list;
        });
      }
    }
  }
}

void swap(List list, int i) {
  int temp = list[i];
  list[i] = list[i + 1];
  list[i + 1] = temp;
}

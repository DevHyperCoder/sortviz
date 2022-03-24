class SettingsModel {
  int arraySize;
  ArrayFillModel fillMethod;

  SettingsModel({required this.arraySize, required this.fillMethod});
}

enum ArrayFillModel { Random, RandomSortedReverse }

String arrayFillMethodToString(ArrayFillModel a) {
  if (a == ArrayFillModel.Random) {
    return "Random";
  } else if (a == ArrayFillModel.RandomSortedReverse) {
    return "Sorted - Reverse";
  }
  return "";
}

ArrayFillModel? stringToArrayFillMethod(String s) {
  if (s == "Random") {
    return ArrayFillModel.Random;
  } else if (s == "Sorted - Reverse") {
    return ArrayFillModel.RandomSortedReverse;
  } else {
    return null;
  }
}

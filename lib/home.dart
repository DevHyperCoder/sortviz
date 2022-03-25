/*
   Home page
*/

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sortviz/SettingsModel.dart';
import 'package:sortviz/SortViz.dart';

import 'SettingsDialog.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State {
  SettingsModel settings = SettingsModel(
      arraySize: 30, fillMethod: ArrayFillModel.Random, milliDelay: 100);
  List<int> array = [];
  String algo = "Bubble";

  Stream arrayChanges = Stream.empty();
  StreamController arrayChangesController = StreamController();

  void dispose() {
    arrayChangesController.close();
    super.dispose();
  }

  fillArray() {
   final content = getArrayContent(settings.arraySize, settings.fillMethod);
   arrayChangesController.add(content);

    setState(() {
      array = content;
    });
  }

  getArrayContent(int size, ArrayFillModel method) {
    final random = Random();
    final list = List.generate(size, (index) {
      return random.nextInt(100);
    });

    if (method == ArrayFillModel.Random) {
      return list;
    } else {
      list.sort();
      return list.reversed.toList();
    }
  }

  // SORTERS

  merge(List<int> list, int leftIndex, int middleIndex, int rightIndex) async {
    int leftSize = middleIndex - leftIndex + 1;
    int rightSize = rightIndex - middleIndex;

    List leftList = List.filled(leftSize, 0);
    List rightList = List.filled(rightSize, 0);

    for (int i = 0; i < leftSize; i++) leftList[i] = list[leftIndex + i];
    for (int j = 0; j < rightSize; j++)
      rightList[j] = list[middleIndex + j + 1];

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

  start() async {
    if (algo == "Bubble") {
      await bubbleSort(array);
    } else if (algo == "Merge") {
      await mergeSort(array, 0, array.length - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SortViz"),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(child: 
                StreamBuilder(
                    stream: arrayChangesController.stream,
                    builder: (ctx,snap) {

                      if (snap.hasData) {
                        return SortViz(array: snap.data as List<int>);
                      } else {
                        return Text("Randomize the data first");
                      }
                    },
                    ),
            ),
            Row(
              children: [
                OutlinedButton(child: Text("Randomize"), onPressed: fillArray),
                IconButton(
                    icon: Icon( Icons.play_arrow),
                    onPressed: start),
                IconButton(
                  onPressed: () async {
                    SettingsModel a = await showDialog(
                        context: context,
                        builder: (b) {
                          return SettingsDialog(settings: settings);
                        });
                    setState(() {
                      settings = a;
                    });
                    fillArray();
                  },
                  icon: Icon(Icons.settings),
                ),
                DropdownButton(
                  value: algo,
                  onChanged: (String? s) {
                    setState(() {
                      algo = s!;
                    });
                  },
                  items: <String>[
                    'Bubble',
                    'Merge',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            Text((array.length == 0 ? "Randomize the array" :  array).toString())
          ],
        ),
      ),
    );
  }
}

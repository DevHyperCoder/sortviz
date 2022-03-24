/*
   Home page
*/

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
  SettingsModel settings =
      SettingsModel(arraySize: 30, fillMethod: ArrayFillModel.Random);
  List<int> array = [];
  bool isPlaying = false;

  fillArray() {
    setState(() {
      array = getArrayContent(settings.arraySize, settings.fillMethod);
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

  void bubbleSort(List<int> list) async {
    if (list.length == 0) return;

    int n = list.length;
    int i, step;
    for (step = 0; step < n; step++) {
      for (i = 0; i < n - step - 1; i++) {
        if (!isPlaying) return;
        if (list[i] > list[i + 1]) {
          swap(list, i);
          await Future.delayed(Duration(milliseconds: 100));
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

  start() {
    final old = isPlaying;
    setState(() {
      isPlaying = !isPlaying;
    });

    if (!old) {
      bubbleSort(array);
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
            Expanded(child: SortViz(array: array)),
            ButtonBar(
              alignment: MainAxisAlignment.start,
              children: [
                OutlinedButton(child: Text("Randomize"), onPressed: fillArray),
                IconButton(icon: Icon(Icons.play_arrow), onPressed: start),
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
                Text(array.toString())
              ],
            )
          ],
        ),
      ),
    );
  }
}

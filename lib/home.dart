/*
   Home page
*/

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sortviz/SortViz.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State {
  int arrayLen = 30;
  List<int> array = [];

  fillArray() {
    final random = Random();
    setState(() {
      array = List.generate(arrayLen, (index) {
        return random.nextInt(100);
      });
    });
  }

  void bubbleSort(List<int> list) async {
    if (list.length == 0) return;

    int n = list.length;
    int i, step;
    for (step = 0; step < n; step++) {
      for (i = 0; i < n - step - 1; i++) {
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
    bubbleSort(array);
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
                OutlinedButton(child: Text("Start"), onPressed: start),
                Text(array.toString())
              ],
            )
          ],
        ),
      ),
    );
  }
}

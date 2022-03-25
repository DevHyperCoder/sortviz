/*
   Home page
*/

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sortviz/SettingsModel.dart';
import 'package:sortviz/Sort.dart';
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
  String algo = "Bubble";

  Sort sort = Sort();

  void initState() {
    super.initState();
    fillArray();
  }

  void dispose() {
    sort.dispose();
    super.dispose();
  }

  fillArray() {
    final content = getArrayContent(settings.arraySize, settings.fillMethod);

    sort.setArray(content);
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

  start() async {
    await sort.sort(algo);
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
            StreamBuilder(
              stream: sort.arrayController.stream,
              builder: (ctx, snap) {
                if (snap.hasData) {
                  //print("snap: ${snap.data.toString()}");
                  return Expanded(
                      child: Column(
                    children: [
                      Text(snap.data.toString()),
                      Expanded(child: SortViz(array: snap.data as List<int>))
                    ],
                  ));
                } else {
                  return Text("Randomize the data first");
                }
              },
            ),
            Row(
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
            //Text((array.length == 0 ? "Randomize the array" :  array).toString())
          ],
        ),
      ),
    );
  }
}

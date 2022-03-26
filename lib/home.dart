/*
   Home page
*/

import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sortviz/SettingsModel.dart';
import 'package:sortviz/Sort.dart';
import 'package:sortviz/SortViz.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool isSorting = false;

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
    setState(() {
      isSorting = true;
    });
    await sort.sort(algo);
    setState(() {
      isSorting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SortViz"),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return AboutDialog(
                        applicationLegalese: "© DevHyperCoder",
                        applicationIcon: Icon(Icons.more),
                        applicationVersion: "0.0.1",
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            width: 300,
                            child: Column(children: [
                              Text(
                                  "SortViz is a sorting visualiser, making use of the Flutter canvas API and more. SortViz is Free and Open Source Software, licensed under the GNU GPL 3."),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                      child: TextButton(
                                        onPressed: () {
                                          launch(
                                              "https://github.com/DevHyperCoder/sortviz.git");
                                        },
                                        child: Text("GitHub"),
                                      )),
                                ],
                              )
                            ]),
                          ),
                        ],
                      );
                    });
              },
              icon: Icon(Icons.info_outline))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            StreamBuilder(
              stream: sort.arrayController.stream,
              builder: (ctx, snap) {
                if (snap.hasData) {
                  return Expanded(
                    child: Column(
                      children: [
                        Expanded(child: SortViz(array: snap.data as List<int>)),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: SingleChildScrollView(
                            child: Text(snap.data.toString()),
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Text("Randomize the data first");
                }
              },
            ),
            Row(
              children: [
                OutlinedButton(
                    child: Text("Randomize"),
                    onPressed: isSorting ? null : fillArray),
                IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: isSorting ? null : start),
                IconButton(
                  onPressed: isSorting
                      ? null
                      : () async {
                          SettingsModel? a = await showDialog(
                              context: context,
                              builder: (b) {
                                return SettingsDialog(settings: settings);
                              });
                          if (a != null) {
                            setState(() {
                              settings = a;
                            });
                            fillArray();
                          }
                        },
                  icon: Icon(Icons.settings),
                ),
                DropdownButton(
                  value: algo,
                  onChanged: isSorting
                      ? null
                      : (String? s) {
                          setState(() {
                            algo = s!;
                          });
                        },
                  items: <String>[
                    'Bubble',
                    'Merge',
                    'Quick',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/*
   Main entry point
*/
import 'package:flutter/material.dart';
import 'package:sortviz/SettingsModel.dart';
import 'package:sortviz/SettingsPage.dart';

import 'home.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (ctx) => HomePage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == SettingsPage.route) {
          final args = settings.arguments as SettingsModel;

          return MaterialPageRoute(
            builder: (context) => SettingsPage(settings: args),
          );
        }
        return null;
      },
      title: 'SortViz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

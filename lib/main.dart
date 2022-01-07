import 'package:time_tracker/page_activities.dart';
// ignore: unused_import
import 'package:time_tracker/PageIntervals.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Title',
      theme: ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.dark,
      /* ThemeMode.system to follow system theme, 
         ThemeMode.light for light theme, 
         ThemeMode.dark for dark theme
      */
      home: PageActivities(0),
    );
    /*
    return MaterialApp(
      title: 'TimeTracker',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        backgroundColor: Colors.grey,
        textTheme: TextTheme(
            subtitle1: TextStyle(fontSize: 20.0),
            bodyText2: TextStyle(fontSize: 20.0)),
      ),
      home: PageActivities(0),
    );*/
  }
}

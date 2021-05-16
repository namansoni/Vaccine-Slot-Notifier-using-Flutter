import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaccineslotreminder/Models/reminderModel.dart';
import 'package:vaccineslotreminder/providers/reminderProvider.dart';

import 'Screens/Home/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
       ChangeNotifierProvider.value(value: ReminderProvider()),
      ],
      child: MaterialApp(
        home: Home(),
      ),
    );
  }
}

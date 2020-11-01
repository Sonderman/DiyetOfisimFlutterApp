import 'package:flutter/material.dart';

class MyCalendarPage extends StatefulWidget {
  MyCalendarPage({Key key}) : super(key: key);

  @override
  _MyCalendarPageState createState() => _MyCalendarPageState();
}

class _MyCalendarPageState extends State<MyCalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Randevu takvimim sayfası"),
      ),
    );
  }
}

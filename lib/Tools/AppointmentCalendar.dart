import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';

class AppointmentCalendar extends StatefulWidget {
  AppointmentCalendar({Key key}) : super(key: key);

  @override
  _AppointmentCalendarState createState() => _AppointmentCalendarState();
}

class _AppointmentCalendarState extends State<AppointmentCalendar> {
  Map<String, dynamic> appointments = {
    "2020": {
      "11": {
        "22": {"08:00": true, "08:45": true, "09:30": true, "11:45": true},
        "23": {"09:00": true, "09:45": true, "11:30": true, "14:45": true}
      }
    }
  };

  int year = DateTime.now().year;
  int month = DateTime.now().month;
  int day = DateTime.now().day;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          DatePicker(
            DateTime.now(),
            locale: "tr",
            initialSelectedDate: DateTime.now(),
            selectionColor: Colors.green,
            selectedTextColor: Colors.white,
            daysCount: 60,
            onDateChange: (date) {
              setState(() {
                year = date.year;
                month = date.month;
                day = date.day;
              });
            },
          ),
          Divider(),
          Container(
            child: Wrap(children: hoursCardsGenerator()),
          )
        ],
      )),
    );
  }

  List<Widget> hoursCardsGenerator() {
    try {
      if ((appointments[year.toString()][month.toString()][day.toString()]
              as Map) !=
          null) {
        return (appointments[year.toString()][month.toString()][day.toString()]
                as Map)
            .keys
            .map((e) => hourCard(e))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Card hourCard(String e) {
    return Card(
      margin: EdgeInsets.all(15),
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          e,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}

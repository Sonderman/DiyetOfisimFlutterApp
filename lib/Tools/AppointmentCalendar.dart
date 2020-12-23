import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';

class AppointmentCalendar extends StatefulWidget {
  AppointmentCalendar({Key key}) : super(key: key);

  @override
  _AppointmentCalendarState createState() => _AppointmentCalendarState();
}

class _AppointmentCalendarState extends State<AppointmentCalendar> {
  final List<String> saatler = [
    "09:00",
    "10:00",
    "11:00",
    "12:00",
    "14:00",
    "15:00",
    "16:00",
    "17:00",
    "18:00",
    "19:00",
    "20:00"
  ];
  Map<String, dynamic> appointments = {
    "2020": {
      "12": {
        "23": {"09:00": 0, "10:00": 0, "11:00": 0, "15:00": 0},
        "24": {"09:00": 0, "10:00": 0, "12:00": 0, "18:00": 0}
      }
    }
  };

  int year = DateTime.now().year;
  int month = DateTime.now().month;
  int day = DateTime.now().day;

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }

  bool calendarCheck(Map<String, dynamic> map) {
    if (map.containsKey(year.toString())) {
      if (map[year.toString()].containsKey(month.toString())) {
        if (map[year.toString()][month.toString()]
            .containsKey(day.toString())) {
          return true;
        }
      }
    }
    return false;
  }

  List<Widget> hoursCardsGenerator() {
    print("gün değişti");
    try {
      if (calendarCheck(appointments)) {
        Map temp = (appointments[year.toString()][month.toString()]
            [day.toString()] as Map);

        List sList = saatler;
        temp.keys.forEach((e) {
          sList.remove(e);
        });
        return sList.map((saat) => hourCard(saat)).toList();
      } else {
        return List.generate(
            saatler.length, (index) => hourCard(saatler[index]));
      }
    } catch (e) {
      print("Catched:" + e);
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

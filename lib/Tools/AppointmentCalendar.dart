import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:diyet_ofisim/Settings/AppSettings.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:flutter/material.dart';

typedef DateChangeListener = void Function(
    int year, int month, int day, String hour);

class AppointmentCalendar extends StatefulWidget {
  final DateChangeListener onDateSelected;
  final Map<String, dynamic> calendar;
  const AppointmentCalendar(this.calendar,
      {Key key, @required this.onDateSelected})
      : super(key: key);

  @override
  _AppointmentCalendarState createState() => _AppointmentCalendarState();
}

class _AppointmentCalendarState extends State<AppointmentCalendar> {
  List saatler = AppSettings().appointmentHours;

  String selectedHour;
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
              selectedHour = null;
              year = date.year;
              month = date.month;
              day = date.day;
            });
          },
        ),
        Divider(),
        SizedBox(
          height: PageComponents(context).heightSize(3),
        ),
        Container(
          child: Wrap(children: hoursCardsGenerator()),
        )
      ],
    );
  }

  bool calendarCheck(Map<String, dynamic> map) {
    if (map == null) return false;
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
    Map appointments = widget.calendar;
    try {
      if (calendarCheck(appointments)) {
        Map temp = (appointments[year.toString()][month.toString()]
            [day.toString()] as Map);

        List sList = List.from(saatler);
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

  Widget hourCard(String hour) {
    return InkWell(
      onTap: () {
        widget.onDateSelected(year, month, day, hour);
        setState(() {
          selectedHour = hour;
        });
      },
      child: Card(
        margin: EdgeInsets.all(15),
        color: selectedHour == hour ? Colors.green : Colors.blue,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            hour,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

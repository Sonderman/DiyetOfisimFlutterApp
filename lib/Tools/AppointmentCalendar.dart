import 'package:diyet_ofisim/Settings/AppSettings.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef DateChangeListener = void Function(int year, int month, int day, String hour);

class AppointmentCalendar extends StatefulWidget {
  final DateChangeListener onDateSelected;
  final Map<String, dynamic> calendar;

  const AppointmentCalendar({super.key, required this.onDateSelected, required this.calendar});

  @override
  State<AppointmentCalendar> createState() => _AppointmentCalendarState();
}

class _AppointmentCalendarState extends State<AppointmentCalendar> {
  List saatler = AppSettings().appointmentHours;

  String? selectedHour;
  int year = DateTime.now().year;
  int month = DateTime.now().month;
  int day = DateTime.now().day;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        EasyDateTimeLine(
          initialDate: DateTime.now(),
          locale: "tr_TR",
          onDateChange: (date) {
            setState(() {
              selectedHour = null;
              year = date.year;
              month = date.month;
              day = date.day;
            });
          },
          activeColor: Colors.green[300],
          dayProps: const EasyDayProps(
            activeDayStyle: DayStyle(borderRadius: 32.0),
            inactiveDayStyle: DayStyle(borderRadius: 32.0),
          ),
        ),
        const Divider(),
        SizedBox(height: PageComponents(context).heightSize(3)),
        Wrap(children: hoursCardsGenerator()),
      ],
    );
  }

  bool calendarCheck(Map<String, dynamic> map, String xmonth, String xday) {
    if (map.containsKey(year.toString())) {
      if (map[year.toString()].containsKey(xmonth)) {
        if (map[year.toString()][xmonth].containsKey(xday)) {
          return true;
        }
      }
    }
    return false;
  }

  List<Widget> hoursCardsGenerator() {
    Map<String, dynamic> calendar = widget.calendar;
    String xmonth, xday;
    try {
      xmonth = month.toString();
      xday = day.toString();
      if (month < 10) xmonth = "0$xmonth";
      if (day < 10) xday = "0$xday";
      if (calendarCheck(calendar, xmonth, xday)) {
        Map temp = (calendar[year.toString()][xmonth][xday] as Map);

        List sList = List.from(saatler);
        for (var e in temp.keys) {
          sList.remove(e);
        }
        return sList.map((saat) => hourCard(saat)).toList();
      } else {
        return List.generate(saatler.length, (index) => hourCard(saatler[index]));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
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
        margin: const EdgeInsets.all(15),
        color: selectedHour == hour ? Colors.green[300] : Colors.blue[400],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(hour, style: const TextStyle(color: Colors.white, fontSize: 20)),
        ),
      ),
    );
  }
}

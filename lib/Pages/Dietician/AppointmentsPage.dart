import 'package:diyet_ofisim/Tools/AppointmentCalendar.dart';
import 'package:flutter/material.dart';

class AppointmentsPage extends StatefulWidget {
  AppointmentsPage({Key key}) : super(key: key);

  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  //Text(DateTime.now().weekday.toString()),

  String convertDayToName(int day) {
    //if (day == 0) day = 1;
    Map<int, String> days = {
      0: "Pazartesi",
      1: "Salı",
      2: "Çarşamba",
      3: "Perşembe",
      4: "Cuma",
      5: "Cumartesi",
      6: "Pazar"
    };
    return days[day];
  }

  @override
  Widget build(BuildContext context) {
    /*
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 30,
        itemBuilder: (con, index) {
          return Column(
            children: <Widget>[
              Text(convertDayToName((DateTime.now().weekday + index - 1) % 7)),
              Text((DateTime.now().day + index).toString())
            ],
          );
        });
        */
    return Scaffold(body: AppointmentCalendar());
  }
}

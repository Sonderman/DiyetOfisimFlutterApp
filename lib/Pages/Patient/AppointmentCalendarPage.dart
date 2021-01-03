import 'package:diyet_ofisim/Models/Dietician.dart';
import 'package:diyet_ofisim/Tools/AppointmentCalendar.dart';
import "package:flutter/material.dart";
import 'package:diyet_ofisim/Pages/Patient/ConfirmAppointmentPage.dart';

class AppointmentCalendarPage extends StatefulWidget {
  final Map<String, dynamic> calendar;
  final Dietician dModel;

  const AppointmentCalendarPage({Key key, @required this.calendar, this.dModel})
      : super(key: key);
  @override
  _AppointmentCalendarPageState createState() =>
      _AppointmentCalendarPageState();
}

class _AppointmentCalendarPageState extends State<AppointmentCalendarPage> {
  Color clickColor = Colors.cyan[100];
  Color primaryColor = Color(0xffdfdeff);
  int year, month, day;
  String hour;
  @override
  Widget build(BuildContext context) {
    print("Calendar:" + widget.calendar.toString());
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Randevu Takvimi",
            style: TextStyle(fontSize: 20, fontFamily: "Genel"),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AppointmentCalendar(
              widget.calendar,
              onDateSelected: (y, m, d, h) {
                year = y;
                month = m;
                day = d;
                hour = h;
              },
            ),
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width / 2 - 20,
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ConfirmAppointmentPage(
                              dModel: widget.dModel,
                              year: year,
                              month: month,
                              day: day,
                              hour: hour,
                            )));
                  });
                },
                child: Text(
                  "Randevu Al",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                color: Colors.deepPurpleAccent[100],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ],
        ));
  }
}

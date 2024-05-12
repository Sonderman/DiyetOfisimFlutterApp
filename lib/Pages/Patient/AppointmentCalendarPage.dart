import 'package:diyet_ofisim/Models/Dietician.dart';
import 'package:diyet_ofisim/Tools/AppointmentCalendar.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:diyet_ofisim/Pages/Patient/ConfirmAppointmentPage.dart';

class AppointmentCalendarPage extends StatefulWidget {
  final Map<String, dynamic> calendar;
  final Dietician? dModel;

  const AppointmentCalendarPage(
      {super.key, required this.calendar, this.dModel});

  @override
  State<AppointmentCalendarPage> createState() =>
      _AppointmentCalendarPageState();
}

class _AppointmentCalendarPageState extends State<AppointmentCalendarPage> {
  Color clickColor = Colors.cyan[100]!;
  Color primaryColor = const Color(0xffdfdeff);
  DateTime? date;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("Calendar:${widget.calendar}");
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text(
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
              calendar: widget.calendar,
              onDateSelected: (y, m, d, h) {
                date = DateTime(y, m, d, int.parse(h));
              },
            ),
            SizedBox(
                height: PageComponents(context).heightSize(5),
                width: PageComponents(context).heightSize(30),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ConfirmAppointmentPage(
                                dModel: widget.dModel!,
                                date: date!,
                              )));
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    "Randevu Al",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                )),
          ],
        ));
  }
}

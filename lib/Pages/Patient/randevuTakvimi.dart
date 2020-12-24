
import 'package:diyet_ofisim/Models/Dietician.dart';
import 'package:diyet_ofisim/Tools/AppointmentCalendar.dart';
import "package:flutter/material.dart";
import 'package:diyet_ofisim/Pages/Patient/ConfirmAppointmentPage.dart';

class RandevuTakvimi extends StatefulWidget {
  final Map<String, dynamic> calendar;
  final Dietician dModel;

  const RandevuTakvimi({Key key, @required this.calendar, this.dModel}) : super(key: key);
  @override
  _RandevuTakvimiState createState() => _RandevuTakvimiState();
}

class _RandevuTakvimiState extends State<RandevuTakvimi> {
  final List<String> saatler = [
    "09.00",
    "10.00",
    "11.00",
    "12.00",
    "14.00",
    "15.00",
    "16.00",
    "17.00",
    "18.00",
    "19.00",
    "20.00"
  ];
  final List<String> gunler = [
    DateTime.now().toString(),
    "10.00",
    "11.00",
    "12.00",
    "14.00",
    "15.00",
    "16.00",
    "17.00",
    "18.00",
    "19.00",
    "20.00"
  ];
  Map<String, dynamic> appointments = {
    "2020": {
      "12": {
        "23": {"08:00": true, "10.00": true, "14.00": true, "18.00": true},
        "24": {"09:00": true, "11.00": true, "15.00": true, "19.00": true}
      }
    }
  };

  List<bool> _selected = List.generate(11, (i) => false);
  bool _hasBeenPressed = false;
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

  Widget oneDayWidget({String weekdays, String daysOftheMounth}) {
    return Container(
      width: 110,
      child: Column(
        children: [
          weekDays(weekdays),
          daysOfTheMounth(daysOftheMounth),
          times(),
        ],
      ),
    );
  }

  Widget weekDays(String weeksday) {
    return Container(
      height: 40,
      width: 110,
      color: Colors.grey[50],
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
      child: Center(
        child: Text(
          weeksday,
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget daysOfTheMounth(String day) {
    return Container(
      height: 40,
      width: 110,
      color: Colors.grey[50],
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 0),
      child: Center(
        child: Text(
          day,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget times() {
    return Expanded(
      child: Container(
        width: 110,
        child: ListView.builder(
          itemCount: saatler.length,
          itemBuilder: (BuildContext context, int i) {
            return oneTime(i);
          },
        ),
      ),
    );
  }

  Widget oneTime(int index) {
    return Container(
      height: 40,
      width: 110,
      margin: EdgeInsets.all(10.0),
      child: RaisedButton(
        onPressed: () {
          setState(() {
            _selected[index] = !_selected[index];
          });
        },
        child: Text(
          '${saatler[index]}',
          style: TextStyle(fontSize: 15),
        ),
        color: _selected[index] ? clickColor : primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.5)),
      ),
    );
  }
}

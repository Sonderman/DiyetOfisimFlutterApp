import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MyAppointmentsPage extends StatefulWidget {
  //const name({Key key}) : super(key: key);
  @override
  _MyAppointmentsState createState() => _MyAppointmentsState();
}

class _MyAppointmentsState extends State<MyAppointmentsPage> {
  CalendarController _calendarController;
  Color myColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    super.dispose();
    _calendarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 30),
          color: Colors.deepPurpleAccent[100],
          child: Column(
            children: [
              TableCalendar(
                calendarController: _calendarController,
                initialCalendarFormat: CalendarFormat.week,
                startingDayOfWeek: StartingDayOfWeek.monday,
                formatAnimation: FormatAnimation.slide,
                headerStyle: HeaderStyle(
                    centerHeaderTitle: true,
                    formatButtonVisible: false,
                    titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: "Kalam",
                      fontSize: 18,
                    ),
                    leftChevronIcon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 15,
                    ),
                    rightChevronIcon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 15,
                    )),
                calendarStyle: CalendarStyle(
                  weekendStyle: TextStyle(color: Colors.white),
                  weekdayStyle: TextStyle(color: Colors.white),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle(color: Colors.white),
                  weekdayStyle: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(width: 3, color: myColor),
                    color: myColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  //color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text("10 Aralık 2020",
                            style: TextStyle(
                              color: Colors.grey,
                            )),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          children: [
                            saatler("10.00", "Çiğdem Atak"),
                            saatler("10.00", "Çiğdem Atak"),
                            saatler("10.00", "Çiğdem Atak"),
                            saatler("10.00", "Çiğdem Atak"),
                            saatler("10.00", "Çiğdem Atak"),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget saatler(String time, String name) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 45),
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width * 0.2,
          child: Text(
            time,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            color: Color(0xffdfdeff),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      color: Colors.deepPurpleAccent[700],
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Divider(),
                Container(
                  child: Icon(
                    Icons.message_rounded,
                    color: Colors.deepPurpleAccent[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

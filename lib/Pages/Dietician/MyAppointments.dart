import 'package:dash_chat/dash_chat.dart';
import 'package:diyet_ofisim/Models/Appointment.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Tools/Message.dart';
import 'package:diyet_ofisim/Tools/NavigationManager.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MyAppointmentsPage extends StatefulWidget {
  @override
  _MyAppointmentsState createState() => _MyAppointmentsState();
}

class _MyAppointmentsState extends State<MyAppointmentsPage> {
  CalendarController _calendarController;
  Color myColor = Colors.white;
  DateTime selectedDate = DateTime.now();

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
    UserService userService = locator<UserService>();
    return Scaffold(
        body: StreamBuilder(
            stream: userService.getMyCalendarSnapshot(),
            builder: (context, AsyncSnapshot<Event> snap) {
              if (!snap.hasData) {
                return PageComponents(context)
                    .loadingOverlay(backgroundColor: Colors.white);
              } else {
                Map<String, dynamic> calendar =
                    Map<String, dynamic>.from(snap.data.snapshot.value);

                return Container(
                  padding: EdgeInsets.only(top: 30),
                  color: Colors.deepPurpleAccent[100],
                  child: Column(
                    children: [
                      TableCalendar(
                        locale: "tr",
                        calendarController: _calendarController,
                        initialCalendarFormat: CalendarFormat.week,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        formatAnimation: FormatAnimation.slide,
                        onDaySelected: (date, _, __) {
                          setState(() {
                            selectedDate = date;
                          });
                        },
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
                          child: ListView(children: [
                            Text(
                                selectedDate.day.toString() +
                                    " " +
                                    DateFormat("MMMM", "tr")
                                        .format(selectedDate) +
                                    " " +
                                    selectedDate.year.toString(),
                                style: TextStyle(
                                  color: Colors.grey,
                                )),
                            SizedBox(
                              height: 15,
                            ),
                            appointmentSection(calendar),
                          ]),
                        ),
                      ),
                    ],
                  ),
                );
              }
            }));
  }

  bool calendarCheck(Map<String, dynamic> map) {
    if (map == null) return false;
    if (map.containsKey(selectedDate.year.toString())) {
      if (map[selectedDate.year.toString()]
          .containsKey(selectedDate.month.toString())) {
        if (map[selectedDate.year.toString()][selectedDate.month.toString()]
            .containsKey(selectedDate.day.toString())) {
          return true;
        }
      }
    }
    return false;
  }

  Widget appointmentSection(Map calendar) {
    if (calendarCheck(calendar)) {
      Map apMap = calendar[selectedDate.year.toString()]
          [selectedDate.month.toString()][selectedDate.day.toString()];
      List apList = apMap.values.toList();
      List apKList = apMap.keys.toList();
      return Column(
        children: List.generate(
            apMap.length,
            (index) => saatler(
                Map<String, dynamic>.from(apList[index]), apKList[index])),
      );
    } else
      return Text("Seçilen günle ilişkili randevu bulunmuyor");
  }

  Widget saatler(Map<String, dynamic> a, String hour) {
    Appointment ap = Appointment();
    ap.parseMap(a);
    ap.day = selectedDate.day;
    ap.year = selectedDate.year;
    ap.month = selectedDate.month;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 45),
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width * 0.2,
          child: Text(
            hour,
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
                  ap.name,
                  style: TextStyle(
                      color: Colors.deepPurpleAccent[700],
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Divider(),
                RaisedButton(
                  onPressed: () async {
                    NavigationManager(context)
                        .setBottomNavIndex(1, reFresh: false);
                    await locator<UserService>()
                        .findUserByID(ap.pID)
                        .then((data) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  Message(ap.pID, data['Name'])));
                    });
                  },
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

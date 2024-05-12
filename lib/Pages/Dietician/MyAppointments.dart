import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diyet_ofisim/Models/Appointment.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Tools/Message.dart';
import 'package:diyet_ofisim/Tools/NavigationManager.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MyAppointmentsPage extends StatefulWidget {
  const MyAppointmentsPage({super.key});

  @override
  State<MyAppointmentsPage> createState() => _MyAppointmentsState();
}

class _MyAppointmentsState extends State<MyAppointmentsPage> {
  Color myColor = Colors.white;
  DateTime selectedDate = DateTime.now();
  UserService userService = locator<UserService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: userService.getMyCalendarSnapshot(),
            builder: (context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snap) {
              if (!snap.hasData) {
                return PageComponents(context)
                    .loadingOverlay(backgroundColor: Colors.white);
              } else {
                late Map<String, dynamic> calendar;
                if (snap.data!.data() != null) {
                  calendar = snap.data!.data()!;
                }

                return Container(
                  padding: const EdgeInsets.only(top: 30),
                  color: Colors.deepPurpleAccent[100],
                  child: Column(
                    children: [
                      TableCalendar(
                        focusedDay: DateTime.now(),
                        firstDay: DateTime(DateTime.now().year - 1),
                        lastDay: DateTime(DateTime.now().year + 1),
                        locale: "tr",
                        calendarFormat: CalendarFormat.week,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        onDaySelected: (
                          selected,
                          focused,
                        ) {
                          setState(() {
                            selectedDate = selected;
                          });
                        },
                        headerStyle: const HeaderStyle(
                            titleCentered: true,
                            formatButtonVisible: false,
                            titleTextStyle: TextStyle(
                              color: Colors.white,
                              fontFamily: "Jom",
                              fontSize: 50,
                            ),
                            leftChevronIcon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 25,
                            ),
                            rightChevronIcon: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 25,
                            )),
                        calendarStyle: CalendarStyle(
                            weekendTextStyle: const TextStyle(
                              color: Colors.white,
                            ),
                            todayTextStyle:
                                TextStyle(color: Colors.purple[800])),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekendStyle: TextStyle(
                              color: Colors.purple[800],
                              fontSize: 20,
                              fontFamily: "Kavom",
                              fontWeight: FontWeight.bold),
                          weekdayStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: "Kavom",
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: PageComponents(context).widthSize(2),
                      ),
                      Expanded(
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 5, color: myColor),
                            color: myColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListView(children: [
                            Center(
                              child: Text(
                                  "${"${selectedDate.day} ${DateFormat("MMMM", "tr").format(selectedDate)}"} ${selectedDate.year}",
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 17)),
                            ),
                            SizedBox(
                              height: PageComponents(context).widthSize(3),
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

  bool calendarCheck(Map<String, dynamic> map, String month, String day) {
    if (map.containsKey(selectedDate.year.toString())) {
      if (map[selectedDate.year.toString()].containsKey(month)) {
        if (map[selectedDate.year.toString()][month].containsKey(day)) {
          return true;
        }
      }
    }
    return false;
  }

  Widget appointmentSection(Map<String, dynamic> calendar) {
    String month, day;
    month = selectedDate.month.toString();
    day = selectedDate.day.toString();
    if (selectedDate.month < 10) month = "0$month";
    if (selectedDate.day < 10) day = "0$day";
    if (calendarCheck(calendar, month, day)) {
      Map apMap = calendar[selectedDate.year.toString()][month][day];
      List apList = apMap.values.toList();
      List apKList = apMap.keys.toList();
      return Center(
        child: Column(
          children: List.generate(
              apMap.length,
              (index) => saatler(
                    Map<String, dynamic>.from(apList[index]),
                    apKList[index],
                  )),
        ),
      );
    } else {
      return const Center(
          child: Text("Seçilen günle ilişkili randevu bulunmuyor"));
    }
  }

  bool checkAppointment(Appointment a) {
    DateTime currentTime = DateTime.now();

    if (a.date.month == currentTime.month && a.date.day == currentTime.day) {
      if (((a.date.hour) == currentTime.hour && currentTime.minute < 10) ||
          ((a.date.hour) == currentTime.hour - 1 && currentTime.minute > 50)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Widget saatler(Map<String, dynamic> a, String hour) {
    Appointment ap = Appointment();
    ap.parseMap(a);
    ap.date = selectedDate;

    return Row(
      //crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(30),
            width: PageComponents(context).widthSize(25),
            height: PageComponents(context).widthSize(19),
            child: Text(
              hour,
              style: TextStyle(
                  color: Colors.purple[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
              textAlign: TextAlign.right,
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: PageComponents(context).widthSize(25),
            height: PageComponents(context).widthSize(19),
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[50]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(children: [
                  Text(
                    "${ap.name}  ${ap.surname}",
                    style: const TextStyle(fontSize: 17),
                  ),
                  SizedBox(
                    height: PageComponents(context).widthSize(3),
                  ),
                  (ap.status == 0
                      ? ap.pReady
                          ? Text(
                              "  Hazır".toUpperCase(),
                              style: TextStyle(
                                  color: Colors.yellow[600], fontSize: 15),
                            )
                          : Text(
                              "  Hasta Bekleniyor".toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 15),
                            )
                      : ap.status == 1
                          ? Text(
                              "  Randevu Tamamlandı".toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.blue, fontSize: 15),
                            )
                          : Text(
                              "  Randevu iptal edildi".toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 15),
                            )),
                ]),
                Visibility(
                  visible: checkAppointment(ap) && ap.status == 0,
                  child: ElevatedButton(
                    onPressed: ap.pReady && ap.status == 0
                        ? () async {
                            await userService
                                .startAppointment(ap)
                                .then((value) async {
                              if (value) {
                                NavigationManager(context)
                                    .setBottomNavIndex(1, reFresh: false);
                                final userData = await locator<UserService>()
                                    .findUserByID(ap.pID);
                                if (context.mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Message(
                                        otherUserID: ap.pID,
                                        otherUserName: userData!['Name'],
                                        aModel: ap,
                                      ),
                                    ),
                                  );
                                }
                              }
                            });
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                        // Add your preferred styles here (optional)
                        ),
                    child: Text(
                      "Randevuyu başlat".toUpperCase(),
                    ),
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

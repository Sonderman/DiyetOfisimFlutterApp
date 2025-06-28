import 'dart:async';
import 'package:diyet_ofisim/Models/Appointment.dart';
import 'package:diyet_ofisim/Models/Dietician.dart';
import 'package:diyet_ofisim/Pages/Dietician/DieticianProfilePage.dart';
import 'package:diyet_ofisim/Pages/Patient/AppointmentDetail.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Tools/Dialogs.dart';
import 'package:diyet_ofisim/Tools/NewMessage.dart';
import 'package:diyet_ofisim/Tools/NavigationManager.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyCalendarPage extends StatefulWidget {
  const MyCalendarPage({super.key});

  @override
  State<MyCalendarPage> createState() => _MyCalendarPageState();
}

class _MyCalendarPageState extends State<MyCalendarPage> {
  UserService userService = locator<UserService>();
  bool readyToggle = false;
  StreamSubscription? aStream;

  @override
  void dispose() {
    aStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Randevularım",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 24),
        ),
      ),
      body: DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(15),
              child: TabBar(
                indicatorColor: Colors.transparent,
                tabs: [
                  butonlar("Planlanmış", 0),
                  butonlar("Geçmiş", 1),
                  butonlar("İptal Edilmiş", 2),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder(
                future: userService.getMyAppointments(),
                builder: (c, snap) {
                  if (snap.connectionState == ConnectionState.done) {
                    return TabBarView(
                      children: [
                        ListView(children: appointmentItems(snap.data!, 0)),
                        ListView(children: appointmentItems(snap.data!, 1)),
                        ListView(children: appointmentItems(snap.data!, 2)),
                      ],
                    );
                  } else {
                    return PageComponents(context).loadingCustomOverlay();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget butonlar(String butonText, int pageIndex) {
    return Container(
      height: PageComponents(context).widthSize(10),
      width: PageComponents(context).widthSize(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.deepPurpleAccent.shade100,
      ),
      child: Center(
        child: Text(butonText, style: const TextStyle(fontSize: 15, color: Colors.white)),
      ),
    );
  }

  bool checkAppointment(Appointment a) {
    DateTime currentTime = DateTime.now();

    if (a.date.month == currentTime.month && a.date.day == currentTime.day) {
      if (a.date.hour == currentTime.hour && currentTime.minute < 10 ||
          a.date.hour == currentTime.hour - 1 && currentTime.minute > 50) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  List<Widget> appointmentItems(List<List<dynamic>> list, int status) {
    List<Widget> widgets = [];
    List<Appointment> alist = [];
    List<Dietician> dlist = [];
    for (var i in list) {
      Appointment a = i[1];
      if (a.status == status) {
        dlist.add(i[0]);
        alist.add(a);
      }
    }

    for (int i = 0; i < alist.length; i++) {
      DateTime date = DateTime(alist[i].date.year, alist[i].date.month, alist[i].date.day);

      widgets.add(
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[100]!),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 2),
          margin: const EdgeInsets.only(top: 10, right: 30, left: 30, bottom: 10),
          height: PageComponents(context).widthSize(30),
          width: PageComponents(context).widthSize(10),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.date_range, size: 22, color: Colors.deepPurpleAccent[100]),
                        SizedBox(width: PageComponents(context).widthSize(1.5)),
                        Text(
                          "${alist[i].date.day}.${alist[i].date.month}.${alist[i].date.year} ${DateFormat("EEEE", "tr").format(date)}",
                          style: const TextStyle(fontSize: 15.8, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: PageComponents(context).widthSize(2)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.timer, size: 22, color: Colors.deepPurpleAccent[100]),
                      SizedBox(width: PageComponents(context).widthSize(1.5)),
                      Text(
                        "${alist[i].date.hour}:${alist[i].date.minute}",
                        style: const TextStyle(fontSize: 15.8, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: PageComponents(context).heightSize(1.8)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DieticianProfilePage(userID: dlist[i].id),
                          ),
                        );
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        height: PageComponents(context).heightSize(10),
                        width: PageComponents(context).heightSize(10),
                        decoration: BoxDecoration(
                          //borderRadius: BorderRadius.circular(15),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: ExtendedNetworkImageProvider(
                              dlist[i].profilePhotoUrl,
                              cache: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${dlist[i].name} ${dlist[i].surname}",
                          style: const TextStyle(fontSize: 17),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: PageComponents(context).widthSize(2)),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AppointmentDetail(dModel: dlist[i], aModel: alist[i]),
                                  ),
                                )
                                .then((re) {
                                  if (re != null) setState(() {});
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                          child: Text(
                            "Randevu Detayları",
                            style: TextStyle(color: Colors.deepPurpleAccent.shade100, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: checkAppointment(alist[i]) && alist[i].status == 0,
                    child: ElevatedButton(
                      onPressed: () {
                        userService.readyForAppointmentToggle(alist[i], !readyToggle).then((
                          stream,
                        ) {
                          if (aStream == null) {
                            aStream = stream!.listen((data) async {
                              Appointment ap = Appointment();
                              ap.parseMap(data.data()!);

                              if (ap.dReady == true && ap.pReady == true) {
                                NavigationManager(context).setBottomNavIndex(1, reFresh: false);
                                await locator<UserService>().findUserByID(ap.dID).then((data) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => NewMessage(
                                        otherUserID: ap.dID,
                                        otherUserName: data!['Name'],
                                        aModel: ap,
                                      ),
                                    ),
                                  );
                                });
                              }
                            });
                            setState(() {
                              readyToggle = !readyToggle;
                            });
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(4.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                      ),
                      child: Text(
                        "Hazırım",
                        style: TextStyle(color: Colors.deepPurpleAccent.shade100, fontSize: 15),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: alist[i].status == 0,
                    child: SizedBox(
                      width: PageComponents(context).widthSize(5),
                      height: PageComponents(context).widthSize(5),
                      child: MaterialButton(
                        onPressed: () {
                          appointmentCancelAsking(context, alist[i]).then((value) {
                            if (value) {
                              setState(() {});
                              if (kDebugMode) {
                                print("Randevu silindi");
                              }
                            }
                          });
                        },
                        child: Center(
                          child: Text(
                            "x",
                            style: TextStyle(fontSize: 20, color: Colors.redAccent[100]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return widgets;
  }
}

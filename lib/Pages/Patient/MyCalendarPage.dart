import 'dart:async';
import 'package:dash_chat/dash_chat.dart';
import 'package:diyet_ofisim/Models/Appointment.dart';
import 'package:diyet_ofisim/Models/Dietician.dart';
import 'package:diyet_ofisim/Pages/Dietician/DieticianProfilePage.dart';
import 'package:diyet_ofisim/Pages/Patient/AppointmentDetail.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Tools/Dialogs.dart';
import 'package:diyet_ofisim/Tools/Message.dart';
import 'package:diyet_ofisim/Tools/NavigationManager.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class MyCalendarPage extends StatefulWidget {
  MyCalendarPage({Key key}) : super(key: key);

  @override
  _MyCalendarPageState createState() => _MyCalendarPageState();
}

class _MyCalendarPageState extends State<MyCalendarPage> {
  UserService userService = locator<UserService>();
  bool readyToggle = false;
  StreamSubscription aStream;

  @override
  void dispose() {
    if (aStream != null) aStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Randevularım",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 24),
        ),
      ),
      body: DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Container(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(15),
                  child: TabBar(
                    indicatorColor: Colors.transparent,
                    tabs: [
                      butonlar("Planlanmış", 0),
                      butonlar("Geçmiş", 1),
                      butonlar("İptal Edilmiş", 2),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: FutureBuilder(
                    future: userService.getMyAppointments(),
                    builder: (c, snap) {
                      if (snap.connectionState == ConnectionState.done)
                        return TabBarView(
                          children: [
                            Container(
                              child: ListView(
                                children: appointmentItems(snap.data, 0),
                              ),
                            ),
                            Container(
                              child: ListView(
                                children: appointmentItems(snap.data, 1),
                              ),
                            ),
                            Container(
                              child: ListView(
                                children: appointmentItems(snap.data, 2),
                              ),
                            )
                          ],
                        );
                      else
                        return PageComponents(context).loadingCustomOverlay();
                    },
                  ),
                ),
              ]),
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
        child: Text(
          butonText,
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
    );
  }

  bool checkAppointment(Appointment a) {
    DateTime currentTime = DateTime.now();
    List time;
    time = a.hour.split(":");
    if (a.month == currentTime.month && a.day == currentTime.day) {
      if ((int.tryParse(time[0]) == currentTime.hour &&
              currentTime.minute < 10) ||
          (int.tryParse(time[0]) == currentTime.hour - 1 &&
              currentTime.minute > 50))
        return true;
      else
        return false;
    } else
      return false;
  }

  List<Widget> appointmentItems(List<List<dynamic>> list, int status) {
    List<Widget> widgets = [];
    List<Appointment> alist = [];
    List<Dietician> dlist = [];
    list.forEach((i) {
      Appointment a = i[1];
      if (a.status == status) {
        dlist.add(i[0]);
        alist.add(a);
      }
    });

    for (int i = 0; i < alist.length; i++) {
      DateTime date = DateTime(alist[i].year, alist[i].month, alist[i].day);

      widgets.add(Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[100]),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 2),
        margin: EdgeInsets.only(top: 10, right: 30, left: 30, bottom: 10),
        height: PageComponents(context).widthSize(30),
        width: PageComponents(context).widthSize(10),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.date_range,
                        size: 22,
                        color: Colors.deepPurpleAccent[100],
                      ),
                      SizedBox(
                        width: PageComponents(context).widthSize(1.5),
                      ),
                      Text(
                        alist[i].day.toString() +
                            "." +
                            alist[i].month.toString() +
                            "." +
                            alist[i].year.toString() +
                            " " +
                            DateFormat("EEEE", "tr").format(date),
                        style: TextStyle(fontSize: 15.8, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: PageComponents(context).widthSize(2),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.timer,
                        size: 22,
                        color: Colors.deepPurpleAccent[100],
                      ),
                      SizedBox(
                        width: PageComponents(context).widthSize(1.5),
                      ),
                      Text(
                        alist[i].hour,
                        style: TextStyle(fontSize: 15.8, color: Colors.grey),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: PageComponents(context).heightSize(1.8),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DieticianProfilePage(
                                userID: dlist[i].id,
                              )));
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      height: PageComponents(context).heightSize(10),
                      width: PageComponents(context).heightSize(10),
                      decoration: new BoxDecoration(
                        //borderRadius: BorderRadius.circular(15),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: ExtendedNetworkImageProvider(
                              dlist[i].profilePhotoUrl,
                              cache: true),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dlist[i].name + " " + dlist[i].surname,
                        style: TextStyle(fontSize: 17),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: PageComponents(context).widthSize(2),
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => AppointmentDetail(
                                        dModel: dlist[i],
                                        aModel: alist[i],
                                      )))
                              .then((re) {
                            if (re != null) setState(() {});
                          });
                        },
                        elevation: 1,
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Randevu Detayları",
                          style: TextStyle(
                              color: Colors.deepPurpleAccent.shade100,
                              fontSize: 15),
                        ),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: checkAppointment(alist[i]) && alist[i].status == 0,
                  child: RaisedButton(
                    onPressed: () {
                      userService
                          .readyForAppointmentToggle(alist[i], !readyToggle)
                          .then((stream) {
                        if (aStream == null)
                          aStream = stream.listen((data) async {
                            Appointment ap = Appointment();
                            ap.parseMap(
                                Map<String, dynamic>.from(data.snapshot.value));
                            if (ap.dReady == true && ap.pReady == true) {
                              NavigationManager(context)
                                  .setBottomNavIndex(1, reFresh: false);
                              await locator<UserService>()
                                  .findUserByID(ap.dID)
                                  .then((data) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Message(ap.dID, data['Name'])));
                              });
                            }
                          });
                        setState(() {
                          readyToggle = !readyToggle;
                        });
                      });
                    },
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "Hazırım",
                      style: TextStyle(
                          color: Colors.deepPurpleAccent.shade100,
                          fontSize: 15),
                    ),
                    color: readyToggle ? Colors.green[300] : Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
                Visibility(
                  visible: alist[i].status == 0,
                  child: Container(
                    width: PageComponents(context).widthSize(5),
                    height: PageComponents(context).widthSize(5),
                    child: MaterialButton(
                      onPressed: () {
                        appointmentCancelAsking(context, alist[i])
                            .then((value) {
                          if (value) {
                            setState(() {});
                            print("Randevu silindi");
                          }
                        });
                      },
                      child: Center(
                        child: Text(
                          "x",
                          style: TextStyle(
                              fontSize: 20, color: Colors.redAccent[100]),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ));
    }

    return widgets;
  }
}

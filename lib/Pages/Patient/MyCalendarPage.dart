import 'package:dash_chat/dash_chat.dart';
import 'package:diyet_ofisim/Models/Appointment.dart';
import 'package:diyet_ofisim/Models/Dietician.dart';
import 'package:diyet_ofisim/Pages/Dietician/DieticianProfilePage.dart';
import 'package:diyet_ofisim/Pages/Patient/AppointmentDetail.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Tools/Dialogs.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Randevularım",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 25),
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
      height: 50,
      width: 130,
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
        height: 140,
        width: MediaQuery.of(context).size.width - 150,
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
                        width: 15,
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
                  width: 20,
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
                        width: 15,
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
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 10, bottom: 5, right: 10, top: 10),
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.5),
                    ),
                    child: ClipOval(
                      child: FadeInImage(
                        image: ExtendedNetworkImageProvider(
                            dlist[i].profilePhotoUrl),
                        placeholder: ExtendedAssetImageProvider(
                            "assets/photo/nutri.jpg"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dlist[i].name,
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.center,
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
                        padding: const EdgeInsets.all(4.0),
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
                  visible: alist[i].status == 0,
                  child: Container(
                    width: 50,
                    height: 50,
                    margin: EdgeInsets.only(right: 0, left: 110, bottom: 20),
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
                      child: Text(
                        "x",
                        style: TextStyle(
                            fontSize: 25, color: Colors.redAccent[100]),
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

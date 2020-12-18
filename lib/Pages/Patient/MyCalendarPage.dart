import 'package:diyet_ofisim/Pages/Dietician/DieticianProfilePage.dart';
import 'package:diyet_ofisim/Pages/Patient/AppointmentDetail.dart';
import 'package:diyet_ofisim/Tools/Dialogs.dart';
import 'package:flutter/material.dart';

class MyCalendarPage extends StatefulWidget {
  MyCalendarPage({Key key}) : super(key: key);

  @override
  _MyCalendarPageState createState() => _MyCalendarPageState();
}

class _MyCalendarPageState extends State<MyCalendarPage> {
  var myController =
      PageController(initialPage: 0, keepPage: true, viewportFraction: 1);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Randevular",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 25),
        ),
      ),
      body: Container(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
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
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  reverse: false,
                  controller: myController,
                  pageSnapping: true,
                  onPageChanged: (index) {
                    setState(() {
                      debugPrint("Gelen index $index");
                    });
                  },
                  children: [
                    Container(
                      child: ListView(
                        children: [
                          planlanmisRandevular("Elif Aras"),
                          planlanmisRandevular("Çiğdem Atak"),
                          planlanmisRandevular("Zeynep Ünal"),
                          planlanmisRandevular("Şevval Sakin"),
                          planlanmisRandevular("Şevval Sakin"),
                        ],
                      ),
                    ),
                    Container(
                      child: ListView(
                        children: [],
                      ),
                    ),
                    Container(
                      child: ListView(
                        children: [],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }

  Widget butonlar(String butonText, int pageIndex) {
    Color buttonColor = Colors.white;

    return InkWell(
      onTap: () {
        setState(() {});
      },
      child: Container(
        height: 50,
        width: 130,
        child: SizedBox(
          width: double.infinity,
          child: RaisedButton(
            elevation: 3,
            color: buttonColor,
            highlightColor: buttonColor,
            padding: const EdgeInsets.all(1.0),
            child: Text(
              butonText,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
            onPressed: () {
              setState(() {
                buttonColor = Colors.deepPurpleAccent.shade100;
                myController.jumpToPage(pageIndex);
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget planlanmisRandevular(String diyetisyenAdi) {
    return Container(
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
                      "12.12.2020 , Pazartesi",
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
                      "12.00",
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
                              userID: "UAqBr09g9IToUF5JX1KjN5GYhMQ2",
                            )));
                  });
                },
                child: Container(
                  margin:
                      EdgeInsets.only(left: 10, bottom: 5, right: 10, top: 10),
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.5),
                    image: DecorationImage(
                        image: AssetImage("assets/photo/nutri.jpg"),
                        fit: BoxFit.cover),
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
                      diyetisyenAdi,
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    RaisedButton(
                      onPressed: () {
                        setState(() {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AppointmentDetail(
                                    diyetisyenAdi: diyetisyenAdi,
                                    imgPath: "assets/photo/nutri.jpg",
                                  )));
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
              Container(
                width: 50,
                height: 50,
                margin: EdgeInsets.only(right: 0, left: 110, bottom: 20),
                child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      appointmentCancelAsking(context).then((value) {
                        if (value)
                          print("Evet basıldı");
                        else
                          print("vazgeç basıldı");
                      });
                    });
                  },
                  child: Text(
                    "x",
                    style:
                        TextStyle(fontSize: 25, color: Colors.redAccent[100]),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

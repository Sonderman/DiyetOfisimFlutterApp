import 'package:diyet_ofisim/Models/Dietician.dart';
import 'package:diyet_ofisim/Pages/Dietician/DieticianProfilePage.dart';
import 'package:diyet_ofisim/Pages/Patient/AppointmentCalendarPage.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Settings/AppSettings.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:extended_image/extended_image.dart';
import "package:flutter/material.dart";

class DieticianListPage extends StatefulWidget {
  final List<Diseases> results;

  const DieticianListPage({Key key, this.results}) : super(key: key);

  @override
  _DieticianListPageState createState() => _DieticianListPageState();
}

class _DieticianListPageState extends State<DieticianListPage> {
  UserService userService = locator<UserService>();
  @override
  Widget build(BuildContext context) {
    // print(widget.results);
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey[350],
                  Colors.grey[200],
                  Colors.white,
                  /* Colors.deepPurple[200],
                Colors.deepPurple[50],
                Colors.white*/
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        child: Icon(
                          Icons.arrow_back_ios_sharp,
                          color: Colors.white,
                          size: 30,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:
                              Colors.deepPurpleAccent.shade100.withOpacity(0.7),
                        ),
                        margin: EdgeInsets.all(20),
                        alignment: Alignment.center,
                      ),
                    ),
                    SizedBox(
                      width: 70,
                    ),
                    Container(
                      child: Text(
                        "Diyetisyenler",
                        style: TextStyle(
                            fontSize: 25,
                            fontFamily: "Kalam",
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                Center(
                  child: Container(
                      width: MediaQuery.of(context).size.width / 2 + 200,
                      child: TextField(
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.search,
                          ),
                          contentPadding:
                              const EdgeInsets.only(top: 10, left: 30),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.deepPurpleAccent.shade100),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: "Diyetisyen Adı Arayınız",
                          hintStyle: TextStyle(
                              fontFamily: "Genel",
                              fontWeight: FontWeight.w200,
                              color: Colors.black26),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      )),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: userService.findDieticianbyResults(widget.results),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        //print(snapshot.data);
                        return ListView(
                          children: searchList(snapshot.data),
                        );
                      } else
                        return Center(
                            child:
                                PageComponents(context).loadingCustomOverlay());
                    },
                  ),
                ),
              ],
            )));
  }

  List<Widget> searchList(List<Dietician> dmodels) {
    List<Widget> temp = [];
    dmodels.forEach((model) {
      temp.add(Container(
        margin: EdgeInsets.only(top: 5, bottom: 5, left: 12, right: 12),
        padding: EdgeInsets.all(10),
        height: 135,
        width: MediaQuery.of(context).size.width - 90,
        child: Material(
          elevation: 0,
          borderRadius: BorderRadius.circular(10),
          color: Colors.white.withOpacity(0.5),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DieticianProfilePage(
                            userID: model.id,
                          )));
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: FadeInImage(
                    image: ExtendedNetworkImageProvider(model.profilePhotoUrl),
                    placeholder:
                        ExtendedAssetImageProvider("assets/photo/nutri.jpg"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 15,
                      bottom: 10,
                    ),
                    child: Text(
                      model.name + " " + model.surname,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Text(
                    "Diyetisyen",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.grey),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 30,
                    width: 180,
                    child: MaterialButton(
                      elevation: 4,
                      color: Colors.white,
                      textColor: Colors.deepPurpleAccent.shade100,
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        "Randevu Al",
                        style: TextStyle(fontSize: 14),
                      ),
                      onPressed: () {
                        userService
                            .getAppointmentCalendar(model.id)
                            .then((map) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AppointmentCalendarPage(
                                    calendar: map,
                                    dModel: model,
                                  )));
                        });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ));
    });
    return temp;
  }
}

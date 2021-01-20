import 'package:diyet_ofisim/Models/Patient.dart';
import 'package:diyet_ofisim/Pages/Patient/QuestionsPage.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:flutter/material.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';

import '../../locator.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Patient usermodel = locator<UserService>().userModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: new DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.25), BlendMode.dstATop),
            image: AssetImage(
              'assets/photo/mor1.jpg',
            ),
          ),
        ),
        child: ListView(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20, top: 20),
                        height: PageComponents(context).widthSize(10),
                        child: Image.asset("assets/icons/logo1.png",
                            color: Colors.deepPurpleAccent[100]),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, top: 20),
                        child: MaterialButton(
                          onPressed: () {
                            //locator<UserService>().createAppointment(null);

                            print("Test Butonu:)");
                          },
                          child: Icon(
                            Icons.notifications,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: PageComponents(context).heightSize(5),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 20),
                    child: Text(
                      "Merhaba" + "  " + usermodel.name + ",",
                      style: TextStyle(
                        color: Colors.deepPurpleAccent[100],
                        fontFamily: "Jom",
                        fontSize: 70,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      "Diyet  Ofisim'e  Hoşgeldin \nSana  Nasıl  Yardımcı\nOlabiliriz ?",
                      style: TextStyle(
                        fontFamily: "Jom",
                        fontSize: 50,
                        wordSpacing: -0.5,
                        color: Colors.black,
                        //fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: PageComponents(context).heightSize(27),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22, bottom: 0),
              child: Text(
                "Diyetisyeniniz  ile  Evinizden  Görüşün",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 30,
                  fontFamily: "Jom",
                  backgroundColor: Colors.white30,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  //NavigationManager(context).pushPage(QuestionsPageNew());
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => QuestionsPage()));
                });
              },
              child: Hero(
                tag: 1,
                child: Container(
                  height: PageComponents(context).heightSize(15),
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Sizi Diyetisyeninize Yönlendirmemiz \nİçin Lütfen Bir Kaç Soruyu \nYanıtlayın . . .",
                          style: TextStyle(
                              fontFamily: "Jom",
                              fontSize: 35,
                              color: Colors.black54),
                        ),
                        Container(
                          height: PageComponents(context).heightSize(50),
                          width: PageComponents(context).widthSize(15),
                          child: Icon(
                            Icons.arrow_right_alt_rounded,
                            size: 50,
                            color: Colors.black87,
                          ),
                        ),
                        /*Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/photo/diyetisyen.png"),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                        ),*/
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

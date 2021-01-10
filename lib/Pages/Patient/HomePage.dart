import 'package:diyet_ofisim/Pages/Patient/QuestionsPageNew.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: new DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.3), BlendMode.dstATop),
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
                        height: 50,
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
                    height: 160,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 20, top: 20),
                    child: Text(
                      "Merhaba",
                      style: TextStyle(
                          color: Colors.deepPurpleAccent[100],
                          fontFamily: "Genel",
                          fontSize: 33,
                          fontWeight: FontWeight.w900),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 20, top: 10),
                    child: Text(
                      "Diyet  Ofisim'e  Hoşgeldiniz \nSize  Nasıl  Yardımcı  Olabiliriz ?",
                      style: TextStyle(
                        fontFamily: "Genel",
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 235,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 2),
              child: Text(
                "Diyetisyeniniz ile Evinizden Görüşün",
                style: TextStyle(color: Colors.black38, fontSize: 20),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  //NavigationManager(context).pushPage(QuestionsPageNew());
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              QuestionsPageNew()));
                });
              },
              child: Hero(
                tag: 1,
                child: Container(
                  height: 130,
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Material(
                    color: Colors.deepPurpleAccent[100],
                    borderRadius: BorderRadius.circular(20),
                    elevation: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Sizi Diyetisyeninize Yönlendirmemiz \nİçin Lütfen Bir Kaç Soruyu \nYanıtlayın . . .",
                          style: TextStyle(
                              fontFamily: "Genel",
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Container(
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
                        ),
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

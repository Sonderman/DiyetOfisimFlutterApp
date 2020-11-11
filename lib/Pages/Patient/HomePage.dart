import 'package:diyet_ofisim/Pages/Patient/QuestionsPage.dart';
import 'package:diyet_ofisim/Tools/NavigationManager.dart';
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
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            MaterialButton(
              onPressed: () {
                NavigationManager(context).pushPage(QuestionsPage());
              },
              color: Colors.blue,
              child: Text("Rahatsızlığıma göre bul"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:diyet_ofisim/Pages/LoginPage.dart';
import 'package:diyet_ofisim/Services/AuthService.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:flutter/material.dart';

class DieticianListPage extends StatefulWidget {
  DieticianListPage({Key key}) : super(key: key);

  @override
  _DieticianListPageState createState() => _DieticianListPageState();
}

class _DieticianListPageState extends State<DieticianListPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            MaterialButton(
              color: Colors.red,
              onPressed: () {
                locator<AuthService>().signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()));
              },
              child: Text("Çıkış"),
            )
          ],
        ),
      ),
    );
  }
}

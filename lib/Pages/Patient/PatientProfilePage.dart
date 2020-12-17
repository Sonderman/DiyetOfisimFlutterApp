import 'package:diyet_ofisim/Models/Patient.dart';
import 'package:diyet_ofisim/Pages/LoginPage.dart';
import 'package:diyet_ofisim/Services/AuthService.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Tools/Dialogs.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class PatientProfilePage extends StatefulWidget {
  PatientProfilePage({Key key}) : super(key: key);

  @override
  _PatientProfilePageState createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends State<PatientProfilePage> {
  Patient usermodel = locator<UserService>().userModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profilim"),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              color: Colors.blue,
              iconSize: 30,
              icon: Icon(Icons.exit_to_app_outlined),
              onPressed: () {
                locator<AuthService>().signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()));
              })
        ],
      ),
      body: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(10),
            trailing: IconButton(
              onPressed: () {
                updateUserInfoDialog(context).then((value) {
                  if (value != null) if (value) {
                    setState(() {
                      print("Kaydedildi");
                    });
                  } else
                    print("İptal edildi");
                });
              },
              icon: Icon(Icons.mode_edit),
            ),
            leading: FadeInImage(
              image: ExtendedNetworkImageProvider(usermodel.profilePhotoUrl),
              placeholder: ExtendedNetworkImageProvider(
                  "https://cdn4.iconfinder.com/data/icons/small-n-flat/24/user-alt-512.png"),
              height: 100,
              fit: BoxFit.contain,
            ),
            title: Text(usermodel.name + " " + usermodel.surname),
            subtitle: Text("Diyetisyen"),
          ),
        ],
      ),
    );
  }
}

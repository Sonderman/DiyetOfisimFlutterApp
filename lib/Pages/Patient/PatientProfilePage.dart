import 'package:diyet_ofisim/Models/Patient.dart';
import 'package:diyet_ofisim/Pages/LoginSignupPage.dart';
import 'package:diyet_ofisim/Pages/Patient/profileEdit.dart';
import 'package:diyet_ofisim/Services/AuthService.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Tools/NavigationManager.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class PatientProfilePage extends StatefulWidget {
  PatientProfilePage({Key key}) : super(key: key);

  @override
  _PatientProfilePageState createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends State<PatientProfilePage> {
  Color renk = Colors.deepPurpleAccent[100];
  Patient usermodel = locator<UserService>().userModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: bodyContainer(),
    );

    /* Scaffold(
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
  */
  }

  Widget bodyContainer() {
    return SingleChildScrollView(
      child: Column(
        children: [
          info(),
          SizedBox(height: 30), //20
          ProfileMenuItem(
            iconName: Icon(Icons.assignment_sharp, color: renk),
            title: "Şartlar ve Koşullar",
            press: () {},
          ),
          ProfileMenuItem(
            iconName: Icon(
              Icons.lock_sharp,
              color: renk,
            ),
            title: "Gizlilik Politakası",
            press: () {},
          ),

          ProfileMenuItem(
            iconName: Icon(Icons.exit_to_app_rounded, color: renk),
            title: "Çıkış Yap",
            press: () {
              locator<AuthService>().signOut();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginSignupPage()));
            },
          ),
        ],
      ),
    );
  }

  Widget info() {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Positioned(
          child: ClipPath(
            clipper: MyCustomClipper(),
            child: Container(
              color: Colors.deepPurpleAccent[100],
              width: double.infinity,
              height: 150.0,
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 25), //10
                height: PageComponents(context).widthSize(30),

                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 8, //8
                  ),
                ),
                child: ClipOval(
                  child: FadeInImage(
                    image:
                        ExtendedNetworkImageProvider(usermodel.profilePhotoUrl),
                    placeholder:
                        ExtendedAssetImageProvider("assets/photo/nutri.jpg"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              Text(
                usermodel.name + " " + usermodel.surname,
                style: TextStyle(
                  fontSize: 20.5,
                  fontFamily: "Genel", // 22
                  color: Color(0xFF8492A2),
                ),
              ),
              SizedBox(height: 10), //5
              Text(
                usermodel.email,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF8492A2),
                    fontSize: 14.5),
              )
            ],
          ),
        )
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.deepPurpleAccent[100],
      // leading: SizedBox(),
      elevation: 0,

      //centerTitle: true,
      title: Text(
        "Profilim",
        style: TextStyle(
          color: Colors.white,
          fontSize: 24, //16
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            NavigationManager(context).pushPage(ProfileEdit());
          },
          child: Text(
            "Edit",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16, //16
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double height = size.height;
    double width = size.width;
    path.lineTo(0, height - 100);
    path.quadraticBezierTo(width / 2, height, width, height - 100);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class ProfileMenuItem extends StatefulWidget {
  const ProfileMenuItem({
    Key key,
    this.iconName,
    this.title,
    this.press,
  }) : super(key: key);
  final String title;
  final Function press;
  final Icon iconName;

  @override
  _ProfileMenuItemState createState() => _ProfileMenuItemState();
}

class _ProfileMenuItemState extends State<ProfileMenuItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.press,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: SafeArea(
          child: Row(
            children: <Widget>[
              widget.iconName,
              SizedBox(width: 20),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 16, //16
                  color: Color(0xFF8492A2),
                ),
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Color(0xFF8492A2),
              )
            ],
          ),
        ),
      ),
    );
  }
}

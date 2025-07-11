import 'dart:async';
import 'package:diyet_ofisim/Pages/RootPage.dart';
import 'package:diyet_ofisim/Pages/loginSignupPage.dart';
import 'package:diyet_ofisim/Services/AuthService.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  authChecking(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      locator<AuthService>().getUserUid().then((userID) {
        if (userID != null) {
          if (kDebugMode) {
            print("UserID:$userID");
          }
          locator<UserService>().userInitializer(userID).then((value) {
            if (value) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const RootPage()));
            }
          });
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const LoginSignupPage()));
        }
      });
    });
  }

/*
  Future<bool> checkUpdate() async {
    String appVersion;
    String serverVersion;
    var temp, temp2;
    bool needToUpdate = false;
    try {
      await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
        print("appVersion:" + packageInfo.version);
        appVersion = packageInfo.version;
      });
      serverVersion = await locator<DatabaseWorks>().getServerVersion();
      print("serverVersion:" + serverVersion);
      temp = appVersion.split(".");
      temp2 = serverVersion.split(".");
      for (int i = 0; i < 3; i++) {
        if (int.parse(temp2[i]) > int.parse(temp[i])) needToUpdate = true;
      }
      return needToUpdate;
    } catch (e) {
      print(e);
      return null;
    }
  }
*/
  @override
  void initState() {
    authChecking(context);
    super.initState();
  }

  /* @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    
    checkUpdate().then((value) {
      print(value);
      if (!value)
        authChecking(context);
      else
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => Scaffold(
                      body: Center(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Lütfen Uygulamayı Güncelleyin!"),
                              SizedBox(
                                height: 50,
                              ),
                              MaterialButton(
                                  child: Text("Güncelle"),
                                  color: Colors.green,
                                  onPressed: () {
                                    StoreRedirect.redirect();
                                  })
                            ],
                          ),
                        ),
                      ),
                    )));
    });
  
  }*/

  @override
  Widget build(BuildContext context) {
    return Container(
      // ANCHOR  background image icin renk karisimini saglayan bir ozellik
      // ANCHOR  2 den fazla renk eklenebilir https://alligator.io/flutter/flutter-gradient/
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.deepPurpleAccent[200]!,
              Colors.deepPurpleAccent[100]!,
              Colors.deepPurple[50]!,
            ]),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Diyet Ofisim",
              style: TextStyle(
                decoration: TextDecoration.none,
                fontFamily: 'Kalam',
                fontSize: 50,
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
          // ANCHOR  text ile loading isareti arasina 200 height birakir
          SizedBox(
            height: 200.0,
          ),
          // ANCHOR bu nedir çok kullanım görünüyor bunun için "Flutter Performance" ekranında?
          // ANCHOR  spinkit package kullanildi https://pub.dev/packages/flutter_spinkit
          SpinKitFoldingCube(
            color: Colors.white,
            size: 100.0,
            duration: Duration(seconds: 2),
          ),
          SizedBox(height: 40.0),
          Text(
            "Loading",
            style: TextStyle(
              decoration: TextDecoration.none,
              fontFamily: 'IndieFlower',
              color: Colors.white,
              fontSize: 20,
              letterSpacing: 2.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

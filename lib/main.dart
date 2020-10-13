import 'package:diyet_ofisim/Components/SplashScreen.dart';
import 'package:diyet_ofisim/Services/NavigationProvider.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
    name: 'DiyetOfisim',
    options: FirebaseOptions(
      appId: '1:657550802981:android:596a27d8462bb6c53e7fcc',
      apiKey: 'AIzaSyDZrBoJjE9HmA8g00TClzzCROdAC_InOSc',
      projectId: "diyet-ofisim",
      messagingSenderId: "657550802981",
      databaseURL: 'https://diyet-ofisim.firebaseio.com',
    ),
  );

  setupLocator(app: app);
  //ANCHOR burada ekranın dönmesi engellenir, dikey mod
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //ANCHOR status barı transparent yapıyor
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          // ChangeNotifierProvider<MessagingService>(
          //     create: (context) => MessagingService()),
          ChangeNotifierProvider<NavigationProvider>(
            create: (context) => NavigationProvider(),
          ),
          // ChangeNotifierProvider<UserService>(
          //     create: (context) => UserService()),
        ],
        child: MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            debugShowMaterialGrid: false,
            debugShowCheckedModeBanner: false,
            supportedLocales: const <Locale>[
              Locale('en', 'US'),
              Locale('tr', 'TR')
            ],
            home: SplashScreen()));
  }
}

import 'package:diyet_ofisim/SplashScreen.dart';
import 'package:diyet_ofisim/Services/NavigationProvider.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupLocator();
  //ANCHOR burada ekranın dönmesi engellenir, dikey mod
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //ANCHOR status barı transparent yapıyor
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider<MessagingService>(
        //     create: (context) => MessagingService()),
        ChangeNotifierProvider<NavigationProvider>(create: (context) => NavigationProvider()),
        // ChangeNotifierProvider<UserService>(
        //     create: (context) => UserService()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: "Genel",
          primaryColor: Colors.deepPurpleAccent.shade100,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en', 'US'), Locale('tr', 'TR')],
        debugShowMaterialGrid: false,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}

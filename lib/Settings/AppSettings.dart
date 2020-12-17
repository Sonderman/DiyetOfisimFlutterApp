import 'package:diyet_ofisim/Pages/ChatPage.dart';
import 'package:diyet_ofisim/Pages/Dietician/AppointmentsPage.dart';
import 'package:diyet_ofisim/Pages/Dietician/DieticianProfilePage.dart';
import 'package:diyet_ofisim/Pages/Dietician/MyAppointments.dart';
import 'package:diyet_ofisim/Pages/Patient/PatientProfilePage.dart';
import 'package:diyet_ofisim/Pages/Patient/HomePage.dart';
import 'package:diyet_ofisim/Pages/Patient/MyCalendarPage.dart';
import 'package:flutter/material.dart';

enum Diseases { h1, h2 }

class AppSettings {
  final String appName = "DiyetOfisimApp";
  final int defaultNavIndex = 0;
  //final String _server = "Release";
  final String _server = "Development";
  //final String _server = "OpenTest";
  String getServer() => _server;

  //ANCHOR hasta sayfaları burada
  List<Widget> patientPages = [
    HomePage(),
    MyCalendarPage(),
    ChatPage(),
    PatientProfilePage(),
  ];
  //ANCHOR diyetisyen sayfaları burada
  List<Widget> dieticianPages = [
    ChatPage(),
    MyAppointmentsPage(),
    DieticianProfilePage()
  ];

  List<String> diseases = ["Hastalık 1", "Hastalık 2"];
}

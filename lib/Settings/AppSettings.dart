import 'package:diyet_ofisim/Pages/ChatPage.dart';
import 'package:diyet_ofisim/Pages/Dietician/DieticianProfilePage.dart';
import 'package:diyet_ofisim/Pages/Dietician/MyAppointments.dart';
import 'package:diyet_ofisim/Pages/Patient/PatientProfilePage.dart';
import 'package:diyet_ofisim/Pages/Patient/HomePage.dart';
import 'package:diyet_ofisim/Pages/Patient/MyCalendarPage.dart';
import 'package:flutter/material.dart';

enum Diseases {
  anoreksiya,
  bariatri,
  cocuk,
  colyak,
  diyabet,
  enteral,
  gebelik,
  gluten,
  gut,
  hasimato,
  hipertansiyon,
  kalp_Damar,
  kiloAlma,
  kiloVerme,
  menopoz,
  metabolik,
  migren,
  obezite,
  parenteral,
  reaktif,
  sporcu,
  troid,
  tupBebek
}

class AppSettings {
  final String appName = "DiyetOfisimApp";
  final int defaultNavIndex = 0;
  //final String _server = "Release";
  final String _server = "Development";

  var odemeType;
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

  List<String> diseases = [
    "Anoreksiya ve Bulimia Hastalarında Beslenme",
    "Bariatri Diyetisyenliği",
    "Çocuk Beslenmesi",
    "Çölyak Hastalığında Beslenme",
    "Diyabet Diyeti",
    "Enteral Beslenme",
    "Gebelik ve Beslenme",
    "Gluten İntoleransında Beslenme",
    "Gut Hastalığı ve Beslenme",
    "Haşimato Hastalığında Beslenme",
    "Hipertansiyonda Beslenme",
    "Kalp Damar Hastalıkları ve Beslenme",
    "Kilo Alma Diyetleri",
    "Kilo Verme Diyetleri",
    "Menopozda Beslenme",
    "Metabolik Hastalıklarda Beslenme",
    "Migrende Beslenme",
    "Obezite",
    "Parenteral Beslenme",
    "Reaktif Hipoglisemi ve Beslenme",
    "Sporcu Beslenmesi",
    "Troid Hastalıklarında Beslenme",
    "Tüp Bebek ve İnfertilite Tedavisinde Beslenme",
  ];
  List<String> insuranceType = ["Sigortalı Hastalar", "Sigortasız Hastalar"];
}

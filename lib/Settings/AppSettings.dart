import 'package:diyet_ofisim/Pages/chatPage.dart';
import 'package:diyet_ofisim/Pages/Dietician/DieticianProfilePage.dart';
import 'package:diyet_ofisim/Pages/Dietician/myAppointments.dart';
import 'package:diyet_ofisim/Pages/Patient/PatientProfilePage.dart';
import 'package:diyet_ofisim/Pages/Patient/HomePage.dart';
import 'package:diyet_ofisim/Pages/Patient/myCalendarPage.dart';
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
  kalpDamar,
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

  // var odemeType;
  //final String _server = "OpenTest";
  String getServer() => _server;

  //ANCHOR hasta sayfaları burada
  List<Widget> patientPages = [
    const HomePage(),
    const MyCalendarPage(),
    const ChatPage(),
    const PatientProfilePage(),
  ];
  //ANCHOR diyetisyen sayfaları burada
  List<Widget> dieticianPages = [
    const MyAppointmentsPage(),
    const ChatPage(),
    const DieticianProfilePage()
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
  final List<String> appointmentHours = [
    "09:00",
    "10:00",
    "11:00",
    "12:00",
    "14:00",
    "15:00",
    "16:00",
    "17:00",
    "18:00",
    "19:00",
    "20:00"
  ];
}

import 'package:flutter/material.dart';

class Dietician {
  final String id;
  String name;
  String surname;
  String nickname;
  String email;
  int telNo;
  String birthday;
  String city;
  String gender;
  String about;
  String profilePhotoUrl;

  Dietician({@required this.id});

  Map<String, dynamic> toMap() {
    return {
      'Name': name ?? 'null',
      'Surname': surname ?? 'null',
      'NickName': nickname ?? 'null',
      'Email': email ?? 'null',
      'BirthDay': birthday ?? 'null',
      'Gender': gender ?? 'null',
      'City': city ?? 'null',
      'ProfilePhotoUrl': profilePhotoUrl ?? 'null',
      'About': about ?? 'null',
      'PhoneNumber': telNo ?? 0,
    };
  }

  void parseMap(Map<String, dynamic> map) {
    name = map["Name"] ?? "null";
    surname = map["Surname"] ?? "null";
    nickname = map["NickName"] ?? "null";
    email = map["Email"] ?? "null";
    city = map["City"] ?? "null";
    birthday = map["BirthDay"] ?? "null";
    gender = map["Gender"] ?? "null";
    profilePhotoUrl = map["ProfilePhotoUrl"];
    about = map['About'] ?? "Henüz Detay Girilmedi.";
    telNo = map["PhoneNumber"] ?? 0;
  }
}

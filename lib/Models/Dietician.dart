class Dietician {
  final String id;
  late String name;
  late String surname;
  late String nickname;
  late String email;
  late int telNo;
  late String birthday;
  late String city;
  late String gender;
  late String about;
  late String profilePhotoUrl;
  late List treatments;
  late List insuranceTypes;
  late String education;
  late String experiences;
  late bool firstTimeProfileCreation;

  Dietician({required this.id});

  Dietician.predefined(
      {required this.id,
      required this.name,
      required this.surname,
      required this.nickname,
      required this.email,
      required this.telNo,
      required this.birthday,
      required this.city,
      required this.gender,
      required this.about,
      required this.profilePhotoUrl,
      required this.treatments,
      required this.insuranceTypes,
      required this.education,
      required this.experiences,
      required this.firstTimeProfileCreation});

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'Surname': surname,
      'NickName': nickname,
      'Email': email,
      //'BirthDay': birthday ?? 'null',
      'Gender': gender,
      //'City': city ?? 'null',
      'ProfilePhotoUrl': profilePhotoUrl,
      'About': about,
      'Treatments': treatments,
      'InsuranceTypes': insuranceTypes,
      "Education": education,
      "Experiences": experiences,
      "isFirstTime": firstTimeProfileCreation,
      //'PhoneNumber': telNo ?? 0,
    };
  }

  void parseMap(Map<String, dynamic> map) {
    name = map["Name"] ?? "null";
    surname = map["Surname"] ?? "null";
    nickname = map["NickName"] ?? "null";
    email = map["Email"] ?? "null";
    //city = map["City"] ?? "null";
    //birthday = map["BirthDay"] ?? "null";
    gender = map["Gender"] ?? "null";
    profilePhotoUrl = map["ProfilePhotoUrl"];
    about = map['About'] ?? "Henüz Detay Girilmedi.";
    treatments = map["Treatments"] ?? [];
    insuranceTypes = map["InsuranceTypes"] ?? [];
    education = map["Education"] ?? " Belirtilmedi";
    experiences = map["Experiences"] ?? "Belirtilmedi";
    //telNo = map["PhoneNumber"] ?? 0;
    firstTimeProfileCreation = map["isFirstTime"] ?? true;
  }
}

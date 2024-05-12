class Patient {
  final String id;
  late String name;
  late String surname;
  late String nickname;
  late String email;
  late int telNo;
  late String birthday;
  late String city;
  late String gender;
  late String profilePhotoUrl;

  Patient({required this.id});
  Patient.predefined(
      {required this.id,
      required this.name,
      required this.surname,
      required this.nickname,
      required this.email,
      required this.telNo,
      required this.birthday,
      required this.city,
      required this.gender,
      required this.profilePhotoUrl});

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'Surname': surname,
      'NickName': nickname,
      'Email': email,
      'BirthDay': birthday,
      'Gender': gender,
      'City': city,
      'ProfilePhotoUrl': profilePhotoUrl,
      'PhoneNumber': telNo,
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
    telNo = map["PhoneNumber"] ?? 0;
  }
}

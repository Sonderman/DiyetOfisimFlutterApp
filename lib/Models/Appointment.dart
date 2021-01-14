class Appointment {
  String dID;
  String pID;
  int year;
  int month;
  int day;
  String hour;
  int status;
  String extra;
  String name;
  String surname;
  String email;
  bool pReady;
  bool dReady;

  Map<String, dynamic> toMap() {
    return {
      'DieticianID': dID,
      'PatientID': pID,
      'Status': status,
      'Extra': extra,
      'Name': name,
      'Surname': surname,
      'Email': email,
      'pReady': pReady,
      'dReady': dReady
    };
  }

  void parseMap(Map<String, dynamic> map) {
    dID = map["DieticianID"] ?? "noID";
    pID = map["PatientID"] ?? "noID";
    status = map["Status"] ?? -1;
    extra = map["Extra"] ?? "noExtra";
    name = map["Name"] ?? "NoName";
    surname = map["Surname"] ?? "NoSurname";
    email = map["Email"] ?? "NoEmail";
    pReady = map["pReady"] ?? false;
    dReady = map["dReady"] ?? false;
  }
}

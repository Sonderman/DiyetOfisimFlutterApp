class Appointment {
  late String dID;
  late String pID;
  late DateTime date;
  late int status;
  late String extra;
  late String name;
  late String surname;
  late String email;
  late bool pReady;
  late bool dReady;

  Appointment();

  Appointment.predefined(
      {required this.dID,
      required this.pID,
      required this.date,
      required this.status,
      required this.extra,
      required this.name,
      required this.surname,
      required this.email,
      required this.pReady,
      required this.dReady});

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
      'dReady': dReady,
      'date': date.millisecondsSinceEpoch
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
    date = DateTime.fromMillisecondsSinceEpoch(map["date"] as int);
  }
}

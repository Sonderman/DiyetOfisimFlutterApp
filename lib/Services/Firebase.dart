import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:diyet_ofisim/Models/Appointment.dart';
import 'package:diyet_ofisim/Models/Dietician.dart';
import 'package:diyet_ofisim/Settings/AppSettings.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class AutoIdGenerator {
  static const int _AUTO_ID_LENGTH = 20;

  static const String _AUTO_ID_ALPHABET =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

  static final Random _random = Random();

  static String autoId() {
    final StringBuffer stringBuffer = StringBuffer();
    const int maxRandom = _AUTO_ID_ALPHABET.length;

    for (int i = 0; i < _AUTO_ID_LENGTH; ++i) {
      stringBuffer.write(_AUTO_ID_ALPHABET[_random.nextInt(maxRandom)]);
    }

    return stringBuffer.toString();
  }
}

class DatabaseWorks {
  AppSettings settings = locator<AppSettings>();
  late DocumentReference _ref;

  DatabaseWorks() {
    if (kDebugMode) {
      print("DatabaseWorks locator is running");
    }
    _ref = FirebaseFirestore.instance
        .collection(settings.appName)
        .doc(settings.getServer());
  }

  Future<bool> sendComment(
      String userID, String currentUserID, String comment) async {
    try {
      return await _ref
          .collection("users")
          .doc(userID)
          .collection("Comments")
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({"Comment": comment, "CommentOwnerID": currentUserID}).then((_) {
        return true;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getComments(String userID) async {
    List<Map<String, dynamic>> commmentList = [];
    try {
      return await _ref
          .collection("users")
          .doc(userID)
          .collection("Comments")
          .get()
          .then((data) {
        if (data.size > 0) {
          (data.docs as Map<String, dynamic>).forEach((key, value) {
            commmentList.add(value);
          });
        }

        //print("Comments:" + commmentList.toString());
        return commmentList;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return commmentList;
    }
  }

  Future<String> sendMessage(
      {required ChatMessage message,
      required String chatID,
      required String currentUser,
      required String otherUserID}) async {
    String currentDate = DateTime.now().millisecondsSinceEpoch.toString();
    if (chatID == "temp") {
      chatID = AutoIdGenerator.autoId();
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
            _ref
                .collection('users')
                .doc(currentUser)
                .collection('messages')
                .doc(chatID),
            {"OtherUserID": otherUserID});
        transaction.set(
            _ref
                .collection('users')
                .doc(otherUserID)
                .collection('messages')
                .doc(chatID),
            {"OtherUserID": currentUser});
      });
    }
    var messageRef = _ref
        .collection('messagePool')
        .doc(chatID)
        .collection('messages')
        .doc(currentDate);
    Map<String, dynamic> messageMap = message.toJson();
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        messageRef,
        messageMap,
      );
      transaction.set(
        _ref.collection('messagePool').doc(chatID),
        {
          "LastMessage": {
            "SenderID": currentUser,
            "Message": messageMap['text'],
            "createdAt": currentDate
          }
        },
      );
    }, timeout: const Duration(seconds: 1));
    return chatID;
  }

  Future<String> checkConversation(String currentUser, String otherUser) async {
    try {
      return await _ref
          .collection('users')
          .doc(currentUser)
          .collection('messages')
          .where("OtherUserID", isEqualTo: otherUser)
          .limit(1)
          .get()
          .then((data) {
        return data.docs.first.id;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return "bos";
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getChatPoolSnapshot(
      String chatID) {
    return _ref.collection('messagePool').doc(chatID).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessagesSnapshot(
      String chatID) {
    return _ref
        .collection('messagePool')
        .doc(chatID)
        .collection('messages')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserChatsSnapshots(
      String currentUser) {
    return _ref
        .collection('users')
        .doc(currentUser)
        .collection('messages')
        .snapshots();
  }

  Future<bool> newUser(Map<String, dynamic> data) async {
    try {
      return await _ref
          .collection('users')
          .doc(data['UserID'])
          .set(data)
          .then((value) => true);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<Map<String, dynamic>?> findUserbyID(String userID) async {
    try {
      return await _ref.collection("users").doc(userID).get().then((userData) {
        return userData.data();
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<bool> updateUserProfile(
      String id, Map<String, dynamic> userData) async {
    try {
      await _ref.collection("users").doc(id).update(userData);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

//NOTE - Diyetisyen tedavi edebileceği hastalıkları güncellerken diyetisyen listesinde de güncelle
  Future<bool> insertNewDietician(
      String id, List treatments, bool update) async {
    /* String temp = "";
    int i = 0;
    treatments.sort();
    treatments.forEach((element) {
      temp += element.toString();
      if (i != treatments.length - 1) temp += ",";
      i++;
    });
*/
    try {
      var ref2 = _ref.collection("dieticians").doc(id);

      if (update) {
        await ref2.update({"DieticianID": id, "Treatments": treatments});
      } else {
        await ref2.set({"DieticianID": id, "Treatments": treatments});
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<List<Dietician>> findDieticianbyResults(List<Diseases> r) async {
    List<int> results = [];

    results = r.map((e) => e.index).toList();
    /*
    String temp = "";
    int i = 0;
    

    

    results.sort((a, b) {
      if (a < b)
        return b;
      else
        return a;
    });
    print(results);

    results.forEach((e) {
      temp += e.toString();
      if (i != results.length - 1) temp += ",";
      i++;
    });
*/
    bool compareLists(List list, List list2) {
      for (int e in list2) {
        if (list.contains(e)) return true;
      }
      return false;
    }

    try {
      return await _ref
          .collection("dieticians")
          // .orderByChild('Treatments')
          // .equalTo(temp)
          .get()
          .then((userData) async {
        List<String> idList = [];
        List<Dietician> dieticianList = [];
        if (kDebugMode) {
          print(results.length);
        }

        for (var e in userData.docs) {
          if (compareLists(e.data()["Treatments"], results)) {
            if (kDebugMode) {
              print("girdi");
            }
            idList.add(e.data()["DieticianID"]);
          } else {
            if (kDebugMode) {
              print("girmedi");
            }
          }
        }

        await Future.forEach(idList, (id) async {
          Dietician? t = await findUserbyID(id).then((data) {
            if (data != null) {
              var model = Dietician(id: data["UserID"]);
              model.parseMap(data);
              return model;
            } else {
              return null;
            }
          });
          if (t == null) return;
          dieticianList.add(t);
        });

        return dieticianList;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  Future<Map<String, dynamic>?> getAppointmentCalendar(String dID) async {
    try {
      return await _ref
          .collection("appointmentCalendar")
          .doc(dID)
          .get()
          .then((data) {
        if (data.data() != null) {
          return data.data();
        } else {
          return null;
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<bool> createAppointment(Appointment a, String myID) async {
    String month, day;
    month = a.date.month.toString();
    day = a.date.day.toString();
    if (a.date.month < 10) month = "0$month";
    if (a.date.day < 10) day = "0$day";
    try {
      await _ref
          .collection("appointmentCalendar")
          .doc(a.dID)
          .collection(a.date.year.toString())
          .doc(month)
          .collection(day)
          .doc(a.date.hour.toString())
          .update(a.toMap());

      await _ref
          .collection("users")
          .doc(myID)
          .collection("myAppointments")
          .doc(a.dID)
          .collection(a.date.year.toString())
          .doc(month)
          .collection(day)
          .doc(a.date.hour.toString())
          .update(a.toMap());

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

//yarım kaldı / Diyetisyen modeli ve Appointments 2d list döncek
  Future<List<List<dynamic>>> getMyAppointments(String myId) async {
    List<List<dynamic>> temp = [];

    try {
      return await _ref
          .collection("users")
          .doc(myId)
          .collection("myAppointments")
          .get()
          .then((data) async {
        for (var e in data.docs) {
          Appointment ap = Appointment();
          ap.parseMap(e.data());

          await findUserbyID(ap.dID).then((v) {
            if (v != null) {
              Dietician dModel;
              dModel = Dietician(id: ap.dID);
              dModel.parseMap(v);

              /*Map e = tmap.values.toList()[c];

              (e).forEach((year, i) {
                (i as Map).forEach((month, j) {
                  (j as Map).forEach((day, k) {
                    (k as Map).forEach((hours, h) {
                      Appointment a = Appointment();
                      a.parseMap(Map<String, dynamic>.from(h));
                      a.year = int.tryParse(year);
                      a.month = int.tryParse(month);
                      a.day = int.tryParse(day);
                      a.hour = hours;
                      temp.add([dModel, a]);
                    });
                  });
                });
              });*/
            }
          });
        }

        return temp;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  Future<bool> updateAppointmentStatus(Appointment a) async {
    String month, day;
    month = a.date.month.toString();
    day = a.date.day.toString();
    if (a.date.month < 10) month = "0$month";
    if (a.date.day < 10) day = "0$day";
    try {
      await _ref
          .collection("users")
          .doc(a.pID)
          .collection("myAppointments")
          .doc(a.dID)
          .collection(a.date.year.toString())
          .doc(month)
          .collection(day)
          .doc(a.date.hour.toString())
          .update({"Status": a.status});
      await _ref
          .collection("appointmentCalendar")
          .doc(a.dID)
          .collection(a.date.year.toString())
          .doc(month)
          .collection(day)
          .doc(a.date.hour.toString())
          .update({"Status": a.status});
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>>? getMyCalendarSnapshot(
      String dID) {
    try {
      return _ref.collection("appointmentCalendar").doc(dID).snapshots();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>?>
      readyForAppointmentToggle(Appointment a, bool readyToggle) async {
    String month, day;
    month = a.date.month.toString();
    day = a.date.day.toString();
    if (a.date.month < 10) month = "0$month";
    if (a.date.day < 10) day = "0$day";
    try {
      await _ref
          .collection("users")
          .doc(a.pID)
          .collection("myAppointments")
          .doc(a.dID)
          .collection(a.date.year.toString())
          .doc(month)
          .collection(day)
          .doc(a.date.hour.toString())
          .update({"pReady": readyToggle});
      await _ref
          .collection("appointmentCalendar")
          .doc(a.dID)
          .collection(a.date.year.toString())
          .doc(month)
          .collection(day)
          .doc(a.date.hour.toString())
          .update({"pReady": readyToggle});
      if (readyToggle) {
        return _ref
            .collection("appointmentCalendar")
            .doc(a.dID)
            .collection(a.date.year.toString())
            .doc(month)
            .collection(day)
            .doc(a.date.hour.toString())
            .snapshots();
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<bool> startAppointment(Appointment a) async {
    String month, day;
    month = a.date.month.toString();
    day = a.date.day.toString();
    if (a.date.month < 10) month = "0$month";
    if (a.date.day < 10) day = "0$day";
    try {
      await _ref
          .collection("appointmentCalendar")
          .doc(a.dID)
          .collection(a.date.year.toString())
          .doc(month)
          .collection(day)
          .doc(a.date.hour.toString())
          .update({"dReady": true});
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> finishConversation(String chatID) async {
    try {
      await _ref
          .collection("messagePool")
          .doc(chatID)
          .update({"Status": false});
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatStatusSnapshot(
      String chatID) {
    return _ref
        .collection("messagePool")
        .doc(chatID)
        .collection("Status")
        .snapshots();
  }
}

class StorageWorks {
  final Reference ref = FirebaseStorage.instance.ref();
  AppSettings settings = locator<AppSettings>();
  StorageWorks() {
    if (kDebugMode) {
      print("StorageWorks locator running");
    }
  }

  Future<String> updateProfilePhoto(String userId, Uint8List image) async {
    String url = "";

    try {
      Reference imgRef = ref
          .child('users')
          .child(userId)
          .child('images')
          .child('profile')
          .child('ProfileImage');

      UploadTask uploadTask = imgRef.putData(image);

      await uploadTask.whenComplete(() async {
        await imgRef.getDownloadURL().then((value) async {
          url = value;
          return await locator<DatabaseWorks>()
              ._ref
              .collection("users")
              .doc(userId)
              .update({"ProfilePhotoUrl": value});
        });
      });
      return url;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return url;
    }
  }

  Future sendImageMessage(File image, ChatUser user, String currentUser,
      String chatID, String time) async {
    final Reference storageRef =
        ref.child("users").child(currentUser).child("images").child(time);
/*
    UploadTask  uploadTask = storageRef.putFile(
      image,
      StorageMetadata(
        contentType: 'image/jpg',
      ),
    );
    
    TaskSnapshot download = await uploadTask.onComplete;

    return await download.ref.getDownloadURL().then((url) {
      ChatMessage message = ChatMessage(text: "", user: user, image: url);
      return message;
    });
    */
  }
}

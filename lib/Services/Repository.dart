import 'dart:async';
import 'dart:typed_data';
import 'package:dash_chat/dash_chat.dart';
import 'package:diyet_ofisim/Models/Appointment.dart';
import 'package:diyet_ofisim/Models/Patient.dart';
import 'package:diyet_ofisim/Models/Dietician.dart';
import 'package:diyet_ofisim/Services/AuthService.dart';
import 'package:diyet_ofisim/Services/Firebase.dart';
import 'package:diyet_ofisim/Settings/AppSettings.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:firebase_database/firebase_database.dart';

class LoginRegisterService {
  final DatabaseWorks _database = locator<DatabaseWorks>();
  final StorageWorks _storage = locator<StorageWorks>();
  Future<String> registerUser(String eposta, String password,
      List<String> datalist, Uint8List image) async {
    Map<String, dynamic> data = {
      "Name": datalist[0],
      "Surname": datalist[1],
      "Email": datalist[2],
      //"PhoneNumber": int.parse(datalist[3]),
      "Gender": datalist[3],
      "isDietisian": datalist[4],
      "NickName": datalist[5],
      "ProfilePhotoUrl": "",
      "RegisteredAt": ServerValue.timestamp,
      "isFirstTime": true
    };
    try {
      AuthService auth = locator<AuthService>();
      return await auth.signUp(eposta, password).then((userId) async {
        if (userId != null) {
          data['UserID'] = userId;

          await _database.newUser(data).then((value) async {
            if (value) await _storage.updateProfilePhoto(userId, image);
          });

          //auth.sendEmailVerification();
          return userId;
        } else
          return null;
      });
    } catch (e) {
      print(e);
      return null;
    }
  }
}

///UserService*****************************************************************************************************
class UserService {
  var userModel;
  final DatabaseWorks _database = locator<DatabaseWorks>();
  final StorageWorks _storage = locator<StorageWorks>();

  Future<bool> userInitializer(String userID) async {
    if (userID == null) return false;
    return await userModelSync(userID);
  }

  Future<bool> userModelSync(String userID) async {
    try {
      return await findUserByID(userID).then((map) {
        if (map['isDietisian'] == "Y") {
          print("User: Diyetisyen");
          userModel = Dietician(id: userID);
          userModel.parseMap(map);
        } else {
          print("User: Hasta");
          userModel = Patient(id: userID);
          userModel.parseMap(map);
        }

        return true;
      });
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Map<String, dynamic>> findUserByID(String userID) {
    return _database.findUserbyID(userID);
  }

  Future<bool> updateUserProfile(
      {Uint8List image, bool isUpdatingTreatments = false}) async {
    if (userModel.runtimeType == Dietician)
      userModel.firstTimeProfileCreation = false;
    Map<String, dynamic> userData = userModel.toMap();

    if (image != null) {
      userModel.profilePhotoUrl =
          await _storage.updateProfilePhoto(userModel.id, image);
    }

    if (isUpdatingTreatments == true && userModel.runtimeType == Dietician) {
      await insertNewDietician(update: true);
    }
    return await _database.updateUserProfile(userModel.id, userData);
  }

  Future<bool> insertNewDietician({bool update = false}) async {
    return await _database.insertNewDietician(
        userModel.id, userModel.treatments, update);
  }

  Future<List<Map>> getComments(String userID) async {
    return await _database.getComments(userID);
  }

  Future<bool> sendComment(String userID, String text) async {
    return await _database.sendComment(userID, userModel.id, text);
  }

  Future<List<Dietician>> findDieticianbyResults(List<Diseases> results) async {
    return await _database.findDieticianbyResults(results);
  }

  Future<Map<String, dynamic>> getAppointmentCalendar(String dID) async {
    return await _database.getAppointmentCalendar(dID);
  }

  Future<bool> createAppointment(Appointment appointment) async {
    return await _database.createAppointment(appointment, userModel.id);
  }

  Future<List<List<dynamic>>> getMyAppointments() async {
    return await _database.getMyAppointments(userModel.id);
  }

  Future<bool> updateAppointmentStatus(Appointment aModel, int status) async {
    aModel.status = status;
    return await _database.updateAppointmentStatus(aModel);
  }

  Stream<Event> getMyCalendarSnapshot() {
    return _database.getMyCalendarSnapshot(userModel.id);
  }

  Future<Stream<Event>> readyForAppointmentToggle(
      Appointment a, bool readyToggle) async {
    return await _database.readyForAppointmentToggle(a, readyToggle);
  }

  Future<bool> startAppointment(Appointment a) async {
    return await _database.startAppointment(a);
  }
}

///MessageService*****************************************************************************************************

class MessagingService {
  final DatabaseWorks firebaseDatabaseWorks = locator<DatabaseWorks>();
  final StorageWorks firebaseStorageWorks = locator<StorageWorks>();

  /*Future sendImageMessage(File image, ChatUser user, String currentUser,
      String chatID, String time) async {
    await firebaseDatabaseWorks.sendImageMessage(
        await firebaseStorageWorks.sendImageMessage(
            image, user, currentUser, chatID, time),
        time,
        chatID);
  }

  

  Stream<QuerySnapshot> getMessagesSnapshot(String chatID) {
    return firebaseDatabaseWorks.getMessagesSnapshot(chatID);
  }

  */
  //NOTE - Gereksiz Olabilir
  Future<Map<String, dynamic>> getChatPoolMessages(String chatID) async {
    return await firebaseDatabaseWorks.getChatPoolMessages(chatID);
  }

  Future<String> sendMessage(String chatID, ChatMessage message,
      String currentUserID, String otherUserID) async {
    return await firebaseDatabaseWorks.sendMessage(
        message, chatID, currentUserID, otherUserID);
  }

  Future<String> checkConversation(
      String currentUserID, String otherUserID) async {
    return await firebaseDatabaseWorks.checkConversation(
        currentUserID, otherUserID);
  }

  Stream<Event> getChatPoolMessagesSnapshot(String chatID) {
    return firebaseDatabaseWorks.getChatPoolMessagesSnapshot(chatID);
  }

  Stream<Event> getChatPoolSnapshot(String chatID) {
    return firebaseDatabaseWorks.getChatPoolSnapshot(chatID);
  }

  Stream<Event> getUserChatsSnapshot(String currentUser) {
    return firebaseDatabaseWorks.getUserChatsSnapshots(currentUser);
  }

  Future<bool> finishConversation(String chatID) async {
    return await firebaseDatabaseWorks.finishConversation(chatID);
  }

  Stream<Event> getChatStatusSnapshot(String chatID) {
    return firebaseDatabaseWorks.getChatStatusSnapshot(chatID);
  }
}
/*
Provider kullanımı
final  userService = Provider.of<UserService>(context);
*/

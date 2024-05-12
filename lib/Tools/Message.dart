import 'dart:async';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:diyet_ofisim/Models/Appointment.dart';
import 'package:diyet_ofisim/Models/Dietician.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Tools/Dialogs.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  //ANCHOR Karşıdaki kullanıcının Idsi ve ismi geliyor
  final String otherUserID;
  final String otherUserName;
  final Appointment? aModel;

  const Message(
      {super.key,
      required this.otherUserID,
      required this.otherUserName,
      this.aModel});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  UserService userService = locator<UserService>();
  MessagingService messageService = locator<MessagingService>();

  List<ChatMessage>? messages;
  StreamSubscription? messageStream;
  StreamSubscription? chatActivityStream;

  var scrollController = ScrollController();

  String chatID = "temp";
  late String currentUserID;
  late String otherUserID;
  late String currentUserPhotoUrl;

  var i = 0;
  bool runFutureOnce = false, isChatActive = true;
  ChatUser? user;

  @override
  void initState() {
    currentUserID = userService.userModel.id;
    otherUserID = widget.otherUserID;
    currentUserPhotoUrl = userService.userModel.profilePhotoUrl;

    //ANCHOR Buradaki user sağ tarafta görülen kendimiz
    user = ChatUser(
      firstName: userService.userModel.id,
      id: currentUserID,
      profileImage: currentUserPhotoUrl, // Kendi url miz
    );
    super.initState();
  }

  @override
  void dispose() {
    if (messageStream != null) messageStream!.cancel();
    if (chatActivityStream != null) chatActivityStream!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(widget.otherUserName),
        centerTitle: true,
        actions: [
          Visibility(
            visible:
                userService.userModel.runtimeType == Dietician && isChatActive,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                onPressed: () {
                  askingDialog(context, "Eminmisiniz?", Colors.white)
                      .then((value) {
                    if (value) {
                      messageService.finishConversation(chatID).then((value) {
                        if (value) {
                          userService
                              .updateAppointmentStatus(widget.aModel!, 1)
                              .then((value) {
                            if (value) {
                              Navigator.pop(context);
                            }
                          });
                        }
                      });
                    }
                  });
                },
                child: const Text(
                  "Görüşmeyi Sonlandır",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            )),
          )
        ],
      ),
      body: FutureBuilder(
        future: messageService.checkConversation(currentUserID, otherUserID),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (kDebugMode) {
            print("Control Future");
          }
          if (snapshot.connectionState == ConnectionState.done ||
              runFutureOnce) {
            // ANCHOR bu Future builder in birden çok defa çalışması textfield a tıklandığında
            //bütün widgetin rebuild olması sebebiyle keyboardın sürekli sıfırlanamsına sebep olmakta.
            runFutureOnce = true;
            if (!snapshot.hasError &&
                snapshot.hasData &&
                snapshot.data != "bos") {
              if (chatID == "temp") chatID = snapshot.data!;
            }

            if (messageStream == null && chatID != "temp") {
              messageStream = messageService
                  .getChatPoolMessagesSnapshot(chatID)
                  .listen((snapshot) {
                setState(() {
                  messages = snapshot.docs
                      .map((i) => ChatMessage.fromJson(i.data()))
                      .toList()
                      .reversed
                      .toList();
                });
              });

              /* chatActivityStream =
                  messageService.getChatStatusSnapshot(chatID).listen((snap) {
                if (snap.docs.isNotEmpty) {
                  setState(() {
                    isChatActive = snap.;
                  });
                }
              });*/
            }

            if (kDebugMode) {
              print("ChatID:$chatID");
            }
            return DashChat(
              currentUser: user!,
              onSend: (ChatMessage message) {
                messageService
                    .sendMessage(chatID, message, currentUserID, otherUserID)
                    .then((id) {
                  if (messages == null) {
                    if (kDebugMode) {
                      print("ilkmesaj");
                    }
                    setState(() {
                      chatID = id;
                    });
                  }
                });
              },
              messages: messages ?? [],
            );
          } else {
            return PageComponents(context)
                .loadingOverlay(spinColor: Colors.blue);
          }
        },
      ),
    );
  }
}

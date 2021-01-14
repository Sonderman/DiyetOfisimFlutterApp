import 'dart:async';
import 'dart:io';
import 'package:dash_chat/dash_chat.dart';
import 'package:diyet_ofisim/Models/Appointment.dart';
import 'package:diyet_ofisim/Models/Dietician.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Tools/Dialogs.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:diyet_ofisim/assets/Colors.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class Message extends StatefulWidget {
  //ANCHOR Karşıdaki kullanıcının Idsi ve ismi geliyor
  final otherUserID;
  final otherUserName;
  final Appointment aModel;
  Message(this.otherUserID, this.otherUserName, {this.aModel});

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();
  UserService userService = locator<UserService>();
  MessagingService messageService = locator<MessagingService>();
  List<ChatMessage> messages = [];
  StreamSubscription messageStream;
  StreamSubscription chatActivityStream;

  var m = List<ChatMessage>();
  var scrollController = ScrollController();
  String chatID = "temp";
  String currentUserID;
  String otherUserID;
  String currentUserPhotoUrl;
  var i = 0;
  bool runFutureOnce = false, isChatActive = true;
  ChatUser user;

  @override
  void initState() {
    currentUserID = userService.userModel.id;
    otherUserID = widget.otherUserID;
    currentUserPhotoUrl = userService.userModel.profilePhotoUrl;

    //ANCHOR Buradaki user sağ tarafta görülen kendimiz
    user = ChatUser(
      name: userService.userModel.id,
      uid: currentUserID,
      avatar: currentUserPhotoUrl, // Kendi url miz
    );
    super.initState();
  }

  @override
  void dispose() {
    if (messageStream != null) messageStream.cancel();
    if (chatActivityStream != null) chatActivityStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void initializeMessages() {
      if (messageStream == null && chatID != "temp") {
        messageStream = messageService
            .getChatPoolMessagesSnapshot(chatID)
            .listen((snapshot) {
          if (snapshot.snapshot.value != null)
            setState(() {
              messages
                  .add(ChatMessage.fromJson(snapshot.snapshot.value as Map));
            });
        });
        chatActivityStream =
            messageService.getChatStatusSnapshot(chatID).listen((snap) {
          if (snap.snapshot.value != null)
            setState(() {
              isChatActive = snap.snapshot.value;
            });
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors().lightGreen,
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
                    if (value)
                      messageService.finishConversation(chatID).then((value) {
                        if (value && widget.aModel != null)
                          userService
                              .updateAppointmentStatus(widget.aModel, 1)
                              .then((value) {
                            if (value) {
                              Navigator.pop(context);
                            }
                          });
                      });
                  });
                },
                child: Text(
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
          print("Control Future");
          if (snapshot.connectionState == ConnectionState.done ||
              runFutureOnce) {
            // ANCHOR bu Future builder in birden çok defa çalışması textfield a tıklandığında
            //bütün widgetin rebuild olması sebebiyle keyboardın sürekli sıfırlanamsına sebep olmakta.
            runFutureOnce = true;
            if (!snapshot.hasError &&
                snapshot.hasData &&
                snapshot.data != "bos") {
              if (chatID == "temp") chatID = snapshot.data;
            }

            initializeMessages();

            print("ChatID:" + chatID);
            return DashChat(
              readOnly: !isChatActive,
              inputDisabled: !isChatActive,
              key: _chatViewKey,
              scrollController: scrollController,
              onSend: (ChatMessage message) {
                messageService
                    .sendMessage(chatID, message, currentUserID, otherUserID)
                    .then((id) {
                  print("ChatID: " + id);
                  if (messages.length == 0) {
                    print("ilkmesaj");
                    setState(() {
                      chatID = id;
                    });
                  }
                });
              },
              shouldShowLoadEarlier: true,
              showLoadEarlierWidget: () => CircularProgressIndicator(),
              onLoadEarlier: () {
                print("loading...");
              },
              user: user,
              inputDecoration:
                  InputDecoration.collapsed(hintText: "Mesaj gönderin"),
              dateFormat: DateFormat('yyyy-MMM-dd', "tr"),
              timeFormat: DateFormat('HH:mm'),
              messages: messages ?? [],
              showUserAvatar: false,
              showAvatarForEveryMessage: false,
              onPressAvatar: (ChatUser user) {
                print("OnPressAvatar: ${user.name}");
              },
              onLongPressAvatar: (ChatUser user) {
                print("OnLongPressAvatar: ${user.name}");
              },
              inputMaxLines: 5,
              messageContainerPadding: EdgeInsets.only(left: 5.0, right: 5.0),
              inputTextStyle: TextStyle(fontSize: 16.0),
              inputContainerStyle: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 0.0),
                color: Colors.white,
              ),
              //REVIEW ScrolltoBottom problemini çöz
              scrollToBottom: false,
              //TODO Gerçek emoji mesajları gönderebilmeyi sağla
              leading: <Widget>[
                IconButton(
                    icon: Icon(
                      FontAwesomeIcons.smile,
                      color: Colors.deepOrange[700],
                    ),
                    onPressed: () {})
              ],
              inputCursorColor: MyColors().blueThemeColor,
              trailing: <Widget>[
                IconButton(
                  icon: Icon(Icons.photo),
                  onPressed: () async {
                    File result = await ImagePicker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 100,
                      maxHeight: 300,
                      maxWidth: 300,
                    );
                    if (result != null) {
                      String time =
                          DateTime.now().millisecondsSinceEpoch.toString();
/*
                      await messageService.sendImageMessage(
                          result, user, currentUserID, chatID, time);
                          */
                    }
                  },
                )
              ],
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

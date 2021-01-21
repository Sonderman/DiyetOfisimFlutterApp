import 'package:dash_chat/dash_chat.dart';
import 'package:diyet_ofisim/Pages/Components/CustomScroll.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Tools/Message.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:diyet_ofisim/assets/Colors.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  double heightSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.height * value;
  }

  double widthSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Görüşmeler", style: TextStyle(fontSize: 24),),
      backgroundColor: Colors.transparent,elevation: 0,),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: heightSize(5),
            ),
            chatRows(),
            SizedBox(
              height: heightSize(5),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatRows() {
    var messageService = locator<MessagingService>();
    var userService = locator<UserService>();
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
         
          Expanded(
            child: StreamBuilder(
              stream:
                  messageService.getUserChatsSnapshot(userService.userModel.id),
              builder: (context, AsyncSnapshot<Event> snapshot) {
                if (!snapshot.hasData) {
                  return PageComponents(context)
                      .loadingOverlay(backgroundColor: Colors.white);
                } else if (snapshot.data.snapshot.value == null) {
                  return Center(
                    child: Text("Henüz Görüşme Yapmadınız."),
                  );
                } else {
                  List items =
                      (snapshot.data.snapshot.value as Map).values.toList();
                  List chatIds =
                      (snapshot.data.snapshot.value as Map).keys.toList();
                  /*
                  var temp = (snapshot.data.snapshot.value as Map)
                      .map<String, dynamic>(
                          (key, value) => MapEntry(key, value));
                  */

                  int itemLength = (snapshot.data.snapshot.value as Map).length;

                  return ScrollConfiguration(
                    behavior: NoScrollEffectBehavior(),
                    child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(
                              height: 50,
                            ),
                        itemCount: itemLength,
                        itemBuilder: (context, index) {
                          String otherUserID = items[index]['OtherUserID'];
                          String chatID = chatIds[index];

                          return FutureBuilder(
                              future: userService.findUserByID(otherUserID),
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.done:
                                    String url =
                                        snapshot.data['ProfilePhotoUrl'];
                                    String userName = snapshot.data['Name'];

                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        Message(otherUserID,
                                                            userName)));
                                      },
                                      child: StreamBuilder(
                                          stream: messageService
                                              .getChatPoolSnapshot(chatID),
                                          builder: (_,
                                              AsyncSnapshot<Event>
                                                  lastMessageSnap) {
                                            if (lastMessageSnap.hasData) {
                                              Map lastMessagemap =
                                                  lastMessageSnap
                                                      .data.snapshot.value;

                                              String message =
                                                  lastMessagemap["message"];

                                              String formattedTime = DateFormat(
                                                      'kk:mm')
                                                  .format(DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          lastMessagemap[
                                                              "createdAt"]));

                                              return Row(
                                                children: <Widget>[
                                                  Container(
                                                    height: heightSize(7),
                                                    width: widthSize(14),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image:
                                                            NetworkImage(url),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: widthSize(3),
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        "$userName",
                                                        style: TextStyle(
                                                          fontFamily: "Zona",
                                                          fontSize:
                                                              heightSize(2.5),
                                                          color: MyColors()
                                                              .loginGreyColor,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: widthSize(62),
                                                        child: Text(
                                                          message,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            height:
                                                                heightSize(0.2),
                                                            fontFamily:
                                                                "ZonaLight",
                                                            fontSize:
                                                                heightSize(2),
                                                            color: MyColors()
                                                                .greyTextColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    formattedTime,
                                                    style: TextStyle(
                                                      height: heightSize(0.2),
                                                      fontFamily: "ZonaLight",
                                                      fontSize: heightSize(2),
                                                      color: MyColors()
                                                          .greyTextColor,
                                                    ),
                                                  )
                                                ],
                                              );
                                            } else
                                              return Text("null");
                                          }),
                                    );
                                    break;
                                  case ConnectionState.none:
                                    return Center(child: Text("Hata"));
                                  case ConnectionState.waiting:
                                    return PageComponents(context)
                                        .loadingCustomOverlay(
                                            spinColor:
                                                MyColors().blueThemeColor,
                                            spinSize: 40);
                                  default:
                                    return Center(
                                        child: Text("Beklenmedik durum"));
                                }
                              });
                        }),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

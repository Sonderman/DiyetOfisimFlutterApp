import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diyet_ofisim/Pages/Components/CustomScroll.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Tools/NewMessage.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:diyet_ofisim/assets/Colors.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
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
      appBar: AppBar(
        title: const Text("Görüşmeler", style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            SizedBox(height: heightSize(5)),
            chatRows(),
            SizedBox(height: heightSize(5)),
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
              stream: messageService.getUserChatsSnapshot(userService.userModel.id),
              builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return PageComponents(context).loadingOverlay(backgroundColor: Colors.white);
                } else if (snapshot.data == null) {
                  return const Center(child: Text("Henüz Görüşme Yapmadınız."));
                } else {
                  int itemLength = snapshot.data!.size;
                  List<Map<String, dynamic>> items = [];
                  List<String> chatIds = [];
                  for (var e in snapshot.data!.docs) {
                    chatIds.add(e.id);
                    items.add(e.data());
                  }

                  return ScrollConfiguration(
                    behavior: NoScrollEffectBehavior(),
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(height: 50),
                      itemCount: itemLength,
                      itemBuilder: (context, index) {
                        String otherUserID = items[index]['OtherUserID'];
                        String chatID = chatIds[index];

                        return FutureBuilder(
                          future: userService.findUserByID(otherUserID),
                          builder: (context, snap) {
                            switch (snap.connectionState) {
                              case ConnectionState.done:
                                String url = snap.data!['ProfilePhotoUrl'];
                                String userName = snap.data!['Name'];

                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => NewMessage(
                                          otherUserID: otherUserID,
                                          otherUserName: userName,
                                        ),
                                      ),
                                    );
                                  },
                                  child: StreamBuilder(
                                    stream: messageService.getChatPoolSnapshot(chatID),
                                    builder:
                                        (
                                          _,
                                          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                                          lastMessageSnap,
                                        ) {
                                          if (lastMessageSnap.hasData) {
                                            Map lastMessagemap = lastMessageSnap.data!.data()!;

                                            String message =
                                                lastMessagemap["LastMessage"]["Message"];

                                            String formattedTime = DateFormat('kk:mm').format(
                                              DateTime.fromMillisecondsSinceEpoch(
                                                int.parse(
                                                  lastMessagemap["LastMessage"]["createdAt"],
                                                ),
                                              ),
                                            );

                                            return Row(
                                              children: <Widget>[
                                                Container(
                                                  height: heightSize(7),
                                                  width: widthSize(14),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(url),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: widthSize(3)),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      userName,
                                                      style: TextStyle(
                                                        fontFamily: "Zona",
                                                        fontSize: heightSize(2.5),
                                                        color: MyColors().loginGreyColor,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: widthSize(62),
                                                      child: Text(
                                                        message,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          height: heightSize(0.2),
                                                          fontFamily: "ZonaLight",
                                                          fontSize: heightSize(2),
                                                          color: MyColors().greyTextColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(),
                                                Text(
                                                  formattedTime,
                                                  style: TextStyle(
                                                    height: heightSize(0.2),
                                                    fontFamily: "ZonaLight",
                                                    fontSize: heightSize(2),
                                                    color: MyColors().greyTextColor,
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else {
                                            return const Text("null");
                                          }
                                        },
                                  ),
                                );

                              case ConnectionState.none:
                                return const Center(child: Text("Hata"));
                              case ConnectionState.waiting:
                                return PageComponents(context).loadingCustomOverlay(
                                  spinColor: MyColors().blueThemeColor,
                                  spinSize: 40,
                                );
                              default:
                                return const Center(child: Text("Beklenmedik durum"));
                            }
                          },
                        );
                      },
                    ),
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

import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: heightSize(5),
            ),
            //chatRows(),
            SizedBox(
              height: heightSize(5),
            ),
          ],
        ),
      ),
    );
  }

/*
  Widget chatRows() {
    var messageService = Provider.of<MessagingService>(context);
    var userService = Provider.of<UserService>(context);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Mesajlar",
            style: TextStyle(
              fontFamily: "Zona",
              fontSize: heightSize(3),
              color: MyColors().loginGreyColor,
            ),
          ),
          SizedBox(
            height: heightSize(3),
          ),
          Expanded(
            child: StreamBuilder(
              stream: messageService
                  .getUserChatsSnapshot(userService.userModel.getUserId()),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return PageComponents(context)
                      .loadingOverlay(backgroundColor: Colors.white);
                } else {
                  List<DocumentSnapshot> items = snapshot.data.documents;
                  int itemLength = items.length;
                  return ScrollConfiguration(
                    behavior: NoScrollEffectBehavior(),
                    child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(
                              height: 50,
                            ),
                        itemCount: itemLength,
                        itemBuilder: (context, index) {
                          String otherUserID = items[index].data['OtherUserID'];
                          String chatID = items[index].documentID;
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
                                          builder: (_, lastMessageSnap) {
                                            if (lastMessageSnap.hasData) {
                                              var lastMessagemap =
                                                  lastMessageSnap.data;
                                              String message =
                                                  lastMessagemap["LastMessage"]
                                                      ["Message"];

                                              String formattedTime = DateFormat(
                                                      'kk:mm')
                                                  .format(DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          lastMessagemap[
                                                                  "LastMessage"]
                                                              ["createdAt"]));

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
*/

}

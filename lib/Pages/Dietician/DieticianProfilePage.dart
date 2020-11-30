import 'package:diyet_ofisim/Models/Dietician.dart';
import 'package:diyet_ofisim/Pages/Components/CommentsPageDetails.dart';
import 'package:diyet_ofisim/Pages/LoginPage.dart';
import 'package:diyet_ofisim/Services/AuthService.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Settings/AppSettings.dart';
import 'package:diyet_ofisim/Tools/Dialogs.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:diyet_ofisim/assets/Colors.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class DieticianProfilePage extends StatefulWidget {
  final String userID;
  DieticianProfilePage({Key key, this.userID}) : super(key: key);

  @override
  _DieticianProfilePageState createState() => _DieticianProfilePageState();
}

class _DieticianProfilePageState extends State<DieticianProfilePage> {
  bool loading = false;
  Dietician usermodel;
  @override
  void initState() {
    if (widget.userID == null) usermodel = locator<UserService>().userModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profilim"),
          centerTitle: true,
          backgroundColor: Colors.black,
          actions: [
            IconButton(
                color: Colors.blue,
                iconSize: 30,
                icon: Icon(Icons.exit_to_app_outlined),
                onPressed: () {
                  locator<AuthService>().signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginPage()));
                })
          ],
        ),
        body: DefaultTabController(
          length: 3,
          initialIndex: 0,
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.all(10),
                trailing: IconButton(
                  onPressed: () {
                    updateUserInfoDialog(context).then((value) {
                      if (value != null) if (value) {
                        print("Kaydedildi");
                      } else
                        print("İptal edildi");
                    });
                  },
                  icon: Icon(Icons.mode_edit),
                ),
                leading: FadeInImage(
                  image:
                      ExtendedNetworkImageProvider(usermodel.profilePhotoUrl),
                  placeholder: ExtendedNetworkImageProvider(
                      "https://cdn4.iconfinder.com/data/icons/small-n-flat/24/user-alt-512.png"),
                  height: 100,
                  fit: BoxFit.contain,
                ),
                title: Text(usermodel.name + " " + usermodel.surname),
                subtitle: Text("Diyetisyen"),
              ),
              TabBar(
                tabs: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "ÖZGEÇMİŞ",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "HİZMETLER",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "YORUMLAR",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    backgroundPage(),
                    servicesPage(),
                    commentsPage(),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget backgroundPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text("Hakkımda:"), Text(usermodel.about)],
    );
  }

  Widget servicesPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
            Text("Tedavi edilen hastalıklar:"),
          ] +
          List.generate(usermodel.treatments.length, (index) {
            return Text(AppSettings().diseases[usermodel.treatments[index]]);
          }),
    );
  }

  Widget commentsPage() {
    var userService = locator<UserService>();
    TextEditingController commentController = TextEditingController();
    return Column(
      children: <Widget>[
        Expanded(
          child: FutureBuilder(
              future: userService.getComments(usermodel.id),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data.length == 0) {
                    return Center(child: Text("Henüz yorum yapılmadı"));
                  } else
                    return ListView.separated(
                        //physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        separatorBuilder: (ctx, index) => SizedBox(
                            height: PageComponents(context).heightSize(3)),
                        itemBuilder: (BuildContext context, int index) {
                          return ProfileListItem(
                              jsonData: snapshot.data[index]);
                        });
                } else
                  return PageComponents(context)
                      .loadingOverlay(backgroundColor: Colors.white);
              }),
        ),
        SizedBox(
          height: PageComponents(context).heightSize(5),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Wrap(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 3, 5, 1),
                        child: TextField(
                          style: TextStyle(
                            fontFamily: "ZonaLight",
                            fontSize: PageComponents(context).heightSize(2),
                            color: MyColors().darkblueText,
                          ),
                          controller: commentController,
                          keyboardType: TextInputType.text,
                          enableInteractiveSelection: true,
                          cursorColor: MyColors().blueThemeColor,
                          maxLength: 256,
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (text) {},
                          decoration: InputDecoration(
                            labelText: 'Yorum yapın.',
                            labelStyle: TextStyle(
                              fontFamily: "ZonaLight",
                              fontSize: PageComponents(context).heightSize(2),
                              color: MyColors().darkblueText,
                            ),
                            errorStyle: TextStyle(
                              color: Colors.red,
                            ),
                            fillColor: MyColors().blueThemeColor,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: MyColors().blueThemeColor)),
                            counterText: '',
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: MyColors().blueThemeColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: MyColors().blueThemeColor),
                            ),
                          ),
                        )),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(5, 3, 5, 1),
                      child: FlatButton(
                        onPressed: () async {
                          //ANCHOR  Yorum gönderme backend işlemleri
                          if (commentController.text != "") {
                            await userService
                                .sendComment(
                                    usermodel.id, commentController.text)
                                .then((value) {
                              if (value)
                                print("Yorum yapıldı");
                              else
                                print("Yorum yapılırken hata!!");
                            });
                            setState(() {
                              commentController.text = '';
                            });

                            /* nestedScrollController.jumpTo(
                                nestedScrollController
                                        .position.maxScrollExtent
                                    );*/
                          }
                        },
                        child: Text(
                          "Gönder",
                          style: TextStyle(
                            fontFamily: "Zona",
                            fontSize: PageComponents(context).heightSize(2),
                            color: MyColors().darkblueText,
                          ),
                        ),
                      ))
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: PageComponents(context).heightSize(5),
        )
      ],
    );
  }
}

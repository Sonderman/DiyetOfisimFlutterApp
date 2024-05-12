import 'package:diyet_ofisim/Models/Dietician.dart';
import 'package:diyet_ofisim/Pages/Components/commentsPageDetails.dart';
import 'package:diyet_ofisim/Pages/loginSignupPage.dart';
import 'package:diyet_ofisim/Pages/Patient/AppointmentCalendarPage.dart';
import 'package:diyet_ofisim/Services/AuthService.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Settings/AppSettings.dart';
import 'package:diyet_ofisim/Tools/Dialogs.dart';
import 'package:diyet_ofisim/Tools/NavigationManager.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:diyet_ofisim/assets/Colors.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'DieticianProfileEdit.dart';

class DieticianProfilePage extends StatefulWidget {
  final String? userID;

  const DieticianProfilePage({super.key, this.userID});

  @override
  State<DieticianProfilePage> createState() => _DieticianProfilePageState();
}

class _DieticianProfilePageState extends State<DieticianProfilePage>
    with SingleTickerProviderStateMixin {
  bool loading = false, canEdit = false;
  late TabController tabController;
  late Dietician usermodel;
  late UserService userService;

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    userService = locator<UserService>();
    loading = true;
    if (widget.userID != null) {
      locator<UserService>().findUserByID(widget.userID!).then((userdata) {
        usermodel = Dietician(id: widget.userID!);
        usermodel.parseMap(userdata!);

        setState(() {
          loading = false;
        });
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.userID != null
          ? null
          : AppBar(
              title: const Text(
                "Profilim",
                style: TextStyle(fontSize: 24),
              ),
              //centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                    color: Colors.deepPurpleAccent[100],
                    iconSize: 30,
                    icon: const Icon(Icons.exit_to_app_outlined),
                    onPressed: () {
                      locator<AuthService>().signOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const LoginSignupPage()));
                    })
              ],
            ),
      body: loading
          ? PageComponents(context).loadingOverlay()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Back Arrow Container
                Visibility(
                  visible: usermodel.id != locator<UserService>().userModel.id,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                            Colors.deepPurpleAccent.shade100.withOpacity(0.7),
                      ),
                      margin: const EdgeInsets.all(20),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_back_ios_sharp,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                //Diyetisyen Profile İmage And Name

                Material(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.all(5),
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: ClipOval(
                            child: FadeInImage(
                              image: ExtendedNetworkImageProvider(
                                  usermodel.profilePhotoUrl),
                              placeholder: const ExtendedAssetImageProvider(
                                  "assets/photo/nutri.jpg"),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 15, bottom: 5),
                              child: Text(
                                "${usermodel.name}  ${usermodel.surname}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const Text(
                              "Diyetisyen",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.grey),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            star(),
                            const SizedBox(
                              height: 5,
                            ),
                            Visibility(
                              visible: usermodel.id !=
                                  locator<UserService>().userModel.id,
                              child: MaterialButton(
                                elevation: 4,
                                color: Colors.white,
                                textColor: Colors.deepPurpleAccent.shade100,
                                padding: const EdgeInsets.all(5.0),
                                onPressed: () {
                                  userService
                                      .getAppointmentCalendar(usermodel.id)
                                      .then((map) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AppointmentCalendarPage(
                                                  calendar: map!,
                                                  dModel: usermodel,
                                                )));
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: const Text("Randevu Al"),
                              ),
                            ),
                            Visibility(
                              visible: usermodel.id ==
                                  locator<UserService>().userModel.id,
                              child: MaterialButton(
                                elevation: 4,
                                color: Colors.white,
                                textColor: Colors.deepPurpleAccent.shade100,
                                padding: const EdgeInsets.all(5.0),
                                onPressed: () {
                                  NavigationManager(context)
                                      .pushPage(const DieticianProfileEdit());
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: const Text("Profilimi Düzenle"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                tabBarMenu(),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      Container(
                        color: Colors.white,
                        child: hakkinda(),
                      ),
                      Container(
                        color: Colors.white,
                        child: ozgecmis(),
                      ),
                      Container(
                        color: Colors.white,
                        child: hizmetler(),
                      ),
                      Container(
                        color: Colors.white,
                        child: Center(
                          child: gorusler(),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                    visible:
                        usermodel.id != locator<UserService>().userModel.id,
                    child: butonBar()),
              ],
            ),
    );

    /*DefaultTabController(
                length: 3,
                initialIndex: 0,
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.all(10),
                      trailing: Visibility(
                        visible: canEdit,
                        child: IconButton(
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
                      ),
                      leading: FadeInImage(
                        image: ExtendedNetworkImageProvider(
                            usermodel.profilePhotoUrl),
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
  
  */
  }

  Widget star() {
    return Row(
      children: [
        starIcon(),
        starIcon(),
        starIcon(),
        starIcon(),
        starIcon(),
      ],
    );
  }

  Widget starIcon() {
    return Icon(
      Icons.star,
      size: 20,
      color: Colors.grey[350],
    );
  }

  Widget butonBar() {
    return Center(
      child: Container(
          clipBehavior: Clip.none,
          color: Colors.white,
          margin: const EdgeInsets.all(6.0),
          height: 42,
          width: MediaQuery.of(context).size.width - 15,
          child: ElevatedButton.icon(
            onPressed: () {
              userService.getAppointmentCalendar(usermodel.id).then((map) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AppointmentCalendarPage(
                          calendar: map!,
                          dModel: usermodel,
                        )));
              });
            },
            icon: const Icon(Icons.date_range),
            label: const Text("RANDEVU AL"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(6.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              elevation: 6.0, // Adjust as needed
            ),
          )),
    );
  }

  Widget hakkinda() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListView(
        children: const [
          Text("Hakkında",
              style: TextStyle(
                fontSize: 20,
              )),
          Divider(),
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: Colors.grey,
                size: 15,
              ),
              SizedBox(
                width: 15,
              ),
              Text("Online Danışmanlık"),
            ],
          ),
          Divider(),
          Row(
            children: [
              Icon(
                Icons.security,
                color: Colors.grey,
                size: 15,
              ),
              SizedBox(
                width: 15,
              ),
              Text("Sigortalı Hastalar"),
            ],
          ),
          Divider(),
          Row(
            children: [
              Icon(
                Icons.people_alt,
                color: Colors.grey,
                size: 15,
              ),
              SizedBox(
                width: 15,
              ),
              Text("Kabul Edilen Yaş Grubu : Yetişkin , Her yaştan çocuk"),
            ],
          ),
          Divider(),
          Row(
            children: [
              Icon(
                Icons.comment_bank,
                color: Colors.grey,
                size: 15,
              ),
              SizedBox(
                width: 15,
              ),
              Text("Banka Havalesi"),
            ],
          ),
        ],
      ),
    );
  }

  Widget hizmetler() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListView(
        children: <Widget>[
              const Text("Hizmetler",
                  style: TextStyle(
                    fontSize: 20,
                  )),
              const Divider(),
            ] +
            usermodel.treatments
                .map((e) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          forwardArrowIcon(),
                          sizedBox(),
                          Text(AppSettings().diseases[e]),
                        ],
                      ),
                    ))
                .toList(),
      ),
    );
  }

  Widget ozgecmis() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListView(
        children: [
          const Text("Özgeçmiş",
              style: TextStyle(
                fontSize: 20,
              )),
          const Divider(),
          const Row(
            children: [
              Icon(
                Icons.person,
                color: Colors.grey,
                size: 15,
              ),
              SizedBox(
                width: 15,
              ),
              Text("Hakkında"),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            usermodel.about,
            maxLines: 20,
            textAlign: TextAlign.justify,
            style: const TextStyle(color: Colors.grey),
          ),
          const Divider(),
          const Row(
            children: [
              Icon(
                Icons.school_rounded,
                color: Colors.grey,
                size: 15,
              ),
              SizedBox(
                width: 15,
              ),
              Text("Okullar/Eğitimler"),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Text(usermodel.education, style: const TextStyle(color: Colors.grey)),
          const Divider(),
          const Row(
            children: [
              Icon(
                Icons.school,
                color: Colors.grey,
                size: 15,
              ),
              SizedBox(
                width: 15,
              ),
              Text("Deneyimler"),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Text(usermodel.experiences,
              style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget gorusler() {
    var userService = locator<UserService>();
    TextEditingController commentController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListView(
        children: [
          const Text("Görüşler",
              style: TextStyle(
                fontSize: 20,
              )),
          SizedBox(
            height: PageComponents(context).heightSize(2),
          ),
          FutureBuilder(
              future: userService.getComments(usermodel.id),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data!.isEmpty) {
                    return const Center(child: Text("Henüz yorum yapılmadı"));
                  } else {
                    return ListView.separated(
                        //physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        separatorBuilder: (ctx, index) => SizedBox(
                            height: PageComponents(context).heightSize(3)),
                        itemBuilder: (BuildContext context, int index) {
                          return ProfileListItem(
                              jsonData: snapshot.data![index]);
                        });
                  }
                } else {
                  return PageComponents(context)
                      .loadingOverlay(backgroundColor: Colors.white);
                }
              }),
          SizedBox(
            height: PageComponents(context).heightSize(5),
          ),
          Visibility(
            visible: !canEdit,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Wrap(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(5, 3, 5, 1),
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
                                  fontSize:
                                      PageComponents(context).heightSize(2),
                                  color: MyColors().darkblueText,
                                ),
                                errorStyle: const TextStyle(
                                  color: Colors.red,
                                ),
                                fillColor: MyColors().blueThemeColor,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyColors().blueThemeColor)),
                                counterText: '',
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: MyColors().blueThemeColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: MyColors().blueThemeColor),
                                ),
                              ),
                            )),
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(5, 3, 5, 1),
                          child: TextButton(
                            onPressed: () async {
                              // Yorum gönderme backend işlemleri
                              if (commentController.text != "") {
                                await userService
                                    .sendComment(
                                        usermodel.id, commentController.text)
                                    .then((value) {
                                  if (value) {
                                    if (kDebugMode) {
                                      print("Yorum yapıldı");
                                    }
                                  } else {
                                    if (kDebugMode) {
                                      print("Yorum yapılırken hata!!");
                                    }
                                  }
                                });
                                setState(() {
                                  commentController.text = '';
                                });
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
          ),
          SizedBox(
            height: PageComponents(context).heightSize(5),
          )
        ],
      ),
    );
  }

  Widget forwardArrowIcon() {
    return const Icon(
      Icons.arrow_forward_ios,
      color: Colors.grey,
      size: 15,
    );
  }

  Widget sizedBox() {
    return const SizedBox(
      width: 15,
    );
  }

  Widget tabBarMenu() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TabBar(
        indicatorWeight: 4,
        indicatorColor: Colors.white,
        controller: tabController,
        tabs: const [
          Tab(
            child: Text(
              "Hakkında",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Tab(
            child: Text(
              "Özgeçmiş",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Tab(
            child: Text(
              "Hizmetler",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Tab(
            child: Text(
              "Görüşler",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  Widget backgroundPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: const Text("Hakkımda:"),
          trailing: Visibility(
            visible: canEdit,
            child: IconButton(
              onPressed: () {
                updateUserAboutDialog(context).then((value) {
                  if (value) {
                    setState(() {
                      print("Kaydedildi");
                    });
                  } else {
                    print("İptal edildi");
                  }
                });
              },
              icon: const Icon(Icons.mode_edit),
            ),
          ),
        ),
        ListTile(
          title: Text(usermodel.about),
        )
      ],
    );
  }

  Widget servicesPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
            ListTile(
              title: const Text("Tedavi edilen hastalıklar:"),
              trailing: Visibility(
                visible: canEdit,
                child: IconButton(
                  onPressed: () {
                    updateUserTreatmentsDialog(context).then((value) {
                      if (value) {
                        setState(() {
                          print("Kaydedildi");
                        });
                      } else {
                        print("İptal edildi");
                      }
                    });
                  },
                  icon: const Icon(Icons.mode_edit),
                ),
              ),
            )
          ] +
          List.generate(usermodel.treatments.length, (index) {
            return ListTile(
              title: Text(AppSettings().diseases[usermodel.treatments[index]]),
            );
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
                  if (snapshot.data!.isEmpty) {
                    return const Center(child: Text("Henüz yorum yapılmadı"));
                  } else {
                    return ListView.separated(
                        //physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        separatorBuilder: (ctx, index) => SizedBox(
                            height: PageComponents(context).heightSize(3)),
                        itemBuilder: (BuildContext context, int index) {
                          return ProfileListItem(
                              jsonData: snapshot.data![index]);
                        });
                  }
                } else {
                  return PageComponents(context)
                      .loadingOverlay(backgroundColor: Colors.white);
                }
              }),
        ),
        SizedBox(
          height: PageComponents(context).heightSize(5),
        ),
        Visibility(
          visible: !canEdit,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Wrap(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 3, 5, 1),
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
                              errorStyle: const TextStyle(
                                color: Colors.red,
                              ),
                              fillColor: MyColors().blueThemeColor,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyColors().blueThemeColor)),
                              counterText: '',
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(
                                    width: 1, color: MyColors().blueThemeColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(
                                    width: 1, color: MyColors().blueThemeColor),
                              ),
                            ),
                          )),
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(5, 3, 5, 1),
                        child: TextButton(
                          onPressed: () async {
                            // Yorum gönderme backend işlemleri
                            if (commentController.text != "") {
                              await userService
                                  .sendComment(
                                      usermodel.id, commentController.text)
                                  .then((value) {
                                if (value) {
                                  if (kDebugMode) {
                                    print("Yorum yapıldı");
                                  }
                                } else {
                                  if (kDebugMode) {
                                    print("Yorum yapılırken hata!!");
                                  }
                                }
                              });
                              setState(() {
                                commentController.text = '';
                              });
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
        ),
        SizedBox(
          height: PageComponents(context).heightSize(5),
        )
      ],
    );
  }
}

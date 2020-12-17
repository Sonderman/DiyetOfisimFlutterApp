import 'package:diyet_ofisim/Models/Dietician.dart';
import 'package:diyet_ofisim/Pages/Components/CommentsPageDetails.dart';
import 'package:diyet_ofisim/Pages/LoginSignupPage.dart';
import 'package:diyet_ofisim/Pages/Patient/randevuTakvimi.dart';
import 'package:diyet_ofisim/Services/AuthService.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Settings/AppSettings.dart';
import 'package:diyet_ofisim/Tools/Dialogs.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:diyet_ofisim/assets/Colors.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:flutter/material.dart';

class DieticianProfilePage extends StatefulWidget {
  final String userID;
  DieticianProfilePage({Key key, this.userID}) : super(key: key);

  @override
  _DieticianProfilePageState createState() => _DieticianProfilePageState();
}

class _DieticianProfilePageState extends State<DieticianProfilePage>
    with SingleTickerProviderStateMixin {
  bool loading = false, canEdit = false;
  TabController tabController;
  Dietician usermodel;

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    if (widget.userID == null) {
      usermodel = locator<UserService>().userModel;
      canEdit = true;
    } else {
      loading = true;
      locator<UserService>().findUserByID(widget.userID).then((userdata) {
        usermodel = Dietician(id: widget.userID);
        usermodel.parseMap(userdata);

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
                              builder: (BuildContext context) =>
                                  LoginSignupPage()));
                    })
              ],
            ),
      body: loading
          ? PageComponents(context).loadingOverlay()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Back Arrow Container
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.deepPurpleAccent.shade100.withOpacity(0.7),
                    ),
                    margin: EdgeInsets.all(20),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.arrow_back_ios_sharp,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                SizedBox(height: 10),

                //Diyetisyen Profile İmage And Name

                Material(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.all(5),
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/photo/nutri.jpg"),
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 15, bottom: 5),
                              child: Text(
                                "Uzm. Dyt. Rumeysa Ayvalı",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Text(
                              "Diyetisyen",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            star(),
                            SizedBox(
                              height: 5,
                            ),
                            MaterialButton(
                              elevation: 4,
                              color: Colors.white,
                              textColor: Colors.deepPurpleAccent.shade100,
                              padding: const EdgeInsets.all(5.0),
                              child: Text("Randevu Al"),
                              onPressed: () {
                                setState(() {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => RandevuTakvimi()));
                                });
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
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
                butonBar(),
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
        margin: EdgeInsets.all(6.0),
        height: 42,
        width: MediaQuery.of(context).size.width - 15,
        child: RaisedButton.icon(
          elevation: 6,
          textColor: Colors.white,
          color: Colors.deepPurpleAccent[100],
          padding: const EdgeInsets.all(6.0),
          icon: Icon(Icons.date_range),
          label: Text("RANDEVU AL"),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => RandevuTakvimi()));
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
      ),
    );
  }

  Widget hakkinda() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListView(
        children: [
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
        children: [
          Text("Hizmetler",
              style: TextStyle(
                fontSize: 20,
              )),
          Divider(),
          Row(
            children: [
              forwardArrowIcon(),
              sizedBox(),
              Text("Anoreksiya ve Bulimia Hastalarında Beslenme"),
            ],
          ),
          Divider(
            height: 10,
          ),
          Row(
            children: [
              forwardArrowIcon(),
              sizedBox(),
              Text("Bebek Beslenmesi"),
            ],
          ),
          Divider(),
          Row(
            children: [
              forwardArrowIcon(),
              sizedBox(),
              Text("Diyabet Diyeti"),
            ],
          ),
          Divider(),
          Row(
            children: [
              forwardArrowIcon(),
              sizedBox(),
              Text("Gut Hastalığında Beslenme"),
            ],
          ),
        ],
      ),
    );
  }

  Widget ozgecmis() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListView(
        children: [
          Text("Özgeçmiş",
              style: TextStyle(
                fontSize: 20,
              )),
          Divider(),
          Row(
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
          SizedBox(
            height: 15,
          ),
          Text(
            "Gaziantep'te dünyaya geldim. İlk ve orta öğrenimimi orada tamamladım. 2009 yılında Hacettepe Üniversitesi Beslenme ve Diyetetik bölümüne büyük bir heves ile başladım. Mezun olmadan önce çeşitli spor salonlarında ve Diyet Polikliniklerinde gönüllü staj görevimi yaptım. 2013 yılında Hacettepe Üniversitesi'nden mezun olduktan sonra Spor Merkezleri ve özel kliniklerde bireysel danışmanlık hizmeti verdim. Bu hizmetler sayesinde poliklinik hizmeti anlamında kendimi oldukça geliştirdim. Hastanın yaşadığı psikolojik durum, baskı, sosyal etmenler üzerinde gözlemler yapmaya başladım. Ardından Özel Çankaya Hastanesi'nde ve Özel Ankara Umut Hastanesi'nde görev aldım. Bu sayede hem yatan hem de ayaktan hastalara hizmet vererek tecrübelerimi arttırdım. Şimdilerde Ankara'da yaşayan danışanlarıma; Diyetisyen Sinem Akgün Diyet ve Beslenme Danışmanlığı Merkezinde, Ankara dışında yaşayan danışanlarıma ise internet veya telefon aracılığıyla hizmet vermekteyim.",
            maxLines: 20,
            textAlign: TextAlign.justify,
            style: TextStyle(color: Colors.grey),
          ),
          Divider(),
          Row(
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
          SizedBox(
            height: 15,
          ),
          Text("Hacettepe Üniversitesi", style: TextStyle(color: Colors.grey)),
          Divider(),
          Row(
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
          SizedBox(
            height: 15,
          ),
          Text(
              "Diyetisyen Sinem Akgün Diyet ve Beslenme Danışmanlığı Merkezi\nÖzel Ankara Umut Hastanesi (2015)\nMost Life Club Spor Merkezi (2013)",
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget gorusler() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListView(
        children: [
          Text("Görüşler",
              style: TextStyle(
                fontSize: 20,
              )),
          Divider(),
        ],
      ),
    );
  }

  Widget forwardArrowIcon() {
    return Icon(
      Icons.arrow_forward_ios,
      color: Colors.grey,
      size: 15,
    );
  }

  Widget sizedBox() {
    return SizedBox(
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
        controller: tabController,
        tabs: [
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
          title: Text("Hakkımda:"),
          trailing: Visibility(
            visible: canEdit,
            child: IconButton(
              onPressed: () {
                updateUserAboutDialog(context).then((value) {
                  if (value != null) if (value) {
                    setState(() {
                      print("Kaydedildi");
                    });
                  } else
                    print("İptal edildi");
                });
              },
              icon: Icon(Icons.mode_edit),
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
              title: Text("Tedavi edilen hastalıklar:"),
              trailing: Visibility(
                visible: canEdit,
                child: IconButton(
                  onPressed: () {
                    updateUserTreatmentsDialog(context).then((value) {
                      if (value != null) if (value) {
                        setState(() {
                          print("Kaydedildi");
                        });
                      } else
                        print("İptal edildi");
                    });
                  },
                  icon: Icon(Icons.mode_edit),
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
        ),
        SizedBox(
          height: PageComponents(context).heightSize(5),
        )
      ],
    );
  }
}

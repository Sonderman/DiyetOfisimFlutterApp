import 'dart:typed_data';
import 'package:diyet_ofisim/Models/Dietician.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Settings/AppSettings.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:diyet_ofisim/Tools/imagePicker.dart';
import 'package:diyet_ofisim/assets/Colors.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

Future<bool> appointmentCancelAsking(mycontext) {
  return showDialog(
      context: mycontext,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          title: Text(
            "Uyarı",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.redAccent[400]),
          ),
          content:
              Text("Randevunuzu İptal Etmek İstediğinize \nEmin misiniz ? "),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          actions: <Widget>[
            Container(
              width: 150,
              child: MaterialButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text(
                  "Vazgeç".toUpperCase(),
                  style: TextStyle(
                      color: Colors.deepPurpleAccent.shade100, fontSize: 15),
                ),
                //color: Colors.white,
              ),
            ),
            Container(
              width: 150,
              child: MaterialButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(
                  "Evet".toUpperCase(),
                  style: TextStyle(
                      color: Colors.deepPurpleAccent.shade100, fontSize: 15),
                ),
                //color: Colors.white,
              ),
            ),
          ],
        );
      });
}

Future<bool> updateUserInfoDialog(BuildContext context) {
  Uint8List image;
  var user = locator<UserService>().userModel;
  TextEditingController nameController = TextEditingController(text: user.name);
  TextEditingController surnameController =
      TextEditingController(text: user.surname);
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Güncellemek istediğiniz bilgileri doldurunuz"),
            contentPadding: EdgeInsets.all(15),
            content: StatefulBuilder(
              builder: (BuildContext ctx, StateSetter setState) {
                return Container(
                  height: PageComponents(context).heightSize(50),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          image = await showImageSelectionDialog(context)
                              .whenComplete(() {
                            setState(() {});
                          });
                        },
                        child: Container(
                          width: PageComponents(context).widthSize(20),
                          height: PageComponents(context).widthSize(20),
                          /*
        decoration: BoxDecoration(
          color: MyColors().orangeContainer,
          shape: BoxShape.circle,
        ),*/
                          child: CircleAvatar(
                            backgroundColor: MyColors().orangeContainer,
                            radius: 100,
                            child: image == null
                                ? Image.asset(
                                    'assets/images/add-user.png',
                                    height:
                                        PageComponents(context).heightSize(5),
                                  )
                                : ClipOval(
                                    child: Image.memory(
                                      image,
                                      width:
                                          PageComponents(context).widthSize(20),
                                      height:
                                          PageComponents(context).widthSize(20),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      Align(
                        child: Text("Adınız:"),
                        alignment: Alignment.topLeft,
                      ),
                      TextFormField(
                        controller: nameController,
                      ),
                      Align(
                        child: Text("Soyadınız:"),
                        alignment: Alignment.topLeft,
                      ),
                      TextFormField(
                        controller: surnameController,
                      ),
                    ],
                  ),
                );
              },
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text("İptal")),
              FlatButton(
                  onPressed: () {
                    user.name = nameController.text;
                    user.surname = surnameController.text;
                    locator<UserService>()
                        .updateUserProfile(image: image)
                        .then((value) {
                      if (value) {
                        Navigator.pop(context, true);
                      }
                    });
                  },
                  child: Text("Kaydet"))
            ],
          ));
}

Future<bool> updateUserAboutDialog(BuildContext context) {
  Dietician user = locator<UserService>().userModel;
  TextEditingController aboutController =
      TextEditingController(text: user.about);

  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            contentPadding: EdgeInsets.all(15),
            content: Container(
              height: PageComponents(context).heightSize(50),
              width: PageComponents(context).widthSize(70),
              child: Column(children: [
                Align(
                  child: Text("Hakkımda:"),
                  alignment: Alignment.topLeft,
                ),
                TextFormField(
                  controller: aboutController,
                  maxLines: 8,
                  minLines: 1,
                ),
              ]),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text("İptal")),
              FlatButton(
                  onPressed: () {
                    user.about = aboutController.text;
                    locator<UserService>().updateUserProfile().then((value) {
                      if (value) {
                        Navigator.pop(context, true);
                      }
                    });
                  },
                  child: Text("Kaydet"))
            ],
          ));
}

Future<bool> updateUserTreatmentsDialog(BuildContext context) {
  Dietician user = locator<UserService>().userModel;
  List diseases;

  List<Map> dataParser() {
    List<Map> temp = [];
    num i = 0;
    AppSettings().diseases.forEach((e) {
      temp.add({
        "title": e,
        "value": i,
      });
      i++;
    });
    return temp;
  }

  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            contentPadding: EdgeInsets.all(15),
            content: StatefulBuilder(
              builder: (BuildContext ctx, StateSetter setState) {
                return Container(
                  height: PageComponents(context).heightSize(50),
                  width: PageComponents(context).widthSize(70),
                  child: Column(
                    children: [
                      Align(
                        child: Text("Tedavi Edebildiğim Hastalıklar:"),
                        alignment: Alignment.topLeft,
                      ),
                      SizedBox(
                        height: PageComponents(context).heightSize(10),
                      ),
                      MultiSelectFormField(
                        chipBackGroundColor: Colors.green,
                        chipLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                        dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
                        checkBoxActiveColor: Colors.blue,
                        checkBoxCheckColor: Colors.black,
                        dialogShapeBorder: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),
                        title: Text(
                          "Tedavi edebileceğiniz hastalıklar",
                          style: TextStyle(fontSize: 16),
                        ),
                        dataSource: dataParser(),
                        textField: 'title',
                        valueField: 'value',
                        okButtonLabel: 'TAMAM',
                        cancelButtonLabel: 'İPTAL',
                        hintWidget:
                            Text('Lütfen bir veya daha fazla hastalık seçiniz'),
                        onSaved: (value) {
                          if (value == null) return;
                          setState(() {
                            diseases = value;
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text("İptal")),
              FlatButton(
                  onPressed: () {
                    user.treatments = diseases;
                    locator<UserService>()
                        .updateUserProfile(isUpdatingTreatments: true)
                        .then((value) {
                      if (value) {
                        Navigator.pop(context, true);
                      }
                    });
                  },
                  child: Text("Kaydet"))
            ],
          ));
}

Future<Uint8List> showImageSelectionDialog(BuildContext context) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context2) {
        return AlertDialog(
          title: Text(
            'Bir Seçim Yapınız',
            style: TextStyle(
              fontSize: PageComponents(context2).heightSize(2.5),
              fontFamily: "Zona",
              color: MyColors().loginGreyColor,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                    child: Text(
                      'Galeri',
                    ),
                    onTap: () {
                      getImageFromGallery(context2).then((value) {
                        Navigator.pop(context2, value);
                      });
                    }),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                    child: Text(
                      'Kamera',
                    ),
                    onTap: () {
                      getImageFromCamera(context2).then((value) {
                        Navigator.pop(context2, value);
                      });
                    }),
              ],
            ),
          ),
        );
      });
}

Future<bool> askForQuit(BuildContext context) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
          title: Text("Uygulamadan Çıkmak istiyormusunuz?"),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Hayır")),
            FlatButton(
                onPressed: () {
                  SystemNavigator.pop();
                  //Navigator.pop(context);
                },
                child: Text("Evet"))
          ],
        ));

Future<bool> askingDialog(
    BuildContext context, String title, Color backgroundColor) {
  return showDialog(
      context: context,
      builder: (dcontext) {
        return AlertDialog(
          title: Text(title),
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(dcontext, false);
              },
              child: Text(
                "Hayır",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(dcontext, true);
              },
              child: Text(
                "Evet",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      });
}

Future<bool> feedbackDialog(
  BuildContext context,
) {
  return showDialog(
      context: context,
      builder: (dcontext) {
        TextEditingController controller = TextEditingController();
        var responsive = PageComponents(dcontext);
        // UserService userService =
        //    Provider.of<UserService>(context, listen: false);
        return AlertDialog(
          title: Center(child: Text("Sorun Bildir")),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: responsive.widthSize(80),
                child: TextFormField(
                  controller: controller,
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.multiline,
                  enableInteractiveSelection: true,
                  minLines: 1,
                  maxLines: 10,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    alignLabelWithHint: true,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: MyColors().loginGreyColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: MyColors().loginGreyColor),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: responsive.heightSize(2.5),
                    fontFamily: "ZonaLight",
                    color: MyColors().loginGreyColor,
                  ),
                ),
              ),
              SizedBox(
                height: responsive.heightSize(2),
              ),
              FlatButton(
                onPressed: () {
                  /*
                  if (controller.text != "")
                    userService.sendFeedback(controller.text).then((value) {
                      if (value) {
                        Navigator.pop(dcontext, true);
                        Fluttertoast.showToast(
                            msg:
                                "Geri Bildiriminiz Gönderilmiştir Teşekkür Ederiz.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 18.0);
                      }
                    });
                
                */
                },
                color: Colors.green,
                child: Text(
                  "Gönder",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        );
      });
}

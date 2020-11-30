import 'dart:typed_data';
import 'package:diyet_ofisim/Models/Dietician.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:diyet_ofisim/Tools/imagePicker.dart';
import 'package:diyet_ofisim/assets/Colors.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<bool> updateUserInfoDialog(BuildContext context) {
  Uint8List image;
  Dietician user = locator<UserService>().userModel;
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

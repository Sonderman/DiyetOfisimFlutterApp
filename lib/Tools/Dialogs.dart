import 'package:diyet_ofisim/Models/Appointment.dart';
import 'package:diyet_ofisim/Models/Dietician.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Settings/AppSettings.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:diyet_ofisim/Tools/imagePicker.dart';
import 'package:diyet_ofisim/assets/Colors.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

Future<bool> appointmentCancelAsking(
    BuildContext mycontext, Appointment aModel) {
  UserService userService = locator<UserService>();
  return showDialog(
      context: mycontext,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          title: Text(
            "Uyarı",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.redAccent[400]),
          ),
          content: const Text(
              "Randevunuzu İptal Etmek İstediğinize \nEmin misiniz ? "),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          actions: <Widget>[
            SizedBox(
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
            SizedBox(
              width: 150,
              child: MaterialButton(
                onPressed: () {
                  userService.updateAppointmentStatus(aModel, 2).then((r) {
                    if (r) {
                      Navigator.pop(context, true);
                    } else {
                      if (kDebugMode) {
                        print("Randevu silerken hata");
                      }
                    }
                  });
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
      }).then((value) {
    if (value == null) {
      return false;
    } else {
      return value;
    }
  });
}

Future<bool> updateUserInfoDialog(BuildContext context) {
  Uint8List? image;
  var user = locator<UserService>().userModel;
  TextEditingController nameController = TextEditingController(text: user.name);
  TextEditingController surnameController =
      TextEditingController(text: user.surname);
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Güncellemek istediğiniz bilgileri doldurunuz"),
            contentPadding: const EdgeInsets.all(15),
            content: StatefulBuilder(
              builder: (BuildContext ctx, StateSetter setState) {
                return SizedBox(
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
                        child: SizedBox(
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
                                      image!,
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
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Adınız:"),
                      ),
                      TextFormField(
                        controller: nameController,
                      ),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Soyadınız:"),
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
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text("İptal")),
              ElevatedButton(
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
                  child: const Text("Kaydet"))
            ],
          )).then((value) {
    if (value == null) {
      return false;
    } else {
      return value;
    }
  });
}

Future<bool> updateUserAboutDialog(BuildContext context) {
  Dietician user = locator<UserService>().userModel;
  TextEditingController aboutController =
      TextEditingController(text: user.about);

  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            contentPadding: const EdgeInsets.all(15),
            content: SizedBox(
              height: PageComponents(context).heightSize(50),
              width: PageComponents(context).widthSize(70),
              child: Column(children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text("Hakkımda:"),
                ),
                TextFormField(
                  controller: aboutController,
                  maxLines: 8,
                  minLines: 1,
                ),
              ]),
            ),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text("İptal")),
              ElevatedButton(
                  onPressed: () {
                    user.about = aboutController.text;
                    locator<UserService>().updateUserProfile().then((value) {
                      if (value) {
                        Navigator.pop(context, true);
                      }
                    });
                  },
                  child: const Text("Kaydet"))
            ],
          )).then((value) {
    if (value == null) {
      return false;
    } else {
      return value;
    }
  });
}

Future<bool> updateUserTreatmentsDialog(BuildContext context) {
  Dietician user = locator<UserService>().userModel;
  List diseases = [];

  List<Map> dataParser() {
    List<Map> temp = [];
    num i = 0;
    for (var e in AppSettings().diseases) {
      temp.add({
        "title": e,
        "value": i,
      });
      i++;
    }
    return temp;
  }

  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            contentPadding: const EdgeInsets.all(15),
            content: StatefulBuilder(
              builder: (BuildContext ctx, StateSetter setState) {
                return SizedBox(
                  height: PageComponents(context).heightSize(50),
                  width: PageComponents(context).widthSize(70),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Tedavi Edebildiğim Hastalıklar:"),
                      ),
                      SizedBox(
                        height: PageComponents(context).heightSize(10),
                      ),
                      MultiSelectFormField(
                        chipBackGroundColor: Colors.green,
                        chipLabelStyle:
                            const TextStyle(fontWeight: FontWeight.bold),
                        dialogTextStyle:
                            const TextStyle(fontWeight: FontWeight.bold),
                        checkBoxActiveColor: Colors.blue,
                        checkBoxCheckColor: Colors.black,
                        dialogShapeBorder: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),
                        title: const Text(
                          "Tedavi edebileceğiniz hastalıklar",
                          style: TextStyle(fontSize: 16),
                        ),
                        dataSource: dataParser(),
                        textField: 'title',
                        valueField: 'value',
                        okButtonLabel: 'TAMAM',
                        cancelButtonLabel: 'İPTAL',
                        hintWidget: const Text(
                            'Lütfen bir veya daha fazla hastalık seçiniz'),
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
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text("İptal")),
              ElevatedButton(
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
                  child: const Text("Kaydet"))
            ],
          )).then((value) {
    if (value == null) {
      return false;
    } else {
      return value;
    }
  });
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
                    child: const Text(
                      'Galeri',
                    ),
                    onTap: () {
                      pickImage(context: context2, source: ImageSource.gallery)
                          .then((value) {
                        Navigator.pop(context2, value);
                      });
                    }),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                    child: const Text(
                      'Kamera',
                    ),
                    onTap: () {
                      pickImage(context: context2, source: ImageSource.camera)
                          .then((value) {
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
              title: const Text("Uygulamadan Çıkmak istiyormusunuz?"),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Hayır")),
                ElevatedButton(
                    onPressed: () {
                      SystemNavigator.pop();
                      //Navigator.pop(context);
                    },
                    child: const Text("Evet"))
              ],
            )).then((value) {
      if (value == null) {
        return false;
      } else {
        return value;
      }
    });

Future<bool> askingDialog(
    BuildContext context, String title, Color backgroundColor) {
  return showDialog(
      context: context,
      builder: (dcontext) {
        return AlertDialog(
          title: Text(title),
          backgroundColor: backgroundColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(dcontext, false);
                },
                child: ColorFiltered(
                  colorFilter:
                      ColorFilter.mode(backgroundColor, BlendMode.difference),
                  child: const Text(
                    "Hayır",
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                )),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(dcontext, true);
                },
                child: ColorFiltered(
                  colorFilter:
                      ColorFilter.mode(backgroundColor, BlendMode.difference),
                  child: const Text(
                    "Evet",
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                )),
          ],
        );
      }).then((value) {
    if (value == null) {
      return false;
    } else {
      return value;
    }
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
          title: const Center(child: Text("Sorun Bildir")),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
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
              ElevatedButton(
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
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.green),
                ),
                child: const Text(
                  "Gönder",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        );
      }).then((value) {
    if (value == null) {
      return false;
    } else {
      return value;
    }
  });
}

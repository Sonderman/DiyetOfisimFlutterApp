import 'dart:typed_data';
import 'package:diyet_ofisim/Models/Dietician.dart';
import 'package:diyet_ofisim/Models/Patient.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Tools/Dialogs.dart';
import 'package:diyet_ofisim/Tools/NavigationManager.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DieticianProfileEdit extends StatefulWidget {
  @override
  _DieticianProfileEditState createState() => _DieticianProfileEditState();
}

class _DieticianProfileEditState extends State<DieticianProfileEdit> {
  Dietician usermodel = locator<UserService>().userModel;
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController pass2Controller = TextEditingController();
  Uint8List image;
  bool isobs = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profilini Düzenle"),
        //centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: bodyContainer(),
    );
  }

  Widget bodyContainer() {
    return Column(
      children: [
        imageEdit(),
        SizedBox(
          height: 35,
        ),
        buildTextField(nameController, " Name", usermodel.name, false),
        buildTextField(surnameController, "SurName", usermodel.surname, false),
        //TODO - Pasword kısımları yapılacak
        buildTextField(
          passController,
          "Password",
          "**********",
          true,
        ),
        buildTextField(
          pass2Controller,
          "Password Again",
          "**********",
          true,
        ),
        SizedBox(
          height: 70,
        ),
        saveBackButtons(),
      ],
    );
  }

  Widget imageEdit() {
    return Center(
      child: Stack(
        children: [
          Positioned(
              child: ClipOval(
            child: image == null
                ? FadeInImage(
                    image:
                        ExtendedNetworkImageProvider(usermodel.profilePhotoUrl),
                    placeholder:
                        ExtendedAssetImageProvider("assets/photo/nutri.jpg"),
                    height: PageComponents(context).widthSize(30),
                    fit: BoxFit.contain,
                  )
                : Image.memory(
                    image,
                    height: PageComponents(context).widthSize(30),
                    fit: BoxFit.contain,
                  ),
          )
              /*Container(
              margin: EdgeInsets.only(top: 25), //10
              height: 130, //140
              width: 130,
              decoration: BoxDecoration(
                border: Border.all(width: 4, color: Colors.white),
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: 
                  AssetImage("assets/photo/nutri.jpg"),
                
              ),
            ),
          */
              ),
          Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                        width: 3, color: Colors.deepPurpleAccent[100]),
                    color: Colors.white),
                child: InkWell(
                  onTap: () {
                    setState(() async {
                      image = await showImageSelectionDialog(context)
                          .whenComplete(() {
                        setState(() {});
                      });
                    });
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.deepPurpleAccent[100],
                    size: 30,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String _labelText,
    String _hintText,
    bool isPasswordField,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      child: TextField(
        controller: controller,
        obscureText: isobs,
        decoration: InputDecoration(
          suffixIcon: isPasswordField
              ? IconButton(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isobs = !isobs;
                    });
                  },
                )
              : null,
          contentPadding: EdgeInsets.only(bottom: 5),
          labelText: _labelText,
          labelStyle:
              TextStyle(color: Colors.deepPurpleAccent[100], fontSize: 20),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: _hintText,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
        ),
      ),
    );
  }

  Widget saveBackButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OutlineButton(
          padding: EdgeInsets.symmetric(horizontal: 50),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: () {
            NavigationManager(context).popPage();
          },
          child: Text("GERİ DÖN",
              style: TextStyle(
                  fontSize: 14, letterSpacing: 2.2, color: Colors.black54)),
        ),
        RaisedButton(
          onPressed: () {
            usermodel.name = nameController.text;
            usermodel.surname = surnameController.text;
            locator<UserService>()
                .updateUserProfile(image: image)
                .then((value) {
              if (value) {
                Fluttertoast.showToast(
                    msg: "Bilgileriniz Başarıyla Güncellendi.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 2,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 18.0);
                NavigationManager(context).popPage();
              }
            });
          },
          color: Colors.deepPurpleAccent[100],
          padding: EdgeInsets.symmetric(horizontal: 50),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Text(
            "KAYDET",
            style: TextStyle(
                fontSize: 14, letterSpacing: 2.2, color: Colors.white),
          ),
        )
      ],
    );
  }
}

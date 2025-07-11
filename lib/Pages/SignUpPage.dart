import 'dart:math';
import 'dart:typed_data';
import 'package:diyet_ofisim/Pages/Components/CustomScroll.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Tools/imagePicker.dart';
import 'package:diyet_ofisim/Tools/loading.dart';
import 'package:diyet_ofisim/assets/Colors.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class SignUpPage extends StatefulWidget {
  final PageController pageController;

  const SignUpPage(this.pageController, {super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  Uint8List? _image;
  bool loading = false;
  String? _name, _surname, _country, _birthday;
  bool? _gender, _isDietisian = false;
  bool showPassword = true;

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
    return loading
        ? const Loading()
        : LayoutBuilder(builder: (context, constraints) {
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ScrollConfiguration(
                  behavior: NoScrollEffectBehavior(),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: heightSize(5),
                        ),
                        addPhoto(),
                        SizedBox(
                          height: heightSize(1),
                        ),
                        nameSurname(),
                        SizedBox(
                          height: heightSize(1),
                        ),
                        emailAndPasswordFields(),
                        SizedBox(
                          height: heightSize(1),
                        ),
                        constraints.maxWidth < 400
                            ? selectGenderLittle()
                            : selectGender(),
                        SizedBox(
                          height: heightSize(2),
                        ),
                        selectUserType(),
                        SizedBox(
                          height: heightSize(2),
                        ),
                        constraints.maxWidth < 400
                            ? signUpButtonLittle()
                            : signUpButton(),
                        SizedBox(
                          height: heightSize(2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Bir Seçim Yapınız',
              style: TextStyle(
                fontSize: heightSize(2.5),
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
                        pickImage(context: context, source: ImageSource.gallery)
                            .then((value) {
                          setState(() {
                            _image = value;
                            Navigator.pop(context);
                          });
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
                        pickImage(context: context, source: ImageSource.camera)
                            .then((value) {
                          setState(() {
                            _image = value;
                            Navigator.pop(context);
                          });
                        });
                      }),
                ],
              ),
            ),
          );
        });
  }

  String generateNickName(String name) {
    return name + (1 + Random().nextInt(9998)).toString();
  }

  void signUp() async {
    //ANCHOR Veritabanına kaydetmek için
    List<String> datalist = [
      _name!,
      _surname!,
      mailController.text,
      _gender! ? "Man" : "Woman",
      _isDietisian! ? "Y" : "N",
      generateNickName(_name!)
    ];
    if (kDebugMode) {
      print(datalist);
    }
    try {
      await locator<UserService>()
          .registerUser(
              mailController.text, passwordController.text, datalist, _image!)
          .then((userID) {
        if (userID != null) {
          Fluttertoast.showToast(
              msg:
                  "Hesabınız başarıyla oluşturuldu. Lütfen mailinizi doğrulayınız.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 18.0);
          widget.pageController.previousPage(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOutCubic);
        } else {
          setState(() {
            loading = false;
            if (kDebugMode) {
              print("Sign Up Failed!");
            }
          });
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      setState(() {
        loading = false;
        if (kDebugMode) {
          print("Sign Up Failed!");
        }
      });
    }
  }

  Widget addPhoto() {
    return GestureDetector(
      onTap: () {
        _showChoiceDialog(context);
      },
      child: SizedBox(
        width: widthSize(30),
        height: widthSize(30),
        /*
        decoration: BoxDecoration(
          color: MyColors().orangeContainer,
          shape: BoxShape.circle,
        ),*/
        child: CircleAvatar(
          backgroundColor: MyColors().orangeContainer,
          radius: 100,
          child: _image == null
              ? Image.asset(
                  'assets/images/add-user.png',
                  height: heightSize(5),
                )
              : ClipOval(
                  child: Image.memory(
                    _image!,
                    width: widthSize(30),
                    height: widthSize(30),
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ),
    );
  }

  Widget nameSurname() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          height: heightSize(8),
          width: widthSize(40),
          child: TextFormField(
            onChanged: (ad) => _name = ad,
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Ad*",
              hintStyle: TextStyle(
                fontFamily: "Zona",
                color: MyColors().loginGreyColor,
              ),
              alignLabelWithHint: true,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: MyColors().loginGreyColor),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: MyColors().loginGreyColor),
              ),
            ),
            style: TextStyle(
              fontSize: heightSize(2.5),
              fontFamily: "ZonaLight",
              color: MyColors().loginGreyColor,
            ),
          ),
        ),
        SizedBox(
          height: heightSize(8),
          width: widthSize(40),
          child: TextFormField(
            onChanged: (soyad) => _surname = soyad,
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Soyad*",
              hintStyle: TextStyle(
                fontFamily: "Zona",
                color: MyColors().loginGreyColor,
              ),
              alignLabelWithHint: true,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: MyColors().loginGreyColor),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: MyColors().loginGreyColor),
              ),
            ),
            style: TextStyle(
              fontSize: heightSize(2.5),
              fontFamily: "ZonaLight",
              color: MyColors().loginGreyColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget emailAndPasswordFields() {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: mailController,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Email*",
            hintStyle: TextStyle(
              fontFamily: "Zona",
              color: MyColors().loginGreyColor,
            ),
            alignLabelWithHint: true,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: MyColors().loginGreyColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: MyColors().loginGreyColor),
            ),
          ),
          style: TextStyle(
            fontSize: heightSize(2.5),
            fontFamily: "ZonaLight",
            color: MyColors().loginGreyColor,
          ),
        ),
        SizedBox(
          height: heightSize(3),
        ),
        TextFormField(
          controller: passwordController,
          obscureText: showPassword,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Şifre*",
            hintStyle: TextStyle(
              fontFamily: "Zona",
              color: MyColors().loginGreyColor,
            ),
            alignLabelWithHint: true,
            suffixIcon: TextButton(
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero, // Remove unnecessary padding
              ),
              child: Icon(
                showPassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.black, // Adjust color as needed
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: MyColors().loginGreyColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: MyColors().loginGreyColor),
            ),
          ),
          style: TextStyle(
            fontSize: heightSize(2.5),
            fontFamily: "ZonaLight",
            color: MyColors().loginGreyColor,
          ),
        ),
        SizedBox(
          height: heightSize(3),
        ),
        TextFormField(
          controller: password2Controller,
          obscureText: showPassword,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Şifre Tekrar*",
            hintStyle: TextStyle(
              fontFamily: "Zona",
              color: MyColors().loginGreyColor,
            ),
            alignLabelWithHint: true,
            suffixIcon: TextButton(
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero, // Remove unnecessary padding
              ),
              child: Icon(
                showPassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.black, // Adjust color as needed
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: MyColors().loginGreyColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: MyColors().loginGreyColor),
            ),
          ),
          style: TextStyle(
            fontSize: heightSize(2.5),
            fontFamily: "ZonaLight",
            color: MyColors().loginGreyColor,
          ),
        ),
        SizedBox(
          height: heightSize(3),
        ),
      ],
    );
  }

/*
  Widget telephoneNumber() {
    return TextFormField(
      onChanged: (phone) => _phoneNumber = phone,
      textAlign: TextAlign.left,
      keyboardType: TextInputType.number,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      maxLength: 10,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Telefon Numarası",
        hintStyle: TextStyle(
          fontFamily: "Zona",
          color: MyColors().loginGreyColor,
        ),
        alignLabelWithHint: true,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: MyColors().loginGreyColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: MyColors().loginGreyColor),
        ),
      ),
      style: TextStyle(
        fontSize: heightSize(2.5),
        fontFamily: "ZonaLight",
        color: MyColors().loginGreyColor,
      ),
    );
  }
*/
  Widget countryAndBirthDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: widthSize(43),
          height: heightSize(8),
          decoration: BoxDecoration(
            color: MyColors().yellowContainer,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Center(
              child: DropdownButton<String>(
                hint: Text(
                  _country ?? ("Ülke Seçin"),
                  style: TextStyle(
                    fontFamily: "Zona",
                    fontSize: heightSize(2),
                    color: MyColors().whiteTextColor,
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "TR",
                    child: Text("Türkiye"),
                  ),
                  DropdownMenuItem(
                    value: "US",
                    child: Text("United States"),
                  ),
                  DropdownMenuItem(
                    value: "UK",
                    child: Text("United Kingdom"),
                  ),
                ],
                onChanged: (country) {
                  setState(() {
                    _country = country;
                  });
                },
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            final datePick = await showDatePicker(
                context: context,
                initialDate: DateTime(DateTime.now().year - 18),
                firstDate: DateTime(DateTime.now().year - 70),
                lastDate: DateTime(DateTime.now().year - 18));
            if (datePick != null) {
              setState(() {
                _birthday =
                    "${datePick.day}/${datePick.month}/${datePick.year}";
              });
            }
          },
          child: Container(
            width: widthSize(43),
            height: heightSize(8),
            decoration: BoxDecoration(
              color: MyColors().yellowContainer,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                _birthday ?? "Doğum Tarihiniz",
                style: TextStyle(
                  fontFamily: "Zona",
                  fontSize: heightSize(2),
                  color: MyColors().whiteTextColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget countryAndBirthDateLittle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: widthSize(48),
          height: heightSize(8),
          decoration: BoxDecoration(
            color: MyColors().yellowContainer,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Center(
              child: DropdownButton<String>(
                hint: Text(
                  _country ?? ("Ülke Seçin"),
                  style: TextStyle(
                    fontFamily: "Zona",
                    fontSize: heightSize(2),
                    color: MyColors().whiteTextColor,
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "TR",
                    child: Text("Türkiye"),
                  ),
                  DropdownMenuItem(
                    value: "US",
                    child: Text("United States"),
                  ),
                  DropdownMenuItem(
                    value: "UK",
                    child: Text("United Kingdom"),
                  ),
                ],
                onChanged: (country) {
                  setState(() {
                    _country = country;
                  });
                },
              ),
            ),
          ),
        ),
        SizedBox(
          height: heightSize(2),
        ),
        InkWell(
          onTap: () async {
            final datePick = await showDatePicker(
                context: context,
                initialDate: DateTime(DateTime.now().year - 18),
                firstDate: DateTime(DateTime.now().year - 70),
                lastDate: DateTime(DateTime.now().year - 18));
            if (datePick != null) {
              setState(() {
                _birthday =
                    "${datePick.day}/${datePick.month}/${datePick.year}";
              });
            }
          },
          child: Container(
            width: widthSize(48),
            height: heightSize(8),
            decoration: BoxDecoration(
              color: MyColors().yellowContainer,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                _birthday ?? "Doğum Tarihiniz",
                style: TextStyle(
                  fontFamily: "Zona",
                  fontSize: heightSize(2),
                  color: MyColors().whiteTextColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget selectGender() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        InkWell(
          onTap: () {
            setState(() {
              _gender = true;
            });
          },
          child: Container(
            width: widthSize(43),
            height: heightSize(5),
            decoration: BoxDecoration(
              color: _gender != null
                  ? _gender!
                      ? menColor()
                      : Colors.grey
                  : Colors.grey,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                ("Erkek"),
                style: TextStyle(
                  fontFamily: "Zona",
                  fontSize: heightSize(2),
                  color: MyColors().whiteTextColor,
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              _gender = false;
            });
          },
          child: Container(
            width: widthSize(43),
            height: heightSize(5),
            decoration: BoxDecoration(
              color: _gender != null
                  ? _gender!
                      ? Colors.grey
                      : womenColor()
                  : Colors.grey,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                "Kadın",
                style: TextStyle(
                  fontFamily: "Zona",
                  fontSize: heightSize(2),
                  color: MyColors().whiteTextColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget selectUserType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        InkWell(
          onTap: () {
            setState(() {
              _isDietisian = false;
            });
          },
          child: Container(
            width: widthSize(43),
            height: heightSize(5),
            decoration: BoxDecoration(
              color: _isDietisian! ? Colors.grey : Colors.green,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                ("Hasta"),
                style: TextStyle(
                  fontFamily: "Zona",
                  fontSize: heightSize(2),
                  color: MyColors().whiteTextColor,
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              _isDietisian = true;
            });
          },
          child: Container(
            width: widthSize(43),
            height: heightSize(5),
            decoration: BoxDecoration(
              color: _isDietisian! ? Colors.green : Colors.grey,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                "Diyetisyen",
                style: TextStyle(
                  fontFamily: "Zona",
                  fontSize: heightSize(2),
                  color: MyColors().whiteTextColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget selectGenderLittle() {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            setState(() {
              _gender = true;
            });
          },
          child: Container(
            width: widthSize(48),
            height: heightSize(5),
            decoration: BoxDecoration(
              color: _gender != null
                  ? _gender!
                      ? Colors.black
                      : menColor()
                  : menColor(),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                ("Erkek"),
                style: TextStyle(
                  fontFamily: "Zona",
                  fontSize: heightSize(2),
                  color: MyColors().whiteTextColor,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: heightSize(1),
        ),
        InkWell(
          onTap: () {
            setState(() {
              _gender = false;
            });
          },
          child: Container(
            width: widthSize(48),
            height: heightSize(5),
            decoration: BoxDecoration(
              color: _gender != null
                  ? _gender!
                      ? womenColor()
                      : Colors.black
                  : womenColor(),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                "Kadın",
                style: TextStyle(
                  fontFamily: "Zona",
                  fontSize: heightSize(2),
                  color: MyColors().whiteTextColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget signUpButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: TextButton(
            onPressed: () {
              widget.pageController.previousPage(
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOutCubic,
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: MyColors().purpleContainer,
              foregroundColor: MyColors().whiteTextColor, // Assuming white text
              padding: EdgeInsets.zero, // Remove unnecessary padding

              minimumSize:
                  Size(widthSize(35), heightSize(8)), // Set minimum size
            ),
            child: Text(
              "Hesabım Var",
              style: TextStyle(
                fontFamily: "Zona",
                fontSize: heightSize(2),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            //ANCHOR veri kontrolleri burda
            if (passwordController.text == password2Controller.text) {
              setState(() {
                loading = true;
              });
              signUp();
            } else {
              Fluttertoast.showToast(
                  msg: "Lütfen Girdileri Kontrol Ediniz!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 18.0);
            }
          },
          child: Container(
            width: widthSize(42),
            height: heightSize(8),
            decoration: BoxDecoration(
              color: MyColors().purpleContainer,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                "Hesabı Oluştur",
                style: TextStyle(
                  fontFamily: "Zona",
                  fontSize: heightSize(2),
                  color: MyColors().whiteTextColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget signUpButtonLittle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          child: TextButton(
            onPressed: () {
              widget.pageController.previousPage(
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOutCubic,
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: MyColors().purpleContainer,
              foregroundColor:
                  MyColors().whiteTextColor, // Assuming white text color
              padding: const EdgeInsets.all(
                  8.0), // Add some padding for better touch area

              minimumSize:
                  Size(widthSize(40), heightSize(8)), // Set minimum size
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // Add rounded corners
              ), // Optional: Set a custom shape for the button
            ),
            child: Text(
              "Hesabım Var",
              style: TextStyle(
                fontFamily: "Zona",
                fontSize: heightSize(2),
                color: MyColors().whiteTextColor,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            //ANCHOR veri kontrolleri burda
            if (passwordController.text == password2Controller.text) {
              setState(() {
                loading = true;
              });
              //signUp();
            } else {
              Fluttertoast.showToast(
                  msg: "Lütfen Girdileri Kontrol Ediniz!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 18.0);
            }
          },
          child: Container(
            width: widthSize(48),
            height: heightSize(8),
            decoration: BoxDecoration(
              color: MyColors().purpleContainer,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                "Hesabı Oluştur",
                style: TextStyle(
                  fontFamily: "Zona",
                  fontSize: heightSize(2),
                  color: MyColors().whiteTextColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  menColor() {
    return Colors.blueAccent;
  }

  womenColor() {
    return Colors.pink;
  }
}

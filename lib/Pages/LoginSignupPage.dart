import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart' as imgsrc;
import 'package:diyet_ofisim/Pages/RootPage.dart';
import 'package:diyet_ofisim/Services/AuthService.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Tools/ImageEditor.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:diyet_ofisim/assets/Colors.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginSignupPage extends StatefulWidget {
  @override
  _LoginSignupPageState createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  //ANCHOR login
  String userId;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String errorText;
  bool _loginSignUpToggle = true;
  bool _loading = false;
  bool visiblePassword = true;
  bool showLogin = false;
  String sendPasswordMailText = "Giriş Yap";
  UserService userService = locator<UserService>();
  PageController _pageController;

  //ANCHOR SignUp
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  Uint8List _image;
  final picker = imgsrc.ImagePicker();
  bool loading = false;
  String _name, _surname, _country, _birthday;
  bool _gender, _isDietisian = false;
  bool showPassword = true;

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurpleAccent[200],
              Colors.deepPurpleAccent[100],
              Colors.deepPurple[50],
            ],
          ),
        ),
        child: _loginSignUpToggle ? loginDesign(context) : signUpDesign(),
      ),

      /*Stack(
          children: <Widget>[
                PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  children: <Widget>[
                    //ANCHOR Login sayfası
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: heightSize(10),
                          ),
                          welcomeText(),
                          SizedBox(
                            height: heightSize(5),
                          ),
                          emailAndPasswordFields(),
                          Spacer(),
                          signInButton(),
                          SizedBox(
                            height: heightSize(1),
                          ),
                          SizedBox(
                            height: heightSize(5),
                          ),
                        ],
                      ),
                    ),
                    //ANCHOR SignUp sayfası
                    SignUpPage(_pageController)
                  ],
                )
              ] +
              (_loading
                  ? [
                      PageComponents(context)
                          .loadingOverlay(backgroundColor: Colors.white)
                    ]
                  : [])),*/
    );
  }

  double heightSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.height * value;
  }

  double widthSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * value;
  }

  Widget welcomeText() {
    if (visiblePassword == false) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Şifre Sıfırlama",
            style: TextStyle(
              fontFamily: "Zona",
              fontSize: heightSize(4),
              color: MyColors().loginGreyColor,
            ),
          ),
          Text(
            "Mail Adresini Gir",
            style: TextStyle(
              height: heightSize(0.2),
              fontFamily: "ZonaLight",
              fontSize: heightSize(3.3),
              color: MyColors().greyTextColor,
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Tekrar Hoşgeldin",
            style: TextStyle(
              fontFamily: "Zona",
              fontSize: heightSize(4),
              color: MyColors().loginGreyColor,
            ),
          ),
          Text(
            "Giriş yap ve devam et",
            style: TextStyle(
              height: heightSize(0.2),
              fontFamily: "ZonaLight",
              fontSize: heightSize(3.3),
              color: MyColors().greyTextColor,
            ),
          ),
        ],
      );
    }
  }

  Widget emailAndPasswordFields() {
    return Column(
      children: <Widget>[
        TextFormField(
          //onSaved: (value) => email = value,
          controller: email,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Email",
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
        Visibility(
          visible: showLogin,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: heightSize(2),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    rememberPass();
                  },
                  child: Text(
                    "Giriş Yap",
                    style: TextStyle(
                      fontFamily: "ZonaLight",
                      fontSize: heightSize(2),
                      color: MyColors().loginGreyColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: heightSize(5),
        ),
        passwordField(password),
      ],
    );
  }

  Widget passwordField(password) {
    bool showPassword = true;
    print("building custom stateful textfield password");
    return StatefulBuilder(
      builder: (context, state) {
        print("building internal state");
        return Visibility(
          visible: visiblePassword,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      //onSaved: (value) => password = value,
                      controller: password,
                      obscureText: showPassword,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        errorText: errorText,
                        errorStyle: TextStyle(
                          fontSize: heightSize(2),
                          fontFamily: "Zona",
                          color: Colors.red,
                        ),
                        border: InputBorder.none,
                        hintText: "Şifre",
                        hintStyle: TextStyle(
                          fontFamily: "Zona",
                          color: MyColors().loginGreyColor,
                        ),
                        alignLabelWithHint: true,
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: MyColors().loginGreyColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: MyColors().loginGreyColor),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: heightSize(2.5),
                        fontFamily: "ZonaLight",
                        color: MyColors().loginGreyColor,
                      ),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: widthSize(12),
                      height: heightSize(6),
                      child: FlatButton(
                        child: Icon(showPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () {
                          state(() {
                            showPassword = !showPassword;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: heightSize(2),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    forgetPassword();
                  },
                  child: Text(
                    "Şifremi Unuttum",
                    style: TextStyle(
                      fontFamily: "ZonaLight",
                      fontSize: heightSize(2),
                      color: MyColors().loginGreyColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget signInButton() {
    return Row(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: FlatButton(
            color: MyColors().purpleContainer,
            highlightColor: MyColors().purpleContainerSplash,
            splashColor: MyColors().purpleContainerSplash,
            onPressed: () {
              _pageController.nextPage(
                  duration: Duration(seconds: 1), curve: Curves.easeInOutCubic);
            },
            child: Container(
              height: heightSize(8),
              alignment: Alignment.center,
              child: Text(
                "Hesabım Yok",
                style: TextStyle(
                  fontFamily: "Zona",
                  fontSize: heightSize(2.5),
                  color: MyColors().whiteTextColor,
                ),
              ),
            ),
          ),
        ),
        Spacer(),
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: FlatButton(
            color: MyColors().purpleContainer,
            highlightColor: MyColors().purpleContainerSplash,
            splashColor: MyColors().purpleContainerSplash,
            onPressed: () {
              if (visiblePassword == true) {
                setState(() {
                  _loading = true;
                });
                loginButton(context);
              } else {
                passwordReset(context);
              }
            },
            child: Container(
              height: heightSize(8),
              width: widthSize(30),
              alignment: Alignment.center,
              child: Text(
                sendPasswordMailText,
                style: TextStyle(
                  fontFamily: "Zona",
                  fontSize: heightSize(2.5),
                  color: MyColors().whiteTextColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget loginDesign(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 150.0, bottom: 20.0),
          height: 140,
          child: Image.asset(
            "assets/icons/logo1.png",
            color: Colors.white70,
          ),
        ),
        Text(
          "Diyet Ofisim",
          style: TextStyle(
              color: Colors.white70,
              fontSize: 35.0,
              fontWeight: FontWeight.bold,
              fontFamily: "Kalam"),
        ),
        SizedBox(height: 30.0),
        TextField(
          style: TextStyle(color: Colors.white),
            cursorWidth: 3,
            cursorColor: Colors.deepPurpleAccent,
          controller: email,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(16.0),
            prefixIcon: Container(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                margin: const EdgeInsets.only(right: 8.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0)),
                child: Icon(
                  Icons.person,
                  color: Colors.deepPurpleAccent[100],
                )),
            hintText: "enter your email",
            hintStyle: TextStyle(
              color: Colors.white,
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.white.withOpacity(0.18),
          ),
        ),
        SizedBox(height: 10.0),
        TextField(
          style: TextStyle(color: Colors.white),
           cursorWidth: 3,
            cursorColor: Colors.deepPurpleAccent,
          controller: password,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(16.0),
            prefixIcon: Container(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                margin: const EdgeInsets.only(right: 8.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0)),
                child: Icon(
                  Icons.lock,
                  color: Colors.deepPurpleAccent[100],
                )),
            hintText: "enter your password",
            hintStyle: TextStyle(
              color: Colors.white,
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.white.withOpacity(0.18),
          ),
          obscureText: true,
        ),
        SizedBox(height: 30.0),
        SizedBox(
          height: 45,
          width: double.infinity,
          child: RaisedButton(
            color: Colors.white,
            textColor: Colors.deepPurpleAccent[100],
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Login".toUpperCase(),
              style: TextStyle(fontFamily: "Genel", fontSize: 15),
            ),
            onPressed: () {
              loginButton(context);
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
          ),
        ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              textColor: Colors.deepPurpleAccent[200].withOpacity(0.8),
              child: Text(
                "Create Account".toUpperCase(),
              ),
              onPressed: () {
                setState(() {
                  _loginSignUpToggle = !_loginSignUpToggle;
                });
              },
            ),
            Container(
              color: Colors.deepPurpleAccent[200].withOpacity(0.8),
              width: 2.0,
              height: 20.0,
            ),
            FlatButton(
              textColor: Colors.deepPurpleAccent[200].withOpacity(0.8),
              child: Text(
                "Forgot Password".toUpperCase(),
              ),
              onPressed: () {},
            ),
          ],
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget signUpDesign() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurpleAccent[200],
              Colors.deepPurpleAccent[100],
              Colors.deepPurple[50],
            ]),
      ),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              padding: EdgeInsets.only(right: 5),
              height: 50,
              child: Image.asset(
                "assets/icons/logo1.png",
                color: Colors.white70,
              ),
            ),
            Text(
              "Diyet Ofisim",
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Kalam"),
            ),
          ]),
          SizedBox(
            height: PageComponents(context).heightSize(3),
          ),
          addPhoto(),
          SizedBox(
            height: PageComponents(context).heightSize(1.1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 50,
                width: PageComponents(context).widthSize(40),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  cursorWidth: 3,
            cursorColor: Colors.deepPurpleAccent,
                  onChanged: (name) => _name = name,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(top: 0, left: 20),
                    hintText: "Name *",
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.18),
                  ),
                ),
              ),
              SizedBox(
                width: 25,
              ),
              Container(
                height: 50,
                width: PageComponents(context).widthSize(40),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                   cursorWidth: 3,
            cursorColor: Colors.deepPurpleAccent,
                  onChanged: (surname) => _surname = surname,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(top: 10, left: 20),
                    hintText: "Surname *",
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.18),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: PageComponents(context).heightSize(3),
          ),
          TextField(
            style: TextStyle(color: Colors.white),
            cursorWidth: 3,
            cursorColor: Colors.deepPurpleAccent,
            controller: mailController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(top: 10, left: 20),
              hintText: "Email *",
              hintStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none),
              filled: true,
              fillColor: Colors.white.withOpacity(0.18),
            ),
          ),
          SizedBox(
            height: PageComponents(context).heightSize(3),
          ),
          TextField(
            obscureText: true,
            style: TextStyle(color: Colors.white),
             cursorWidth: 3,
            cursorColor: Colors.deepPurpleAccent,
            controller: passwordController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(top: 10, left: 20),
              hintText: "Password *",
              hintStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none),
              filled: true,
              fillColor: Colors.white.withOpacity(0.18),
            ),
          ),
          SizedBox(
            height: PageComponents(context).heightSize(3),
          ),
          TextField(
            obscureText: true,
            style: TextStyle(color: Colors.white),
            cursorWidth: 3,
            cursorColor: Colors.deepPurpleAccent,
            controller: password2Controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(top: 10, left: 20),
              hintText: "Password Again *",
              hintStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none),
              filled: true,
              fillColor: Colors.white.withOpacity(0.18),
            ),
          ),
          SizedBox(
            height: PageComponents(context).heightSize(3),
          ),
          selectGender(),
          SizedBox(
            height: PageComponents(context).heightSize(3),
          ),
          selectUserType(),
/*
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: PageComponents(context).widthSize(40),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    elevation: 10,
                    color: Colors.white,
                    textColor: Colors.deepPurpleAccent[100],
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Kadın".toUpperCase()),
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
              ),
              SizedBox(
                width: PageComponents(context).widthSize(5),
              ),
              Container(
                height: 40,
                width: PageComponents(context).widthSize(40),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    elevation: 10,
                    color: Colors.white,
                    textColor: Colors.deepPurpleAccent[100],
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Erkek".toUpperCase()),
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: PageComponents(context).widthSize(40),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    elevation: 10,
                    color: Colors.white,
                    textColor: Colors.deepPurpleAccent[100],
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Diyetisyen".toUpperCase()),
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
              ),
              SizedBox(
                width: PageComponents(context).widthSize(5),
              ),
              Container(
                height: 40,
                width: PageComponents(context).widthSize(40),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    elevation: 10,
                    color: Colors.white,
                    textColor: Colors.deepPurpleAccent[100],
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Hasta".toUpperCase()),
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
          */
          SizedBox(
            height: 25,
          ),
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              color: Colors.white,
              textColor: Colors.deepPurpleAccent[200].withOpacity(0.8),
              padding: const EdgeInsets.all(15.0),
              child: Text("CREATE ACCOUNT".toUpperCase()),
              onPressed: () {
                //ANCHOR veri kontrolleri burda
                if (_image != null &&
                    _name != null &&
                    _surname != null &&
                    mailController.text != null &&
                    passwordController.text != null &&
                    passwordController.text == password2Controller.text &&
                    _gender != null) {
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
            ),
          ),
          Spacer(),
          FlatButton(
            textColor: Colors.deepPurpleAccent[200].withOpacity(0.8),
            child: Text("I have an Account !".toUpperCase()),
            onPressed: () {
              setState(() {
                _loginSignUpToggle = !_loginSignUpToggle;
              });
            },
          ),
        ],
      ),
    );
  }

  String generateNickName(String name) {
    return name + (1 + Random().nextInt(9998)).toString();
  }

  void signUp() async {
    //ANCHOR Veritabanına kaydetmek için
    List<String> datalist = [
      _name,
      _surname,
      mailController.text,
      _gender ? "Man" : "Woman",
      _isDietisian ? "Y" : "N",
      generateNickName(_name)
    ];
    print(datalist);
    try {
      await locator<LoginRegisterService>()
          .registerUser(
              mailController.text, passwordController.text, datalist, _image)
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
          setState(() {
            _loginSignUpToggle = !_loginSignUpToggle;
          });
        } else {
          setState(() {
            loading = false;
            print("Sign Up Failed!");
          });
        }
      });
    } catch (e) {
      print(e);
      setState(() {
        loading = false;
        print("Sign Up Failed!");
      });
    }
  }

  // ANCHOR kameradan foto almaya yarar
  Future<Uint8List> _getImageFromCamera() async {
    final image = await picker.getImage(source: imgsrc.ImageSource.camera);
    if (image != null)
      return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ImageEditorPage(
                    image: File(image.path),
                    forCreateEvent: false,
                  ))).then((value) => value);
    else
      return null;
  }

// ANCHOR galeriden foto almaya yarar
  Future<Uint8List> _getImageFromGallery() async {
    final image = await picker.getImage(source: imgsrc.ImageSource.gallery);
    if (image != null)
      return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ImageEditorPage(
                    image: File(image.path),
                    forCreateEvent: false,
                  ))).then((value) => value);
    else
      return null;
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
                      child: Text(
                        'Galeri',
                      ),
                      onTap: () {
                        _getImageFromGallery().then((value) {
                          setState(() {
                            _image = value;
                            Navigator.pop(context);
                          });
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
                        _getImageFromCamera().then((value) {
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

  menColor() {
    return Colors.blue[300];
  }

  womenColor() {
    return Colors.pink[300];
  }

  Widget selectGender() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        InkWell(
          onTap: () {
            setState(() {
              _gender = true;
            });
          },
          child: Container(
            width: widthSize(42),
            height: heightSize(5),
            decoration: BoxDecoration(
              color: _gender != null
                  ? _gender
                      ? menColor()
                      : Colors.deepPurpleAccent[300]
                  : Colors.deepPurpleAccent[300],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                "Erkek",
                style: TextStyle(
                  fontFamily: "Genel",
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
            width: widthSize(42),
            height: heightSize(5),
            decoration: BoxDecoration(
              color: _gender != null
                  ? _gender
                      ? Colors.deepPurpleAccent[300]
                      : womenColor()
                  : Colors.deepPurpleAccent[300],
              borderRadius: new BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Center(
              child: Text(
                "Kadın",
                style: TextStyle(
                  fontFamily: "Genel",
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
            width: widthSize(42),
            height: heightSize(5),
            decoration: BoxDecoration(
              color: _isDietisian
                  ? Colors.deepPurpleAccent[300]
                  : Colors.green[200],
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Center(
              child: Text(
                ("Hasta"),
                style: TextStyle(
                  fontFamily: "Genel",
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
            width: widthSize(42),
            height: heightSize(5),
            decoration: new BoxDecoration(
              color: _isDietisian
                  ? Colors.green[200]
                  : Colors.deepPurpleAccent[300],
              borderRadius: new BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Center(
              child: Text(
                "Diyetisyen",
                style: TextStyle(
                  fontFamily: "Genel",
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

  Widget addPhoto() {
    return GestureDetector(
      onTap: () {
        _showChoiceDialog(context);
      },
      child: Container(
        width: widthSize(27),
        height: widthSize(27),
        child: CircleAvatar(
          backgroundColor: Colors.teal,
          radius: 100,
          child: _image == null
              ? Image.asset(
                  'assets/icons/add_user.png',
                  color: Colors.white.withOpacity(0.7),
                  height: heightSize(14),
                )
              : ClipOval(
                  child: Image.memory(
                    _image,
                    width: widthSize(30),
                    height: widthSize(30),
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> loginButton(BuildContext context) async {
    var auth = locator<AuthService>();
    userId = await auth.signIn(email.text, password.text);
    if (userId == null) {
      setState(() => _loading = false);
      Fluttertoast.showToast(
          msg: "Şifre veya Eposta yanlış!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 18.0);
    } else {
      //if (await auth.isEmailVerified()) {

      userService.userInitializer(userId).whenComplete(() async {
        // await userService
        //     .updateSingleInfo("LastLoggedIn", "timeStamp")
        //    .whenComplete(() {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => RootPage()));
        // });
      });
      /*
      } else {
        setState(() => _loading = false);
        auth.signOut();
        Fluttertoast.showToast(
            msg: "Lütfen Mailinizi doğrulayın!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 18.0);
      }*/

    }
  }

  void forgetPassword() {
    setState(() {
      visiblePassword = !visiblePassword;
      sendPasswordMailText = "Mail Gönder";
      showLogin = true;
    });
  }

  Future<void> passwordReset(BuildContext context) async {
    var auth = locator<AuthService>().getUserUid();
    //ANCHOR release yaparken açılacak
    //auth.sendPasswordResetEmail(email.text);
    debugPrint("şifre sıfırlama maili gönderildi");
  }

  void rememberPass() {
    setState(() {
      if (visiblePassword == false) {
        sendPasswordMailText = "Giriş Yap";
        visiblePassword = true;
        showLogin = false;
      }
    });
  }
}

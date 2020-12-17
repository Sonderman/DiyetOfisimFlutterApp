import "package:flutter/material.dart";

class QuestionsPageNew extends StatefulWidget {
  QuestionsPageNew({Key key}) : super(key: key);

  @override
  _QuestionsPageNewState createState() => _QuestionsPageNewState();
}

class _QuestionsPageNewState extends State<QuestionsPageNew> {
  int _aktifStep = 0;
  var boy, kilo, yas;
  String cevap = " ";
  //validator değerlerine göre hata varsa
  //statelerin işaretini değiştirmek için kullanıcaz
  bool hata = false;
  var key0 = GlobalKey<FormFieldState>();
  var key1 = GlobalKey<FormFieldState>();
  var key2 = GlobalKey<FormFieldState>();
  var key3 = GlobalKey<FormFieldState>();
  var key4 = GlobalKey<FormFieldState>();
  var key5 = GlobalKey<FormFieldState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sorular();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Lütfen Soruları Yanıtlayın"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
                border:
                    Border.all(width: 5, color: Colors.deepPurpleAccent[100]),
                borderRadius: BorderRadius.circular(30.0)),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            width: MediaQuery.of(context).size.width - 80,
            height: MediaQuery.of(context).size.height - 120,

            //İçinde Stepler olan bi Liste Bekliyor.
            child: ListView(
              children: [
                Stepper(
                  controlsBuilder: (BuildContext context,
                      {VoidCallback onStepContinue,
                      VoidCallback onStepCancel}) {
                    return Row(children: <Widget>[
                      TextButton(
                        onPressed: onStepContinue,
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.deepPurpleAccent.shade100,
                          size: 50,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        onPressed: onStepContinue,
                        child: Icon(
                          Icons.keyboard_arrow_up_outlined,
                          color: Colors.deepPurpleAccent.shade100,
                          size: 50,
                        ),
                      ),
                    ]);
                  },

                  steps: sorular(),
                  type: StepperType.vertical,
                  //currentStep = mevcut step
                  currentStep: _aktifStep,
                  //Tıkladığım step aktifleşiyor
                  /*onStepTapped: (tiklanilanStep) {
                                setState(() {
                                  _aktifStep = tiklanilanStep;
                                });
                              },*/
                  //Continue Butonu Aktifleşti
                  onStepContinue: () {
                    setState(() {
                      ContinueButonuKontrolu();
                    });
                  },
                  //Cancel Butonu Aktifleşti
                  onStepCancel: () {
                    setState(() {
                      if (_aktifStep > 0) {
                        _aktifStep--;
                      } else {
                        _aktifStep = 0;
                      }
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  color: Colors.deepPurpleAccent.shade100,
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: Text(
                    "Kaydet".toUpperCase(),
                    style: TextStyle(fontFamily: "Genel", fontSize: 17),
                  ),
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Step> sorular() {
    List<Step> stepler = [
      Step(
        title: Text(
          "Yaşınızı Giriniz",
          style: TextStyle(
            fontSize: 17,
            color: Colors.deepPurpleAccent[100],
          ),
        ),
        state: StepAyar(0),
        content: TextFormField(
          key: key0,
          validator: (girilenDeger) {
            if (girilenDeger.isEmpty) {
              return "Lütfen Bir Değer Giriniz";
            }
          },
          onSaved: (girilenDeger) {
            yas = girilenDeger;
          },
          decoration: InputDecoration(
            labelText: "Yaşınız",

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            //filled: true,
          ),
        ),
      ),
      Step(
        title: Text(
          "Boyunuzu Giriniz",
          style: TextStyle(
            fontSize: 17,
            color: Colors.deepPurpleAccent[100],
          ),
        ),
        state: StepAyar(1),
        content: TextFormField(
          key: key1,
          validator: (girilenDeger) {
            if (girilenDeger.isEmpty || girilenDeger.length < 3) {
              return "Lütfen Bir Değer Giriniz";
            }
          },
          onSaved: (girilenDeger) {
            boy = girilenDeger;
          },
          decoration: InputDecoration(
            labelText: "Boyunuz ",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            //filled: true,
          ),
        ),
      ),
      Step(
        title: Text(
          "Kilonuzu Giriniz",
          style: TextStyle(
            fontSize: 17,
            color: Colors.deepPurpleAccent[100],
            //color: Colors.deepPurpleAccent.shade100,
          ),
        ),
        state: StepAyar(2),
        content: TextFormField(
          key: key2,
          validator: (girilenDeger) {
            if (girilenDeger.isEmpty || girilenDeger.length < 3) {
              return "Lütfen Bir Değer Giriniz";
            }
          },
          onSaved: (girilenDeger) {
            kilo = girilenDeger;
          },
          decoration: InputDecoration(
            labelText: "Kilonuz",
            helperText: "",

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            //filled: true,
          ),
        ),
      ),
      Step(
        title: Text(
          "Diyabet Hastası mısınız ?",
          style: TextStyle(
            fontSize: 17,
            color: Colors.deepPurpleAccent[100],
          ),
        ),
        state: StepAyar(3),
        content: Column(
          key: key3,
          children: [
            RadioListTile(
                title: Text("Evet"),
                value: "Evet",
                groupValue: cevap,
                onChanged: (value) {
                  setState(() {
                    cevap = value;
                  });
                }),
            SizedBox(
              width: 10,
            ),
            RadioListTile(
                title: Text("Hayır"),
                value: "Hayır",
                groupValue: cevap,
                onChanged: (value) {
                  setState(() {
                    cevap = value;
                  });
                }),
          ],
        ),
      ),
      Step(
        title: Text(
          "Kalp-Damar Hastası mısınız ?",
          style: TextStyle(
            fontSize: 17,
            color: Colors.deepPurpleAccent[100],
          ),
        ),
        state: StepAyar(4),
        content: Column(
          key: key4,
          children: [
            RadioListTile(
                title: Text("Evet"),
                value: "Evet",
                groupValue: cevap,
                onChanged: (value) {
                  setState(() {
                    cevap = value;
                  });
                }),
            SizedBox(
              width: 10,
            ),
            RadioListTile(
                title: Text("Hayır"),
                value: "Hayır",
                groupValue: cevap,
                onChanged: (value) {
                  setState(() {
                    cevap = value;
                  });
                }),
          ],
        ),
      ),
      Step(
        title: Text(
          "Böbrek Hastası mısınız ?",
          style: TextStyle(
            fontSize: 17,
            color: Colors.deepPurpleAccent[100],
          ),
        ),
        state: StepAyar(5),
        content: Column(
          key: key5,
          children: [
            RadioListTile(
                title: Text("Evet"),
                value: "Evet",
                groupValue: cevap,
                onChanged: (value) {
                  setState(() {
                    cevap = value;
                  });
                }),
            SizedBox(
              width: 10,
            ),
            RadioListTile(
                title: Text("Hayır"),
                value: "Hayır",
                groupValue: cevap,
                onChanged: (value) {
                  setState(() {
                    cevap = value;
                  });
                }),
          ],
        ),
      ),
      Step(
        title: Text(
          "Çölyak Hastası mısınız ?",
          style: TextStyle(
            fontSize: 17,
            color: Colors.deepPurpleAccent[100],
          ),
        ),
        state: StepAyar(6),
        content: Column(
          //key: key6,
          children: [
            RadioListTile(
                title: Text("Evet"),
                value: "Evet",
                groupValue: cevap,
                onChanged: (value) {
                  setState(() {
                    cevap = value;
                  });
                }),
            SizedBox(
              width: 10,
            ),
            RadioListTile(
                title: Text("Hayır"),
                value: "Hayır",
                groupValue: cevap,
                onChanged: (value) {
                  setState(() {
                    cevap = value;
                  });
                }),
          ],
        ),
      ),
    ];
    return stepler;
  }

  // ignore: non_constant_identifier_names
  void ContinueButonuKontrolu() {
    switch (_aktifStep) {
      case 0:
        if (key0.currentState.validate()) {
          key0.currentState.save();
          hata = false;
          _aktifStep++;
        } else {
          hata = true;
        }
        break;
      case 1:
        if (key1.currentState.validate()) {
          key1.currentState.save();
          hata = false;
          _aktifStep++;
        } else {
          hata = true;
        }
        break;
      case 2:
        if (key2.currentState.validate()) {
          key2.currentState.save();
          hata = false;
          _aktifStep++;
        } else {
          hata = true;
        }
        break;
      case 3:
        //key3.currentState.save();

        _aktifStep++;

        break;
      case 4:
        // key4.currentState.save();

        _aktifStep++;

        break;
      case 5:
        //key5.currentState.save();

        _aktifStep++;

        break;
      case 5:
        //key6.currentState.save();

        _aktifStep = 5;

        break;
    }
  }

  // ignore: non_constant_identifier_names
  StepState StepAyar(int stepIndex) {
    if (_aktifStep == stepIndex) {
      if (hata == true) {
        return StepState.error;
      } else {
        return StepState.editing;
      }
    }
    if (_aktifStep > stepIndex) {
      return StepState.complete;
    } else {
      return StepState.indexed;
    }
  }
}

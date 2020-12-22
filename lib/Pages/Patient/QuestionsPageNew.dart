import 'package:diyet_ofisim/Models/Patient.dart';
import 'package:diyet_ofisim/Pages/Patient/DieticianListPage.dart';
import 'package:diyet_ofisim/Pages/Patient/Inspection.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/locator.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';

class QuestionsPageNew extends StatefulWidget {
  QuestionsPageNew({Key key}) : super(key: key);

  @override
  _QuestionsPageNewState createState() => _QuestionsPageNewState();
}

class _QuestionsPageNewState extends State<QuestionsPageNew> {
  Patient usermodel = locator<UserService>().userModel;
  ScrollController _scrollController = ScrollController();
  Inspection inspection;
  int aktifStep = 0;
  num boy, kilo, yas;
  var cevap = List(5);
  //validator değerlerine göre hata varsa
  //statelerin işaretini değiştirmek için kullanıcaz
  bool hata = false;
  var key0 = GlobalKey<FormFieldState>();
  var key1 = GlobalKey<FormFieldState>();
  var key2 = GlobalKey<FormFieldState>();

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
              controller: _scrollController,
              children: [
                Stepper(
                  physics: ClampingScrollPhysics(),
                  controlsBuilder: (BuildContext context,
                      {VoidCallback onStepContinue,
                      VoidCallback onStepCancel}) {
                    return Row(children: <Widget>[
                      Visibility(
                        visible:
                            aktifStep != (usermodel.gender == "Man" ? 6 : 7),
                        child: TextButton(
                          onPressed: onStepContinue,
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.deepPurpleAccent.shade100,
                            size: 50,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Visibility(
                        visible: aktifStep != 0,
                        child: TextButton(
                          onPressed: onStepCancel,
                          child: Icon(
                            Icons.keyboard_arrow_up_outlined,
                            color: Colors.deepPurpleAccent.shade100,
                            size: 50,
                          ),
                        ),
                      ),
                    ]);
                  },

                  steps: sorular(),
                  type: StepperType.vertical,
                  //currentStep = mevcut step
                  currentStep: aktifStep,
                  //Tıkladığım step aktifleşiyor
                  /*onStepTapped: (tiklanilanStep) {
                                setState(() {
                                  _aktifStep = tiklanilanStep;
                                });
                              },*/
                  //Continue Butonu Aktifleşti
                  onStepContinue: () {
                    setState(() {
                      continueButonuKontrolu();
                    });
                  },
                  //Cancel Butonu Aktifleşti
                  onStepCancel: () {
                    setState(() {
                      if (aktifStep > 0) {
                        aktifStep--;
                      } else {
                        aktifStep = 0;
                      }
                    });
                  },
                ),
                RaisedButton(
                  color: Colors.deepPurpleAccent.shade100,
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: Text(
                    "Kaydet".toUpperCase(),
                    style: TextStyle(fontFamily: "Genel", fontSize: 17),
                  ),
                  onPressed: saveButton,
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
        state: stepAyar(0),
        content: TextFormField(
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
          key: key0,
          validator: (girilenDeger) {
            if (girilenDeger.isEmpty) {
              return "Lütfen Bir Değer Giriniz";
            } else if (!(int.tryParse(girilenDeger) >= 18 &&
                int.tryParse(girilenDeger) <= 100)) {
              return "Lütfen 18 ile 100 arasında değer giriniz";
            } else
              return null;
          },
          onSaved: (girilenDeger) {
            yas = int.tryParse(girilenDeger);
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
        state: stepAyar(1),
        content: TextFormField(
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
          key: key1,
          validator: (girilenDeger) {
            if (girilenDeger.isEmpty || girilenDeger.length < 3) {
              return "Lütfen Bir Değer Giriniz";
            } else if (!(int.tryParse(girilenDeger) >= 150 &&
                int.tryParse(girilenDeger) <= 240)) {
              return "Lütfen 150 ile 240 arasında değer giriniz";
            } else
              return null;
          },
          onSaved: (girilenDeger) {
            boy = int.tryParse(girilenDeger);
          },
          decoration: InputDecoration(
            labelText: "Boyunuz (cm) ",
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
        state: stepAyar(2),
        content: TextFormField(
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
          key: key2,
          validator: (girilenDeger) {
            if (girilenDeger.isEmpty) {
              return "Lütfen Bir Değer Giriniz";
            } else if (!(int.tryParse(girilenDeger) >= 40 &&
                int.tryParse(girilenDeger) <= 300)) {
              return "Lütfen 40 ile 300 arasında değer giriniz";
            } else
              return null;
          },
          onSaved: (girilenDeger) {
            kilo = int.tryParse(girilenDeger);
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
        state: stepAyar(3),
        content: Column(
          children: [
            RadioListTile(
                title: Text("Evet"),
                value: true,
                groupValue: cevap[0],
                onChanged: (value) {
                  setState(() {
                    cevap[0] = value;
                  });
                }),
            SizedBox(
              width: 10,
            ),
            RadioListTile(
                title: Text("Hayır"),
                value: false,
                groupValue: cevap[0],
                onChanged: (value) {
                  setState(() {
                    cevap[0] = value;
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
        state: stepAyar(4),
        content: Column(
          children: [
            RadioListTile(
                title: Text("Evet"),
                value: true,
                groupValue: cevap[1],
                onChanged: (value) {
                  setState(() {
                    cevap[1] = value;
                  });
                }),
            SizedBox(
              width: 10,
            ),
            RadioListTile(
                title: Text("Hayır"),
                value: false,
                groupValue: cevap[1],
                onChanged: (value) {
                  setState(() {
                    cevap[1] = value;
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
        state: stepAyar(5),
        content: Column(
          children: [
            RadioListTile(
                title: Text("Evet"),
                value: true,
                groupValue: cevap[2],
                onChanged: (value) {
                  setState(() {
                    cevap[2] = value;
                  });
                }),
            SizedBox(
              width: 10,
            ),
            RadioListTile(
                title: Text("Hayır"),
                value: false,
                groupValue: cevap[2],
                onChanged: (value) {
                  setState(() {
                    cevap[2] = value;
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
        state: stepAyar(6),
        content: Column(
          //key: key6,
          children: [
            RadioListTile(
                title: Text("Evet"),
                value: true,
                groupValue: cevap[3],
                onChanged: (value) {
                  setState(() {
                    cevap[3] = value;
                  });
                }),
            SizedBox(
              width: 10,
            ),
            RadioListTile(
                title: Text("Hayır"),
                value: false,
                groupValue: cevap[3],
                onChanged: (value) {
                  setState(() {
                    cevap[3] = value;
                  });
                }),
          ],
        ),
      ),
    ];
    if (usermodel.gender == "Woman")
      stepler.add(
        Step(
          title: Text(
            "Hamilemisiniz ?",
            style: TextStyle(
              fontSize: 17,
              color: Colors.deepPurpleAccent[100],
            ),
          ),
          state: stepAyar(7),
          content: Column(
            children: [
              RadioListTile(
                  title: Text("Evet"),
                  value: true,
                  groupValue: cevap[4],
                  onChanged: (value) {
                    setState(() {
                      cevap[4] = value;
                    });
                  }),
              SizedBox(
                width: 10,
              ),
              RadioListTile(
                  title: Text("Hayır"),
                  value: false,
                  groupValue: cevap[4],
                  onChanged: (value) {
                    setState(() {
                      cevap[4] = value;
                    });
                  }),
            ],
          ),
        ),
      );
    return stepler;
  }

  void continueButonuKontrolu() {
    switch (aktifStep) {
      case 0:
        if (key0.currentState.validate()) {
          key0.currentState.save();
          hata = false;
          aktifStep++;
        } else {
          hata = true;
        }
        break;
      case 1:
        if (key1.currentState.validate()) {
          key1.currentState.save();
          hata = false;
          aktifStep++;
        } else {
          hata = true;
        }
        break;
      case 2:
        if (key2.currentState.validate()) {
          key2.currentState.save();
          hata = false;
          aktifStep++;
        } else {
          hata = true;
        }
        break;
      default:
        aktifStep++;
        if (aktifStep == (usermodel.gender == "Man" ? 6 : 7)) {
          print("girdi");
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }

        break;
    }
  }

  StepState stepAyar(int stepIndex) {
    if (aktifStep == stepIndex) {
      if (hata == true) {
        return StepState.error;
      } else {
        return StepState.editing;
      }
    }
    if (aktifStep > stepIndex) {
      return StepState.complete;
    } else {
      return StepState.indexed;
    }
  }

  void saveButton() {
    inspection = Inspection(
        age: yas,
        gender: usermodel.gender == "Man" ? true : false,
        length: boy,
        weight: kilo);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                DieticianListPage(results: inspection.proceedAnswer(cevap))));
  }
}

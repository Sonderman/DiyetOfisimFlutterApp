import 'package:diyet_ofisim/Models/Patient.dart';
import 'package:diyet_ofisim/Pages/Components/CustomScroll.dart';
import 'package:diyet_ofisim/Pages/Patient/Inspection.dart';
import 'package:diyet_ofisim/Pages/Patient/InspectionSummaryPage.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Tools/Classifier.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  Classifier classifier = Classifier();
  Patient usermodel = locator<UserService>().userModel;
  final ScrollController _scrollController = ScrollController();
  int aktifStep = 0;
  num? boy, kilo, yas, kTansiyon, bTansiyon;
  Map<String, dynamic>? cevap;

  //validator değerlerine göre hata varsa
  //statelerin işaretini değiştirmek için kullanıcaz
  bool hata = false;
  var key0 = GlobalKey<FormFieldState>();
  var key1 = GlobalKey<FormFieldState>();
  var key2 = GlobalKey<FormFieldState>();
  var key3 = GlobalKey<FormFieldState>();
  var key4 = GlobalKey<FormFieldState>();
  @override
  void initState() {
    cevap = {"Glikoz": 1, "Kolesterol": 1};
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sorular();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Lütfen Soruları Yanıtlayın"),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
                border:
                    Border.all(width: 5, color: Colors.deepPurpleAccent[100]!),
                borderRadius: BorderRadius.circular(30.0)),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            width: MediaQuery.of(context).size.width - 80,
            height: MediaQuery.of(context).size.height - 120,

            //İçinde Stepler olan bi Liste Bekliyor.
            child: ScrollConfiguration(
              behavior: NoScrollEffectBehavior(),
              child: ListView(
                controller: _scrollController,
                children: [
                  Stepper(
                    physics: const ClampingScrollPhysics(),
                    controlsBuilder: (context, details) {
                      return Row(children: <Widget>[
                        Visibility(
                          visible: aktifStep != 6,
                          child: TextButton(
                            onPressed: details.onStepContinue,
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.deepPurpleAccent.shade100,
                              size: 50,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Visibility(
                          visible: aktifStep != 0,
                          child: TextButton(
                            onPressed: details.onStepCancel,
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
                    currentStep: aktifStep,
                    onStepContinue: () {
                      setState(() {
                        continueButonuKontrolu();
                      });
                    },
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
                  ElevatedButton(
                    onPressed: aktifStep == 6 ? saveButton : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Text(
                      "Kaydet".toUpperCase(),
                      style: const TextStyle(fontFamily: "Genel", fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Step> sorular() {
    List<Step> stepler = [
//  YAS  //
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
            if (girilenDeger!.isEmpty) {
              return "Lütfen Bir Değer Giriniz";
            } else if (!(int.tryParse(girilenDeger)! >= 18 &&
                int.tryParse(girilenDeger)! <= 100)) {
              return "Lütfen 18 ile 100 arasında değer giriniz";
            } else
              return null;
          },
          onSaved: (girilenDeger) {
            yas = int.tryParse(girilenDeger!);
          },
          decoration: InputDecoration(
            focusColor: Colors.teal,
            labelText: "Yaşınız",
            labelStyle: const TextStyle(fontSize: 14),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),

            //filled: true,
          ),
        ),
      ),

      //  BOY  //
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
            if (girilenDeger!.isEmpty) {
              return "Lütfen Bir Değer Giriniz";
            } else if (!(int.tryParse(girilenDeger)! >= 150 &&
                int.tryParse(girilenDeger)! <= 240)) {
              return "Lütfen 150 ile 240 arasında değer giriniz";
            } else
              return null;
          },
          onSaved: (girilenDeger) {
            boy = int.tryParse(girilenDeger!);
          },
          decoration: InputDecoration(
            labelText: "Boyunuz (cm) ",
            labelStyle: const TextStyle(fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            //filled: true,
          ),
        ),
      ),
      //  KİLO   //
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
            if (girilenDeger!.isEmpty) {
              return "Lütfen Bir Değer Giriniz";
            } else if (!(int.tryParse(girilenDeger)! >= 40 &&
                int.tryParse(girilenDeger)! <= 300)) {
              return "Lütfen 40 ile 300 arasında değer giriniz";
            } else {
              return null;
            }
          },
          onSaved: (girilenDeger) {
            kilo = int.tryParse(girilenDeger!);
          },
          decoration: InputDecoration(
            labelText: "Kilonuz",
            labelStyle: const TextStyle(fontSize: 14),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            //filled: true,
          ),
        ),
      ),
      //  DÜŞÜK TANSİYON  //
      Step(
        title: Text(
          "Düşük Tansiyonunuzu Giriniz",
          style: TextStyle(
            fontSize: 17,
            color: Colors.deepPurpleAccent[100],
          ),
        ),
        state: stepAyar(3),
        content: TextFormField(
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
          key: key3,
          validator: (girilenDeger) {
            if (girilenDeger!.isEmpty) {
              return "Lütfen Bir Değer Giriniz";
            } else {
              return null;
            }
          },
          onSaved: (girilenDeger) {
            kTansiyon = int.tryParse(girilenDeger!);
          },
          decoration: InputDecoration(
            labelText: "Düşük Tansiyonunuz",
            labelStyle: const TextStyle(fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      //  YÜKSEK TANSİYON  //
      Step(
        title: Text(
          "Büyük Tansiyonunuzu Giriniz",
          style: TextStyle(
            fontSize: 17,
            color: Colors.deepPurpleAccent[100],
          ),
        ),
        state: stepAyar(4),
        content: TextFormField(
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
          key: key4,
          validator: (girilenDeger) {
            if (girilenDeger!.isEmpty) {
              return "Lütfen Bir Değer Giriniz";
            } else {
              return null;
            }
          },
          onSaved: (girilenDeger) {
            bTansiyon = int.tryParse(girilenDeger!);
          },
          decoration: InputDecoration(
            labelText: "Büyük Tansiyonunuz",
            labelStyle: const TextStyle(fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      //  GLİKOZ DEĞERİ  //
      Step(
        title: Text(
          "Glikoz Seviyeniz Nedir ?",
          style: TextStyle(
            fontSize: 17,
            color: Colors.deepPurpleAccent[100],
          ),
        ),
        state: stepAyar(5),
        content: Column(
          children: [
            RadioListTile(
                title: const Text("Normal"),
                value: 1,
                groupValue: cevap!["Glikoz"],
                onChanged: (value) {
                  setState(() {
                    cevap!["Glikoz"] = value;
                  });
                }),
            const SizedBox(
              width: 10,
            ),
            RadioListTile(
                title: const Text("Yüksek"),
                value: 2,
                groupValue: cevap!["Glikoz"],
                onChanged: (value) {
                  setState(() {
                    cevap!["Glikoz"] = value;
                  });
                }),
            const SizedBox(
              width: 10,
            ),
            RadioListTile(
                title: const Text("Çok Yüksek"),
                value: 3,
                groupValue: cevap!["Glikoz"],
                onChanged: (value) {
                  setState(() {
                    cevap!["Glikoz"] = value;
                  });
                }),
          ],
        ),
      ),
      //  KOLESTOREL DEĞERİ //
      Step(
        title: Text(
          "Kolesterol Seviyeniz Nedir ?",
          style: TextStyle(
            fontSize: 17,
            color: Colors.deepPurpleAccent[100],
          ),
        ),
        state: stepAyar(6),
        content: Column(
          children: [
            RadioListTile(
                title: const Text("Normal"),
                value: 1,
                groupValue: cevap!["Kolesterol"],
                onChanged: (value) {
                  setState(() {
                    cevap!["Kolesterol"] = value;
                  });
                }),
            const SizedBox(
              width: 10,
            ),
            RadioListTile(
                title: const Text("Yüksek"),
                value: 2,
                groupValue: cevap!["Kolesterol"],
                onChanged: (value) {
                  setState(() {
                    cevap!["Kolesterol"] = value;
                  });
                }),
            const SizedBox(
              width: 10,
            ),
            RadioListTile(
                title: const Text("Çok Yüksek"),
                value: 3,
                groupValue: cevap!["Kolesterol"],
                onChanged: (value) {
                  setState(() {
                    cevap!["Kolesterol"] = value;
                  });
                }),
          ],
        ),
      ),
    ];
    return stepler;
  }

  void continueButonuKontrolu() {
    switch (aktifStep) {
      case 0:
        if (key0.currentState!.validate()) {
          key0.currentState!.save();
          hata = false;
          aktifStep++;
        } else {
          hata = true;
        }
        break;
      case 1:
        if (key1.currentState!.validate()) {
          key1.currentState!.save();
          hata = false;
          aktifStep++;
        } else {
          hata = true;
        }
        break;
      case 2:
        if (key2.currentState!.validate()) {
          key2.currentState!.save();
          hata = false;
          aktifStep++;
        } else {
          hata = true;
        }
        break;
      case 3:
        if (key3.currentState!.validate()) {
          key3.currentState!.save();
          hata = false;
          aktifStep++;
        } else {
          hata = true;
        }
        break;
      case 4:
        if (key4.currentState!.validate()) {
          key4.currentState!.save();
          hata = false;
          aktifStep++;
        } else {
          hata = true;
        }
        break;
      default:
        aktifStep++;
        if (aktifStep == (usermodel.gender == "Man" ? 6 : 7)) {
          if (kDebugMode) {
            print("girdi");
          }
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
    cevap!["Yas"] = yas;
    cevap!["Boy"] = boy;
    cevap!["Kilo"] = kilo;
    cevap!["kTansiyon"] = kTansiyon;
    cevap!["bTansiyon"] = bTansiyon;
    cevap!["Gender"] = usermodel.gender == "Man" ? true : false;
    cevap!["BMI"] = (kilo! / ((boy! ~/ 10) * (boy! ~/ 10))) * 100;
    String kgRange = "";

    List r = classifier.classify(cevap!);
    Inspection inspection =
        Inspection(r[0], r[1], cevap!["Gender"], cevap!["BMI"], kgRange);
    classifier.closeInterpreter();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => InspectionSummaryPage(
                  results: inspection.inspect(),
                  bmi: inspection.bodyMassIndex * 1.0,
                  kgRange: inspection.kgRange,
                )));
  }
}

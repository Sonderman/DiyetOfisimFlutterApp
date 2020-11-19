List questionsAndAnswers = [
  [
    "Diyabet Hastasımısınız?",
    ["Evet", "Hayır"],
    "Açlık Kan Şekeriniz kaçtır?"
  ],
  [
    "Kalp Damar Hastalığınız varmı?",
    ["Evet", "Hayır"],
  ],
  [
    "Çölyak Hastalığınız varmı?",
    ["Evet", "Hayır"],
  ],
  [
    "Böbrek Hastalığınız varmı?",
    ["Evet", "Hayır"],
  ],
  [
    "Hamilemisiniz?",
    ["Evet", "Hayır"],
  ]
];

class Inspection {
  final int age, length, weight;

  final bool gender;
  bool isPregnant = false,
      isDiabetes = false,
      isCardiovascular = false,
      isCeliac = false,
      isKidney = false;

  num bodyMassIndex;
  num fastingBloodSugar;

  Inspection({this.age, this.length, this.weight, this.gender}) {
    //Beden Kitle İndeksi Formülü
    bodyMassIndex = (weight / ((length ~/ 10) * (length ~/ 10))) * 100;
  }

  int proceedAnswer(int questionIndex, int i) {
    switch (questionIndex) {
      case 0:
        if (i == 0) {
          isDiabetes = true;
          return 1;
        } else {
          isDiabetes = false;
          return 2;
        }

        break;
      case 1:
        if (i == 0)
          isCardiovascular = true;
        else
          isCardiovascular = false;
        break;
      case 2:
        if (i == 0)
          isCeliac = true;
        else
          isCeliac = false;
        break;
      case 3:
        if (i == 0)
          isKidney = true;
        else
          isKidney = false;
        break;
      case 4:
        if (i == 0)
          isPregnant = true;
        else
          isPregnant = false;
        break;
      default:
        return 0;
    }
    return 0;
  }

  void inspect() {
    //Çocuk ise
    if (age < 19) {
      print("Çocuk Beslenmesi");
    }
    //Yetişkin ise
    else {
      //Kadın ise
      if (!gender) {
        if (bodyMassIndex <= 17.5) {
          print("Anoreksi(Aşırı zayıf) -> YEME BOZUKLUKLARI BESLENMESİ");
        }
        if (bodyMassIndex > 17.5 && bodyMassIndex <= 19.1) {
          print("Zayıf");
        }
        if (bodyMassIndex > 19.1 && bodyMassIndex <= 25.8) {
          print("Normal Kilolu");
        }
        if (bodyMassIndex > 25.8 && bodyMassIndex <= 27.3) {
          print("Biraz Fazla Kilolu");
        }
        if (bodyMassIndex > 27.3 && bodyMassIndex <= 32.3) {
          print("Fazla Kilolu");
        }
        if (bodyMassIndex > 32.3 && bodyMassIndex <= 34.9) {
          print("Çok Fazla Kilolu -> OBEZİTE");
        }
        if (bodyMassIndex > 34.9 && bodyMassIndex <= 40) {
          print("Sağlık Açısından Yüksek Riskli Kilolu -> OBEZİTE");
        }
        if (bodyMassIndex > 40 && bodyMassIndex <= 50) {
          print("Hastalıklı bir Şekilde Aşırı Kilolu -> OBEZİTE");
        }
        if (bodyMassIndex > 50 && bodyMassIndex <= 60) {
          print("Süper Aşırı  Kilolu -> OBEZİTE");
        }

        diyabet();
        kalpDamar();
        colyak();
        bobrek();
        hamile();
      }
      //Erkek ise
      else {
        if (bodyMassIndex <= 17.5) {
          print("Anoreksi(Aşırı zayıf) -> YEME BOZUKLUKLARI BESLENMESİ");
        }
        if (bodyMassIndex > 17.5 && bodyMassIndex <= 20.7) {
          print("Zayıf");
        }
        if (bodyMassIndex > 20.7 && bodyMassIndex <= 26.4) {
          print("Normal Kilolu");
        }
        if (bodyMassIndex > 26.4 && bodyMassIndex <= 27.8) {
          print("Biraz Fazla Kilolu");
        }
        if (bodyMassIndex > 27.8 && bodyMassIndex <= 31.1) {
          print("Fazla Kilolu");
        }
        if (bodyMassIndex > 31.1 && bodyMassIndex <= 34.9) {
          print("Çok Fazla Kilolu -> OBEZİTE");
        }
        if (bodyMassIndex > 34.9 && bodyMassIndex <= 40) {
          print("Sağlık Açısından Yüksek Riskli Kilolu -> OBEZİTE");
        }
        if (bodyMassIndex > 40 && bodyMassIndex <= 50) {
          print("Hastalıklı bir Şekilde Aşırı Kilolu -> OBEZİTE");
        }
        if (bodyMassIndex > 50 && bodyMassIndex <= 60) {
          print("Süper Aşırı  Kilolu -> OBEZİTE");
        }

        diyabet();
        kalpDamar();
        colyak();
        bobrek();
      }
    }
  }

  void hamile() {
    if (isPregnant) {
      print("Gebelik Dönemi Beslenmesi");
    }
  }

  void diyabet() {
    if (isDiabetes) {
      if (fastingBloodSugar <= 100) {
        print("Normal değer");
      }
      if (fastingBloodSugar > 100 && fastingBloodSugar < 125) {
        print("Bozulmuş açlık glilozu");
      }
      if (fastingBloodSugar >= 126) {
        print("Tip 2 Diyabet");
      }
    }
  }

  void kalpDamar() {
    if (isCardiovascular) {
      print("Kalp Damar Hastalıkları Beslenmesi");
    }
  }

  void colyak() {
    if (isCeliac) {
      print("Gastrointestinal Sistem Hastalıkları Beslenmesi");
    }
  }

  void bobrek() {
    if (isKidney) {
      print("Böbrek Hastalıkları Beslenmesi");
    }
  }
}

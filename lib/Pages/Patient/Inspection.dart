import 'package:diyet_ofisim/Settings/AppSettings.dart';

class Inspection {
  List<Diseases> result = [];
  var kgRange;
  bool gender;
  final num bodyMassIndex, isDiabetes, isCardiovascular;

  Inspection(
    this.isDiabetes,
    this.isCardiovascular,
    this.gender,
    this.bodyMassIndex,
  );

  List<Diseases> inspect() {
    //Kadın ise
    if (!gender) {
      if (bodyMassIndex <= 17.5) {
        print("Anoreksi(Aşırı zayıf) -> YEME BOZUKLUKLARI BESLENMESİ");
        result.add(Diseases.anoreksiya);
         kiloAraligi("aşırı Zayıf");
      }
      if (bodyMassIndex > 17.5 && bodyMassIndex <= 19.1) {
        print("Zayıf");
         kiloAraligi("Zayıf");
      }
      if (bodyMassIndex > 19.1 && bodyMassIndex <= 25.8) {
        print("Normal Kilolu");
       kiloAraligi("Normal Kilolu");
      }
      if (bodyMassIndex > 25.8 && bodyMassIndex <= 27.3) {
        print("Biraz Fazla Kilolu");
         kiloAraligi("Biraz Fazla Kilolu");
      }
      if (bodyMassIndex > 27.3 && bodyMassIndex <= 32.3) {
        print("Fazla Kilolu");
         kiloAraligi("Fazla Kilolu");
      }
      if (bodyMassIndex > 32.3 && bodyMassIndex <= 34.9) {
        print("Çok Fazla Kilolu -> OBEZİTE");
        result.add(Diseases.obezite);
         kiloAraligi("Çok Fazla Kilolu");
      }
      if (bodyMassIndex > 34.9 && bodyMassIndex <= 40) {
        print("Sağlık Açısından Yüksek Riskli Kilolu -> OBEZİTE");
        result.add(Diseases.obezite);
         kiloAraligi("Sağlık Açısından Yüksek Riskli Kilolu");
      }
      if (bodyMassIndex > 40 && bodyMassIndex <= 50) {
        print("Hastalıklı bir Şekilde Aşırı Kilolu -> OBEZİTE");
        result.add(Diseases.obezite);
       kiloAraligi("Hastalıklı bir Şekilde Aşırı Kilolu");
      }
      if (bodyMassIndex > 50 && bodyMassIndex <= 60) {
        result.add(Diseases.obezite);
        print("Süper Aşırı  Kilolu -> OBEZİTE");
        kiloAraligi("Süper Aşırı  Kilolu");
      }

      diyabet();
      kalpDamar();
      return result;
    }
    //Erkek ise
    else {
      if (bodyMassIndex <= 17.5) {
        print("Anoreksi(Aşırı zayıf) -> YEME BOZUKLUKLARI BESLENMESİ");
        result.add(Diseases.anoreksiya);
        kiloAraligi( "Aşırı Zayıf");
      }
      if (bodyMassIndex > 17.5 && bodyMassIndex <= 20.7) {
        print("Zayıf");
        kiloAraligi("Zayıf");
      }
      if (bodyMassIndex > 20.7 && bodyMassIndex <= 26.4) {
        print("Normal Kilolu");
        kiloAraligi("Normal Kilolu");
      }
      if (bodyMassIndex > 26.4 && bodyMassIndex <= 27.8) {
        print("Biraz Fazla Kilolu");
        
        kiloAraligi("Biraz Fazla Kilolu");
      }
      if (bodyMassIndex > 27.8 && bodyMassIndex <= 31.1) {
        print("Fazla Kilolu");
        kiloAraligi("Fazla Kilolu");
      }
      if (bodyMassIndex > 31.1 && bodyMassIndex <= 34.9) {
        print("Çok Fazla Kilolu -> OBEZİTE");
        result.add(Diseases.obezite);
        kiloAraligi("Çok Fazla Kilolu");
      }
      if (bodyMassIndex > 34.9 && bodyMassIndex <= 40) {
        print("Sağlık Açısından Yüksek Riskli Kilolu -> OBEZİTE");
        result.add(Diseases.obezite);
        kiloAraligi("Sağlık Açısından Yüksek Riskli Kilolu");
      }
      if (bodyMassIndex > 40 && bodyMassIndex <= 50) {
        print("Hastalıklı bir Şekilde Aşırı Kilolu -> OBEZİTE");
        result.add(Diseases.obezite);
        kiloAraligi("Hastalıklı bir Şekilde Aşırı Kilolu");
      }
      if (bodyMassIndex > 50 && bodyMassIndex <= 60) {
        print("Süper Aşırı  Kilolu -> OBEZİTE");
        result.add(Diseases.obezite);
        kiloAraligi("Süper Aşırı  Kilolu");
      }

      diyabet();
      kalpDamar();
      return result;
  
    }
  }

  String kiloAraligi(String kgRange) {
    return kgRange;
  }

  void diyabet() {
    if (isDiabetes == 1) {
      print("Diyabet Beslenmesi");
      result.add(Diseases.diyabet);
    }
  }

  void kalpDamar() {
    if (isCardiovascular == 1) {
      print("Kalp Damar Hastalıkları Beslenmesi");
      result.add(Diseases.kalp_Damar);
    }
  }
  
}



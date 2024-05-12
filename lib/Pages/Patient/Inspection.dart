import 'package:diyet_ofisim/Settings/AppSettings.dart';

class Inspection {
  List<Diseases> result = [];
  String kgRange;
  bool gender;
  final num bodyMassIndex, isDiabetes, isCardiovascular;

  Inspection(this.isDiabetes, this.isCardiovascular, this.gender,
      this.bodyMassIndex, this.kgRange);

  List<Diseases> inspect() {
    //Kadın ise
    if (!gender) {
      if (bodyMassIndex <= 17.5) {
        result.add(Diseases.anoreksiya);
        kgRange = "Aşırı Zayıf";
      }
      if (bodyMassIndex > 17.5 && bodyMassIndex <= 19.1) {
        kgRange = "Zayıf";
      }
      if (bodyMassIndex > 19.1 && bodyMassIndex <= 25.8) {
        kgRange = "Normal Kilolu";
      }
      if (bodyMassIndex > 25.8 && bodyMassIndex <= 27.3) {
        kgRange = "Biraz Fazla Kilolu";
      }
      if (bodyMassIndex > 27.3 && bodyMassIndex <= 32.3) {
        kgRange = "Fazla Kilolu";
      }
      if (bodyMassIndex > 32.3 && bodyMassIndex <= 34.9) {
        result.add(Diseases.obezite);
        kgRange = "Çok Fazla Kilolu";
      }
      if (bodyMassIndex > 34.9 && bodyMassIndex <= 40) {
        result.add(Diseases.obezite);
        kgRange = "Sağlık Açısından Yüksek Riskli Kilolu";
      }
      if (bodyMassIndex > 40 && bodyMassIndex <= 50) {
        result.add(Diseases.obezite);
        kgRange = "Hastalıklı bir Şekilde Aşırı Kilolu";
      }
      if (bodyMassIndex > 50 && bodyMassIndex <= 60) {
        result.add(Diseases.obezite);

        kgRange = "Süper Aşırı  Kilolu";
      }

      diyabet();
      kalpDamar();
      return result;
    }
    //Erkek ise
    else {
      if (bodyMassIndex <= 17.5) {
        result.add(Diseases.anoreksiya);
        kgRange = "Aşırı Zayıf";
      }
      if (bodyMassIndex > 17.5 && bodyMassIndex <= 20.7) {
        kgRange = "Zayıf";
      }
      if (bodyMassIndex > 20.7 && bodyMassIndex <= 26.4) {
        kgRange = "Normal Kilolu";
      }
      if (bodyMassIndex > 26.4 && bodyMassIndex <= 27.8) {
        kgRange = "Biraz Fazla Kilolu";
      }
      if (bodyMassIndex > 27.8 && bodyMassIndex <= 31.1) {
        kgRange = "Fazla Kilolu";
      }
      if (bodyMassIndex > 31.1 && bodyMassIndex <= 34.9) {
        result.add(Diseases.obezite);
        kgRange = "Çok Fazla Kilolu";
      }
      if (bodyMassIndex > 34.9 && bodyMassIndex <= 40) {
        result.add(Diseases.obezite);
        kgRange = "Sağlık Açısından Yüksek Riskli Kilolu";
      }
      if (bodyMassIndex > 40 && bodyMassIndex <= 50) {
        result.add(Diseases.obezite);
        kgRange = "Hastalıklı bir Şekilde Aşırı Kilolu";
      }
      if (bodyMassIndex > 50 && bodyMassIndex <= 60) {
        result.add(Diseases.obezite);
        kgRange = "Süper Aşırı  Kilolu";
      }

      diyabet();
      kalpDamar();
      return result;
    }
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
      result.add(Diseases.kalpDamar);
    }
  }
}

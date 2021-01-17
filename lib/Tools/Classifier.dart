import 'package:tflite_flutter/tflite_flutter.dart';

class Classifier {
  final _diyabetModel = 'diyabet.tflite';
  final _kalpModel = 'kalpdamar.tflite';
  Interpreter _interpreterDiyabet, _interpreterKalp;

  Classifier() {
    _loadModel();
  }

  void _loadModel() async {
    _interpreterDiyabet = await Interpreter.fromAsset(_diyabetModel)
        .whenComplete(() => print('_diyabet_model loaded successfully'));
    _interpreterKalp = await Interpreter.fromAsset(_kalpModel)
        .whenComplete(() => print('_kalp_model loaded successfully'));
  }

  List<int> classify(Map answers) {
    var outputDiyabet = List<double>(1).reshape([1, 1]);
    var outputKalp = List<double>(1).reshape([1, 1]);
    List<List<double>> inputDiyabet = answerConverter(answers, true);
    List<List<double>> inputKalp = answerConverter(answers, false);
    _interpreterDiyabet.run(inputDiyabet, outputDiyabet);
    _interpreterKalp.run(inputKalp, outputKalp);

    print("Diyabet:" + (outputDiyabet[0][0] as double).round().toString());
    print("Kalp:" + (outputKalp[0][0] as double).round().toString());
    return [
      (outputDiyabet[0][0] as double).round(),
      (outputKalp[0][0] as double).round()
    ];
  }

  void closeInterpreter() {
    _interpreterDiyabet.close();
    _interpreterKalp.close();
  }

  List<List<double>> answerConverter(Map answers, bool isDiyabet) {
    num boy = answers["Boy"],
        kilo = answers["Kilo"],
        yas = answers["Yas"],
        kTansiyon = answers["kTansiyon"],
        bTansiyon = answers["bTansiyon"],
        glikoz = answers["Glikoz"],
        kolesterol = answers["Kolesterol"],
        gender = answers["Gender"] ? 2 : 1,
        bMI = answers["BMI"];

    print(answers);
    print("BMI:" + bMI.toString());
    if (isDiyabet) {
      return [
        [
          glikoz == 1
              ? 85.0
              : glikoz == 2
                  ? 112.5
                  : 130.0
        ],
        [bMI.toDouble()],
        [yas.toDouble()]
      ];
    } else {
      return [
        [yas.toDouble()],
        [gender.toDouble()],
        [boy.toDouble()],
        [kilo.toDouble()],
        [bTansiyon.toDouble()],
        [kTansiyon.toDouble()],
        [kolesterol.toDouble()],
        [glikoz.toDouble()]
      ];
    }
  }
}

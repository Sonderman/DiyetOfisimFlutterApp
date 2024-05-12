import 'package:flutter/foundation.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class Classifier {
  final _diyabetModel = 'assets/diyabet.tflite';
  final _kalpModel = 'assets/kalpdamar.tflite';
  late Interpreter _interpreterDiyabet, _interpreterKalp;

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
    var outputDiyabet = List.filled(2, 0).reshape([1, 1]);
    var outputKalp = List.filled(2, 0).reshape([1, 1]);
    List<List<double>> inputDiyabet = answerConverter(answers, true);
    List<List<double>> inputKalp = answerConverter(answers, false);
    _interpreterDiyabet.run(inputDiyabet, outputDiyabet);
    _interpreterKalp.run(inputKalp, outputKalp);

    if (kDebugMode) {
      print("Diyabet:${(outputDiyabet[0][0] as double).round()}");
    }
    if (kDebugMode) {
      print("Kalp:${(outputKalp[0][0] as double).round()}");
    }
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

    if (kDebugMode) {
      print(answers);
    }
    if (kDebugMode) {
      print("BMI:$bMI");
    }
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

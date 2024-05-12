import 'package:diyet_ofisim/Pages/Patient/DieticianListPage.dart';
import 'package:diyet_ofisim/Settings/AppSettings.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class InspectionSummaryPage extends StatefulWidget {
  final List<Diseases> results;
  final double bmi;
  final String kgRange;

  const InspectionSummaryPage(
      {super.key,
      required this.results,
      required this.bmi,
      required this.kgRange});

  @override
  State<InspectionSummaryPage> createState() => _InspectionSummaryPageState();
}

class _InspectionSummaryPageState extends State<InspectionSummaryPage> {
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(widget.results);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danışan  Bilgilendirme  Sayfası"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                      width: 2, color: Colors.deepPurpleAccent[100]!)),
              height: PageComponents(context).heightSize(20),
              width: PageComponents(context).widthSize(100),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Text(
                      "Beden Kitle İndexsiniz : " "${widget.bmi.toInt()}",
                      style: const TextStyle(fontSize: 20, color: Colors.green),
                    ),
                  ),
                  const Divider(),
                  Container(
                    margin: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(
                      "Kilo Aralığınız  : ${widget.kgRange}",
                      style: TextStyle(fontSize: 20, color: Colors.blue[400]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: PageComponents(context).heightSize(20),
            width: PageComponents(context).widthSize(250),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (widget.results.contains(Diseases.anoreksiya))
                  const Text(
                    "Anoreksi (Yeme Bozukluğu) Risk\n             Grubundasınız !",
                    style: TextStyle(color: Colors.redAccent, fontSize: 23),
                  ),
                if (widget.results.contains(Diseases.obezite))
                  const Text("Obezite Risk Grubundasınız !",
                      style: TextStyle(color: Colors.redAccent, fontSize: 23)),
                if (widget.results.contains(Diseases.diyabet))
                  const Text("Diyabet Hastalığı Risk Grubundasınız !",
                      style: TextStyle(color: Colors.redAccent, fontSize: 23)),
                if (widget.results.contains(Diseases.kalpDamar))
                  const Text("Kalp-Damar Hastalığı Risk Grubundasınız !",
                      style: TextStyle(color: Colors.redAccent, fontSize: 23))
                else
                  Row(
                    children: [
                      Icon(Icons.check, color: Colors.green[300], size: 35),
                      Text("Herhangi bir hastalık riskiniz bulunmamaktadır",
                          style: TextStyle(
                              color: Colors.green[300], fontSize: 19)),
                    ],
                  ),
              ],
            ),
          ),
          SizedBox(
            height: PageComponents(context).heightSize(10),
          ),
          Center(
            child: Container(
                clipBehavior: Clip.none,
                color: Colors.white,
                margin: const EdgeInsets.all(10),
                height: 42,
                width: MediaQuery.of(context).size.width - 100,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            DieticianListPage(results: widget.results),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_right),
                  label: const Text(
                    "Uygun Diyetisyene Yönlendirilmek İçin Tıklayınız",
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(6.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    elevation: 6.0, // Adjust as needed
                  ),
                )),
          )
        ],
      ),
    );
  }

  String kiloAraligi(String kgRange) {
    return kgRange;
  }
}

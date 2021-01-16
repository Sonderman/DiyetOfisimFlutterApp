import 'package:diyet_ofisim/Pages/Patient/DieticianListPage.dart';
import 'package:diyet_ofisim/Settings/AppSettings.dart';
import 'package:flutter/material.dart';

class InspectionSummaryPage extends StatefulWidget {
  final List<Diseases> results;

  const InspectionSummaryPage({Key key, this.results}) : super(key: key);

  @override
  _InspectionSummaryPageState createState() => _InspectionSummaryPageState();
}

class _InspectionSummaryPageState extends State<InspectionSummaryPage> {
  @override
  Widget build(BuildContext context) {
    print(widget.results);
    return Scaffold(
      body: Column(
        children: [
          MaterialButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          DieticianListPage(results: widget.results)));
            },
            child: Text("Diyetisyen Ara"),
          )
        ],
      ),
    );
  }
}

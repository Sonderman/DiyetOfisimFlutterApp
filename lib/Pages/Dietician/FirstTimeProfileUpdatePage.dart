import 'package:diyet_ofisim/Models/Dietician.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Settings/AppSettings.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class FirstTimeProfileUpdatePage extends StatefulWidget {
  final rootPageState;
  FirstTimeProfileUpdatePage({Key key, this.rootPageState}) : super(key: key);

  @override
  _FirstTimeProfileUpdatePageState createState() =>
      _FirstTimeProfileUpdatePageState();
}

class _FirstTimeProfileUpdatePageState
    extends State<FirstTimeProfileUpdatePage> {
  TextEditingController aboutTextCon = TextEditingController();
  List diseases;
  TextEditingController educationTextCon = TextEditingController();
  TextEditingController experiencesTextCon = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? PageComponents(context).loadingOverlay()
          : Center(
              child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Profilinizi Oluşturun",
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  height: PageComponents(context).heightSize(15),
                ),
                TextFormField(
                  controller: aboutTextCon,
                  maxLines: 5,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: "Hakkımda",
                  ),
                ),
                MultiSelectFormField(
                  chipBackGroundColor: Colors.green,
                  chipLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                  dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
                  checkBoxActiveColor: Colors.blue,
                  checkBoxCheckColor: Colors.black,
                  dialogShapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  title: Text(
                    "Tedavi edebileceğiniz hastalıklar",
                    style: TextStyle(fontSize: 16),
                  ),
                  dataSource: dataParser(),
                  textField: 'title',
                  valueField: 'value',
                  okButtonLabel: 'TAMAM',
                  cancelButtonLabel: 'İPTAL',
                  hintWidget:
                      Text('Lütfen bir veya daha fazla hastalık seçiniz'),
                  onSaved: (value) {
                    if (value == null) return;
                    setState(() {
                      diseases = value;
                    });
                  },
                ),
                TextFormField(
                  controller: educationTextCon,
                  maxLines: 3,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: "Eğitim",
                  ),
                ),
                TextFormField(
                  controller: experiencesTextCon,
                  maxLines: 5,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: "Deneyimler",
                  ),
                ),
                SizedBox(
                  height: PageComponents(context).heightSize(15),
                ),
                MaterialButton(
                  color: Colors.blue,
                  onPressed: () {
                    var user = locator<UserService>().userModel as Dietician;
                    setState(() {
                      isLoading = true;
                    });
                    user.about = aboutTextCon.text;
                    user.treatments = diseases;
                    user.education = educationTextCon.text;
                    user.experiences = experiencesTextCon.text;
                    locator<UserService>().updateUserProfile().then((value) {
                      if (!value)
                        setState(() {
                          isLoading = false;
                        });
                      else
                        locator<UserService>()
                            .insertNewDietician()
                            .then((value) {
                          if (value)
                            widget.rootPageState.setState(() {
                              print("FirstTimeProfile Update Başarılı");
                            });
                          else
                            print("Diyetisyen eklenirken hata!!");
                        });
                    });
                  },
                  textColor: Colors.white,
                  child: Text("Kaydet"),
                )
              ],
            )),
    );
  }

  List<Map> dataParser() {
    List<Map> temp = [];
    num i = 0;
    AppSettings().diseases.forEach((e) {
      temp.add({
        "title": e,
        "value": i,
      });
      i++;
    });
    return temp;
  }
}

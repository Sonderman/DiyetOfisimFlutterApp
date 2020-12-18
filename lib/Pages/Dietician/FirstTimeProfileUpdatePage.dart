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
  List insuranceType;
  
  TextEditingController educationTextCon = TextEditingController();
  TextEditingController experiencesTextCon = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Prolinizi Tamamlayınız",
          style: TextStyle(fontSize: 20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: isLoading
          ? PageComponents(context).loadingOverlay()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(35.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //Hakkımda Bölümü
                    TextFormField(
                      controller: aboutTextCon,
                      maxLines: 10,
                      minLines: 1,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 5),
                        labelText: "Hakkımda",
                        labelStyle: TextStyle(
                            color: Colors.deepPurpleAccent[100], fontSize: 30),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText:
                            "Hakkınızda Yazmanız Gereken Bilgileri Yazınız",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      height: PageComponents(context).heightSize(5),
                    ),

                    //Eğitim Bölümü
                    TextFormField(
                      controller: educationTextCon,
                      maxLines: 5,
                      minLines: 1,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 5),
                        labelText: "Okullar / Eğitim",
                        labelStyle: TextStyle(
                            color: Colors.deepPurpleAccent[100], fontSize: 30),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText:
                            "Mezun Olduğunuz Üniversiteyi ve Okulları Yazınız",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      height: PageComponents(context).heightSize(5),
                    ),

                    //Deneyim Bölümü
                    TextFormField(
                      controller: experiencesTextCon,
                      maxLines: 10,
                      minLines: 1,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 5),
                        labelText: "Deneyimler",
                        labelStyle: TextStyle(
                            color: Colors.deepPurpleAccent[100], fontSize: 30),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: "Çalıştığınız Kurum ve Hastaneleri Yazınız",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      height: PageComponents(context).heightSize(5),
                    ),

                    MultiSelectFormField(
                      chipBackGroundColor: Colors.green,
                      chipLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                      dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
                      checkBoxActiveColor: Colors.deepPurpleAccent[100],
                      checkBoxCheckColor: Colors.white,
                      dialogShapeBorder: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                      title: Text(
                        "Tedavi ettiğiniz hastalıklar",
                        style: TextStyle(
                            fontSize: 20, color: Colors.deepPurpleAccent[100]),
                      ),
                      dataSource: dataParser(),
                      textField: 'title',
                      valueField: 'value',
                      okButtonLabel: 'TAMAM',
                      cancelButtonLabel: 'İPTAL',
                      hintWidget: Text(
                          'Lütfen bir veya daha fazla hastalık seçiniz',
                          style: TextStyle(color: Colors.grey)),
                      onSaved: (value) {
                        if (value == null) return;
                        setState(() {
                          diseases = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: PageComponents(context).heightSize(5),
                    ),
                    MultiSelectFormField(
                      chipBackGroundColor: Colors.green,
                      chipLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                      dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
                      checkBoxActiveColor: Colors.deepPurpleAccent[100],
                      checkBoxCheckColor: Colors.white,
                      dialogShapeBorder: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                      title: Text(
                        "Sigortalı / Sigortasız Hastalar",
                        style: TextStyle(
                            fontSize: 20, color: Colors.deepPurpleAccent[100]),
                      ),
                      dataSource: insurance(),
                      textField: 'title',
                      valueField: 'value',
                      okButtonLabel: 'TAMAM',
                      cancelButtonLabel: 'İPTAL',
                      hintWidget: Text(
                          'Lütfen hangi hasta tipi ile görüşebileceğinizi seçiniz',
                          style: TextStyle(color: Colors.grey)),
                      onSaved: (value) {
                        if (value == null) return;
                        setState(() {
                          insuranceType = value;
                        });
                      },
                    ),

                    SizedBox(
                      height: PageComponents(context).heightSize(5),
                    ),
               
                    SizedBox(
                      height: PageComponents(context).heightSize(10),
                    ),
                    MaterialButton(
                      color: Colors.deepPurpleAccent[100],
                      padding:
                          EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                      onPressed: () {
                        var user =
                            locator<UserService>().userModel as Dietician;
                        setState(() {
                          isLoading = true;
                        });
                        user.about = aboutTextCon.text;
                        user.treatments = diseases;
                        user.education = educationTextCon.text;
                        user.experiences = experiencesTextCon.text;
                        locator<UserService>()
                            .updateUserProfile()
                            .then((value) {
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
                      child: Text(
                        "Kaydet",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
            ),
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

  List<Map> insurance() {
    List<Map> temp = [];
    num i = 0;
    AppSettings().insuranceType.forEach((e) {
      temp.add({
        "title": e,
        "value": i,
      });
      i++;
    });
    return temp;
  }

}

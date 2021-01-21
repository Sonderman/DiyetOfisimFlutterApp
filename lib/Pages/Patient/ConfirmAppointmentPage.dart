import 'package:dash_chat/dash_chat.dart';
import 'package:diyet_ofisim/Models/Appointment.dart';
import 'package:diyet_ofisim/Models/Dietician.dart';
import 'package:diyet_ofisim/Models/Patient.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ConfirmAppointmentPage extends StatefulWidget {
  final Dietician dModel;
  final int year, month, day;
  final String hour;

  const ConfirmAppointmentPage(
      {Key key, this.year, this.month, this.day, this.hour, this.dModel})
      : super(key: key);

  @override
  _ConfirmAppointmentPageState createState() => _ConfirmAppointmentPageState();
}

class _ConfirmAppointmentPageState extends State<ConfirmAppointmentPage> {
  UserService userService = locator<UserService>();
  Patient usermodel;
  FocusNode _focusNode;
  int maxLine;
  TextEditingController nameC = TextEditingController();
  TextEditingController surnameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController extraC = TextEditingController();
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    usermodel = userService.userModel;
    nameC.text = usermodel.name;
    surnameC.text = usermodel.surname;
    emailC.text = usermodel.email;

    _focusNode.addListener(() {
      setState(() {
        if (_focusNode.hasFocus) {
          maxLine = 5;
        } else {
          maxLine = 1;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Randevu Onayla"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
        child: Form(
          child: ListView(
            children: [
              randevuDetayi(),
              SizedBox(
                height: PageComponents(context).heightSize(6),
              ),
              TextFormField(
                controller: nameC,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  prefixIcon: Icon(Icons.supervised_user_circle_sharp),
                  labelText: "Adınız*",
                ),
              ),
              SizedBox(
                height: PageComponents(context).heightSize(3),
              ),
              TextFormField(
                controller: surnameC,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  prefixIcon: Icon(Icons.supervised_user_circle_sharp),
                  labelText: "Soyadınız*",
                ),
              ),
              SizedBox(
                height: PageComponents(context).heightSize(3),
              ),
              TextFormField(
                controller: emailC,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  prefixIcon: Icon(Icons.email),
                  labelText: "Email Adresiniz*",
                ),
              ),
              SizedBox(
                height: PageComponents(context).heightSize(3),
              ),
              TextFormField(
                controller: extraC,
                focusNode: _focusNode,
                maxLines: maxLine,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[300]),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    prefixIcon: Icon(Icons.edit),
                    hintText:
                        "Diyetisyeninizin randevunuzla alakalı bilmesi gereken bir bilgi varsa yazınız",
                    labelText: "Diyetisyeniniz için ek bilgi (zorunlu değil)"),
              ),
              SizedBox(
                height: PageComponents(context).heightSize(5),
              ),
              Center(
                child: Container(
                  clipBehavior: Clip.none,
                  color: Colors.white,
                  margin: EdgeInsets.all(6.0),
                  height: 42,
                  width: MediaQuery.of(context).size.width - 250,
                  child: RaisedButton.icon(
                    elevation: 6,
                    textColor: Colors.white,
                    color: Colors.deepPurpleAccent[100],
                    padding: const EdgeInsets.all(6.0),
                    icon: Icon(Icons.save_alt_outlined),
                    label: Text("ONAYLA"),
                    onPressed: () {
                      Appointment appointment = Appointment();
                      appointment.name = nameC.text;
                      appointment.surname = surnameC.text;
                      appointment.email = emailC.text;
                      appointment.dID = widget.dModel.id;
                      appointment.pID = usermodel.id;
                      appointment.extra = extraC.text;
                      appointment.year = widget.year;
                      appointment.month = widget.month;
                      appointment.day = widget.day;
                      appointment.hour = widget.hour;
                      appointment.status = 0;
                      userService.createAppointment(appointment).then((value) {
                        if (value) {
                          print("Randevu Oluşturuldu");
                          Navigator.popUntil(context, (route) => route.isFirst);
                        } else
                          print("Hata!!");
                      });
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget randevuDetayi() {
    DateTime date = DateTime(widget.year, widget.month, widget.day);
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(width: 2, color: Colors.deepPurpleAccent[100])),
      width: PageComponents(context).widthSize(17),
      height: PageComponents(context).heightSize(22),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  height: PageComponents(context).heightSize(8),
                  width: PageComponents(context).widthSize(15),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    //shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: ExtendedNetworkImageProvider(
                          widget.dModel.profilePhotoUrl,
                          cache: true),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: PageComponents(context).widthSize(5),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 5),
                child: Text(
                  widget.dModel.name + " " + widget.dModel.surname,
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10),
                height: PageComponents(context).heightSize(5),
                width: PageComponents(context).widthSize(5),
                child: Icon(Icons.date_range),
              ),
              SizedBox(
                width: PageComponents(context).widthSize(3),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 2),
                child: Text(
                  "Randevu Tarihi :   " +
                      widget.day.toString() +
                      " " +
                      DateFormat("MMM", "tr").format(date) +
                      " " +
                      DateFormat("EEEE", "tr").format(date),
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

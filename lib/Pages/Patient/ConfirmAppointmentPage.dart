import 'package:diyet_ofisim/Models/Appointment.dart';
import 'package:diyet_ofisim/Models/Dietician.dart';
import 'package:diyet_ofisim/Models/Patient.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class ConfirmAppointmentPage extends StatefulWidget {
  final Dietician dModel;
  final DateTime date;

  const ConfirmAppointmentPage({super.key, required this.date, required this.dModel});

  @override
  State<ConfirmAppointmentPage> createState() => _ConfirmAppointmentPageState();
}

class _ConfirmAppointmentPageState extends State<ConfirmAppointmentPage> {
  UserService userService = locator<UserService>();
  late Patient usermodel;
  late FocusNode _focusNode;
  late int maxLine;
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
        title: const Text("Randevu Onayla"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
        child: Form(
          child: ListView(
            children: [
              randevuDetayi(),
              SizedBox(height: PageComponents(context).heightSize(6)),
              TextFormField(
                controller: nameC,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  prefixIcon: const Icon(Icons.supervised_user_circle_sharp),
                  labelText: "Adınız*",
                ),
              ),
              SizedBox(height: PageComponents(context).heightSize(3)),
              TextFormField(
                controller: surnameC,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  prefixIcon: const Icon(Icons.supervised_user_circle_sharp),
                  labelText: "Soyadınız*",
                ),
              ),
              SizedBox(height: PageComponents(context).heightSize(3)),
              TextFormField(
                controller: emailC,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  prefixIcon: const Icon(Icons.email),
                  labelText: "Email Adresiniz*",
                ),
              ),
              SizedBox(height: PageComponents(context).heightSize(3)),
              TextFormField(
                controller: extraC,
                focusNode: _focusNode,
                maxLines: maxLine,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  prefixIcon: const Icon(Icons.edit),
                  hintText:
                      "Diyetisyeninizin randevunuzla alakalı bilmesi gereken bir bilgi varsa yazınız",
                  labelText: "Diyetisyeniniz için ek bilgi (zorunlu değil)",
                ),
              ),
              SizedBox(height: PageComponents(context).heightSize(5)),
              Center(
                child: Container(
                  clipBehavior: Clip.none,
                  color: Colors.white,
                  margin: const EdgeInsets.all(6.0),
                  height: 42,
                  width: MediaQuery.of(context).size.width - 250,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Appointment appointment = Appointment();
                      appointment.name = nameC.text;
                      appointment.surname = surnameC.text;
                      appointment.email = emailC.text;
                      appointment.dID = widget.dModel.id;
                      appointment.pID = usermodel.id;
                      appointment.extra = extraC.text;
                      appointment.date = widget.date;
                      appointment.status = 0;

                      userService.createAppointment(appointment).then((value) {
                        if (value) {
                          if (kDebugMode) {
                            print("Randevu Oluşturuldu");
                          }
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Fluttertoast.showToast(
                            msg: "Randevunuz Başarıyla Oluşturuldu.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 18.0,
                          );
                        } else {
                          if (kDebugMode) {
                            print("Hata!!");
                          }
                        }
                      });
                    },
                    icon: const Icon(Icons.save_alt_outlined),
                    label: const Text("ONAYLA"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(6.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      elevation: 6.0, // Adjust as needed
                    ),
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
    DateTime date = widget.date;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(width: 2, color: Colors.deepPurpleAccent[100]!),
      ),
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    //shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: ExtendedNetworkImageProvider(
                        widget.dModel.profilePhotoUrl,
                        cache: true,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: PageComponents(context).widthSize(5)),
              Container(
                margin: const EdgeInsets.only(top: 5, bottom: 5),
                child: Text(
                  "${widget.dModel.name} ${widget.dModel.surname}",
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10),
                height: PageComponents(context).heightSize(5),
                width: PageComponents(context).widthSize(5),
                child: const Icon(Icons.date_range),
              ),
              SizedBox(width: PageComponents(context).widthSize(3)),
              Container(
                margin: const EdgeInsets.only(top: 5, bottom: 2),
                child: Text(
                  "${"Randevu Tarihi :   ${date.day} ${DateFormat("MMM", "tr").format(date)}"} ${DateFormat("EEEE", "tr").format(date)}",
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:dash_chat/dash_chat.dart';
import 'package:diyet_ofisim/Models/Appointment.dart';
import 'package:diyet_ofisim/Models/Dietician.dart';
import 'package:diyet_ofisim/Tools/Dialogs.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:extended_image/extended_image.dart';
import "package:flutter/material.dart";

class AppointmentDetail extends StatefulWidget {
  final Dietician dModel;
  final Appointment aModel;

  const AppointmentDetail({Key key, this.dModel, this.aModel})
      : super(key: key);

  @override
  _AppointmentDetailState createState() => _AppointmentDetailState();
}

class _AppointmentDetailState extends State<AppointmentDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Randevu Detayları",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: bodyContainer(),
    );
  }

  Widget bodyContainer() {
    DateTime date =
        DateTime(widget.aModel.year, widget.aModel.month, widget.aModel.day);
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 5, left: 10, right: 10),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          baslik("Diyetisyeniniz"),
          diyetisyeniniz(),
          Divider(),
          baslik("Hasta/Danışan"),
          icerik(widget.aModel.name + " " + widget.aModel.surname,
              Icon(Icons.person)),
          Divider(),
          baslik("Randevu Özeti"),
          icerik(
              widget.aModel.day.toString() +
                  "." +
                  widget.aModel.month.toString() +
                  "." +
                  widget.aModel.year.toString() +
                  " " +
                  DateFormat("EEEE", "tr").format(date),
              Icon(Icons.date_range)),
          icerik(widget.aModel.hour, Icon(Icons.timer)),
          Divider(),
          baslik("Kabul Edilen Ödeme Şekli"),
          icerik("Nakit / Kredi Kartı", Icon(Icons.money)),
          Visibility(visible: widget.aModel.status == 0, child: butonBar()),
        ],
      ),
    );
  }

  Widget diyetisyeniniz() {
    return Container(
      height: PageComponents(context).heightSize(12),
      width: PageComponents(context).widthSize(100),
      margin: EdgeInsets.only(left: 5, top: 15, bottom: 10),
      child: Row(
        children: [
          Container(
            width: PageComponents(context).widthSize(25),
            decoration: new BoxDecoration(
              //borderRadius: BorderRadius.circular(0),
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: ExtendedNetworkImageProvider(
                    widget.dModel.profilePhotoUrl,
                    cache: true),
              ),
            ),
          ),
          SizedBox(
            width: PageComponents(context).widthSize(5),
          ),
          Text(
            widget.dModel.name + " " + widget.dModel.surname,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget baslik(String baslik) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Text(
        baslik.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.deepPurpleAccent[100], fontSize: 17),
      ),
    );
  }

  Widget icerik(String icerik, Icon iconAdi) {
    return Row(
      children: [
        iconAdi,
        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          child: Text(
            icerik,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, fontSize: 17),
          ),
        )
      ],
    );
  }

  Widget butonBar() {
    return Center(
      child: Container(
        clipBehavior: Clip.none,
        color: Colors.white,
        margin: EdgeInsets.only(top: 100),
        height: 42,
        width: MediaQuery.of(context).size.width - 15,
        child: RaisedButton.icon(
          elevation: 6,
          textColor: Colors.white,
          color: Colors.deepPurpleAccent[100],
          padding: const EdgeInsets.all(6.0),
          icon: Icon(Icons.date_range),
          label: Text("RANDEVUNU iPTAL ET"),
          onPressed: () {
            appointmentCancelAsking(context, widget.aModel).then((value) {
              if (value) {
                print("Randevu silindi");
                Navigator.pop(context, true);
              }
            });
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
      ),
    );
  }
}

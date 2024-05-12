import 'package:diyet_ofisim/Models/Appointment.dart';
import 'package:diyet_ofisim/Models/Dietician.dart';
import 'package:diyet_ofisim/Tools/Dialogs.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";

class AppointmentDetail extends StatefulWidget {
  final Dietician dModel;
  final Appointment aModel;

  const AppointmentDetail(
      {super.key, required this.dModel, required this.aModel});

  @override
  State<AppointmentDetail> createState() => _AppointmentDetailState();
}

class _AppointmentDetailState extends State<AppointmentDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
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
    DateTime date = widget.aModel.date;
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 5, left: 10, right: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          baslik("Diyetisyeniniz"),
          diyetisyeniniz(),
          const Divider(),
          baslik("Hasta/Danışan"),
          icerik("${widget.aModel.name} ${widget.aModel.surname}",
              const Icon(Icons.person)),
          const Divider(),
          baslik("Randevu Özeti"),
          icerik("${date.day}.${date.month}.${date.year} ",
              const Icon(Icons.date_range)),
          icerik(date.hour.toString(), const Icon(Icons.timer)),
          const Divider(),
          baslik("Kabul Edilen Ödeme Şekli"),
          icerik("Nakit / Kredi Kartı", const Icon(Icons.money)),
          Visibility(visible: widget.aModel.status == 0, child: butonBar()),
        ],
      ),
    );
  }

  Widget diyetisyeniniz() {
    return Container(
      height: PageComponents(context).heightSize(12),
      width: PageComponents(context).widthSize(100),
      margin: const EdgeInsets.only(left: 5, top: 15, bottom: 10),
      child: Row(
        children: [
          Container(
            width: PageComponents(context).widthSize(25),
            decoration: BoxDecoration(
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
            "${widget.dModel.name} ${widget.dModel.surname}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget baslik(String baslik) {
    return Container(
      padding: const EdgeInsets.all(10),
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
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          child: Text(
            icerik,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54, fontSize: 17),
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
        margin: const EdgeInsets.only(top: 100),
        height: 42,
        width: MediaQuery.of(context).size.width - 15,
        child: ElevatedButton.icon(
          onPressed: () {
            appointmentCancelAsking(context, widget.aModel).then((value) {
              if (value) {
                if (kDebugMode) {
                  print("Randevu silindi");
                }
                Navigator.pop(context, true);
              }
            });
          },
          icon: const Icon(Icons.date_range),
          label: const Text(
              "RANDEVUNU İPTAL ET"), // Changed "iPTAL" to uppercase for consistency
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(6.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            elevation: 6.0, // Adjust as needed
          ),
        ),
      ),
    );
  }
}

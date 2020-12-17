import "package:flutter/material.dart";

class AppointmentDetail extends StatefulWidget {
  final String diyetisyenAdi, imgPath;

  const AppointmentDetail({Key key, this.diyetisyenAdi, this.imgPath})
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
          icerik("Çiğdem Atak", Icon(Icons.person)),
          Divider(),
          baslik("Randevu Özeti"),
          icerik("02.11.2020", Icon(Icons.date_range)),
          icerik("11.00", Icon(Icons.timer)),
          Divider(),
          baslik("Kabul Edilen Ödeme Şekli"),
          icerik("Nakit / Kredi Kartı", Icon(Icons.money)),
          butonBar(),
        ],
      ),
    );
  }

  Widget diyetisyeniniz() {
    return Container(
      height: 70,
      width: 500,
      margin: EdgeInsets.only(left: 25, top: 15),
      child: Row(
        children: [
          Container(
            //color: Colors.amber,
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              image: DecorationImage(
                  image: AssetImage(widget.imgPath), fit: BoxFit.cover),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            widget.diyetisyenAdi,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
        margin: EdgeInsets.only(top: 150),
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
            setState(() {
              alertDialogWidget(context);
            });
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
      ),
    );
  }

  Widget alertDialogWidget(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            title: Text(
              "Uyarı",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.redAccent[400]),
            ),
            content:
                Text("Randevunuzu İptal Etmek İstediğinize \nEmin misiniz ? "),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            actions: <Widget>[
              Container(
                width: 150,
                child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).pop(MaterialPageRoute(
                          builder: (context) => AppointmentDetail()));
                    });
                  },
                  child: Text(
                    "Vazgeç".toUpperCase(),
                    style: TextStyle(
                        color: Colors.deepPurpleAccent.shade100, fontSize: 15),
                  ),
                  //color: Colors.white,
                ),
              ),
              Container(
                width: 150,
                child: MaterialButton(
                  onPressed: () {},
                  child: Text(
                    "Evet".toUpperCase(),
                    style: TextStyle(
                        color: Colors.deepPurpleAccent.shade100, fontSize: 15),
                  ),
                  //color: Colors.white,
                ),
              ),
            ],
          );
        });
  }
}

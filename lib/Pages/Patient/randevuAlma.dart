import 'package:flutter/material.dart';

class RandevuAlma extends StatefulWidget {
  @override
  _RandevuAlmaState createState() => _RandevuAlmaState();
}

class _RandevuAlmaState extends State<RandevuAlma> {
  FocusNode _focusNode;
  int maxLine;
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

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
        title: Text("Randevu Al"),
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
                height: 50,
              ),
              TextFormField(
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
                height: 30,
              ),
              TextFormField(
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
                  prefixIcon: Icon(Icons.supervised_user_circle_sharp),
                  labelText: "Soyadınız*",
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
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
                height: 30,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
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
                height: 40,
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
                    label: Text("KAYDET"),
                    onPressed: () {},
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
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(width: 2, color: Colors.deepPurpleAccent[100])),
      width: MediaQuery.of(context).size.width,
      height: 170,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/photo/nutri.jpg"),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(
                width: 25,
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 5),
                child: Text(
                  "Uzm. Dyt. Rumeysa Ayvalı",
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
                height: 60,
                width: 60,
                child: Icon(Icons.date_range),
              ),
              SizedBox(
                width: 25,
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 5),
                child: Text(
                  "Randevu Tarihi :  14 Aralık Pazar\nRandevu Saati :  17.00",
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

import 'package:diyet_ofisim/assets/Colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SpinKitRing(
          color: MyColors().indiagoLoadingSplash,
          size: 50.0,
        ),
      ),
    );
  }
}

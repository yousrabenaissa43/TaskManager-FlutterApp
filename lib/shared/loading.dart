import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF0A7BCFF),
      child: Center(
        child: SpinKitChasingDots(
          color: Color(0xFF80638DFF),
          size: 50.0,
        ),
      ),
    );
  }
}

library easy_otpfield;
import 'package:easy_otpfield/easy_otpfield.dart';
import 'package:flutter/material.dart';

void main() {
 runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Custom Otp Field "),),
    body:  customOtpfield(),);
  }
  
}

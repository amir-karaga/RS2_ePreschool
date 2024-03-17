import 'package:epreschool_mobile/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../utils/button.dart';

class PaymentSuccess extends StatelessWidget {
  const PaymentSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Lottie.asset('assets/success.json'),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                "Placanje uspjesno",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            //back to home page
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Button(
                width: double.infinity,
                title: "Početna",
                onPressed: () => {
                  Navigator.pop(context),
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()))
                },
                disable: false,
              ),
            )
          ],
        ),
      ),
    );
  }
}

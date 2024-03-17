import 'package:epreschool_mobile/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../providers/login_provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "home";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        child: SingleChildScrollView(
          child: Container(
            child:Center(
              heightFactor: 2,
              child:Text("Dobrodošli ${LoginProvider.authResponse!.firstName} ${LoginProvider.authResponse!.lastName}",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20))
            )
          )
        )
    );
  }
}

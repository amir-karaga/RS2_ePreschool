import 'package:epreschool_mobile/models/child.dart';
import 'package:epreschool_mobile/screens/employees/employee_list_screen.dart';
import 'package:epreschool_mobile/screens/home/home_screen.dart';
import 'package:epreschool_mobile/screens/news/new_list_screen.dart';
import 'package:epreschool_mobile/screens/parents/parent_list_screen.dart';
import 'package:epreschool_mobile/screens/payments/payment_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../providers/login_provider.dart';
import '../screens/children/child_list_screen.dart';
import '../screens/login/login_screen.dart';

class ePreschoolDrawer extends StatelessWidget {
  ePreschoolDrawer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'ePreschool',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Početna'),
            onTap: () {
              Navigator.popAndPushNamed(context, HomeScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.newspaper),
            title: Text('Obavijesti'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NewListScreen(),
                ),
              );
            },
          ),
          if(LoginProvider.authResponse!.isAdministrator! || LoginProvider.authResponse!.isPreschoolOwner!) ListTile(
            leading: Icon(Icons.man_4),
            title: Text('Odagajatelji'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EmployeeListScreen(),
                ),
              );
            },
          ),
          if(LoginProvider.authResponse!.isPreschoolOwner! || LoginProvider.authResponse!.isEmployee!) ListTile(
            leading: Icon(Icons.man_4),
            title: Text('Roditelji'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ParentListScreen(),
                ),
              );
            },
          ),
          if(LoginProvider.authResponse!.isParent!) ListTile(
            leading: Icon(Icons.man_4),
            title: Text('Odgajatelji'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EmployeeListScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.child_care_outlined),
            title: Text('Djeca'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChildListScreen(),
                ),
              );
            },
          ),
          if(LoginProvider.authResponse!.isPreschoolOwner! || LoginProvider.authResponse!.isParent!) ListTile(
            leading: Icon(Icons.payments),
            title: Text('Mjesečne uplate'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PaymentListScreen(),
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Odjavi se"),
            onTap: () {
              LoginProvider.setResponseFalse();
              //Navigator.popAndPushNamed(context, LoginScreen.routeName);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
import 'package:epreschool_admin/helpers/localizationHelper.dart';
import 'package:epreschool_admin/models/language.dart';
import 'package:epreschool_admin/providers/login_provider.dart';
import 'package:epreschool_admin/screens/cities/city_list_screen.dart';
import 'package:epreschool_admin/screens/companies/companies_list_screen.dart';
import 'package:epreschool_admin/screens/countries/country_list_screen.dart';
import 'package:epreschool_admin/screens/employees/employee_list_screen.dart';
import 'package:epreschool_admin/screens/home/home_screen.dart';
import 'package:epreschool_admin/screens/login/login_screen.dart';
import 'package:epreschool_admin/screens/news/new_list_screen.dart';
import 'package:epreschool_admin/screens/parents/parent_list_screen.dart';
import 'package:epreschool_admin/screens/payments/payment_list_screen.dart';
import 'package:epreschool_admin/screens/settings/settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../screens/children/child_list_screen.dart';

class ePreschoolDrawer extends StatefulWidget {
  @override
  _ePreschoolDrawerState createState() => _ePreschoolDrawerState();
}
 class _ePreschoolDrawerState extends State<ePreschoolDrawer> {
   List<Language> supportedLanguages = LocalizationHelper.getSupportedLanguages();
    late Language selectedLanguage;

   @override
   void initState() {
     super.initState();
   }
  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    var currentLocale = localizationDelegate.currentLocale;
    selectedLanguage = supportedLanguages.firstWhere((lng) => lng.languageCode == currentLocale.languageCode+"_"+currentLocale.countryCode!);
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
            title: Text(translate("sidebar.home")),
            onTap: () {
              //Navigator.popAndPushNamed(context, HomeScreen.routeName);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.newspaper),
            title: Text(translate("sidebar.news")),
            onTap: () {
              //Navigator.popAndPushNamed(context, NewListScreen.routeName);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NewListScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.business_outlined),
            title: Text(translate("sidebar.registered_kindergartens")),
            onTap: () {
              //Navigator.popAndPushNamed(context, CompanyListScreen.routeName);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CompanyListScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.man_2),
            title: Text(translate("sidebar.parents")),
            onTap: () {
              //Navigator.popAndPushNamed(context, ParentListScreen.routeName);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ParentListScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.man_4),
            title: Text(translate("sidebar.employees")),
            onTap: () {
              //Navigator.popAndPushNamed(context, EmployeeListScreen.routeName);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EmployeeListScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.child_care_outlined),
            title: Text(translate("sidebar.children")),
            onTap: () {
              //Navigator.popAndPushNamed(context, ChildListScreen.routeName);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChildListScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text(translate("sidebar.payments")),
            onTap: () {
              //Navigator.popAndPushNamed(context, ChildListScreen.routeName);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PaymentListScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.pin_drop),
            title: Text(translate("sidebar.countries")),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CountryListScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.pin_drop),
            title: Text(translate("sidebar.cities")),
            onTap: () {
              //Navigator.popAndPushNamed(context, CityListScreen.routeName);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CityListScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(translate("sidebar.settings")),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.language),
            trailing: DropdownButton<Language>(
              value: selectedLanguage,
              onChanged: (Language? newValue) {
                setState(() {
                  selectedLanguage = newValue!;
                });
                Navigator.pop(context, newValue!.languageCode);
                changeLocale(context, newValue!.languageCode);
              },
              items: supportedLanguages
                  .map<DropdownMenuItem<Language>>((Language value) {
                return DropdownMenuItem<Language>(
                  value: value,
                  child: Text(value.name),
                );
              }).toList(),
            ),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(translate("sidebar.log_out")),
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
import 'dart:io';
import 'package:epreschool_admin/helpers/my_http_overrides.dart';
import 'package:epreschool_admin/providers/appConfigs_provider.dart';
import 'package:epreschool_admin/providers/children_provider.dart';
import 'package:epreschool_admin/providers/cities_provider.dart';
import 'package:epreschool_admin/providers/companies_provider.dart';
import 'package:epreschool_admin/providers/countries_provider.dart';
import 'package:epreschool_admin/providers/employees_provider.dart';
import 'package:epreschool_admin/providers/enum_provider.dart';
import 'package:epreschool_admin/providers/monthlyPayments_provider.dart';
import 'package:epreschool_admin/providers/news_provider.dart';
import 'package:epreschool_admin/providers/parents_provider.dart';
import 'package:epreschool_admin/screens/children/child_add_screen.dart';
import 'package:epreschool_admin/screens/children/child_list_screen.dart';
import 'package:epreschool_admin/screens/cities/city_list_screen.dart';
import 'package:epreschool_admin/screens/companies/companies_list_screen.dart';
import 'package:epreschool_admin/screens/countries/country_list_screen.dart';
import 'package:epreschool_admin/screens/employees/employee_list_screen.dart';
import 'package:epreschool_admin/screens/home/home_screen.dart';
import 'package:epreschool_admin/screens/login/login_screen.dart';
import 'package:epreschool_admin/screens/news/new_add_screen.dart';
import 'package:epreschool_admin/screens/news/new_list_screen.dart';
import 'package:epreschool_admin/screens/parents/parent_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  HttpOverrides.global = MyHttpOverrides();
  var delegate = await LocalizationDelegate.create(
      fallbackLocale: 'en_US',
      supportedLocales: ['en_US', 'ba_BA']);
  runApp(LocalizedApp(delegate, MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CountryProvider()),
          ChangeNotifierProvider(create: (_) => ChildrenProvider()),
          ChangeNotifierProvider(create: (_) => CityProvider()),
          ChangeNotifierProvider(create: (_) => NewsProvider()),
          ChangeNotifierProvider(create: (_) => EmployeesProvider()),
          ChangeNotifierProvider(create: (_) => CompaniesProvider()),
          ChangeNotifierProvider(create: (_) => AppConfigsProvider()),
          ChangeNotifierProvider(create: (_) => ParentsProvider()),
          ChangeNotifierProvider(create: (_) => MonthlyPaymentProvider()),
          ChangeNotifierProvider(create: (_) => EnumProvider())
        ],
        child: MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            localizationDelegate,
          ],
          supportedLocales: [
            const Locale('en', 'US'),
            const Locale('ba', 'BA'),
          ],
          locale: localizationDelegate.currentLocale,
          home: LoginScreen(),
          onGenerateRoute: (settings) {
            if (settings.name == LoginScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => LoginScreen()),
              );
            }
            if (settings.name == HomeScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => HomeScreen()),
              );
            }
            if (settings.name == EmployeeListScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => EmployeeListScreen()),
              );
            }
            if (settings.name == CountryListScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => CountryListScreen()),
              );
            }
            if (settings.name == ChildListScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => ChildListScreen()),
              );
            }
            if (settings.name == CityListScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => CityListScreen()),
              );
            }
            if (settings.name == ChildAddScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => ChildAddScreen()),
              );
            }
            if (settings.name == NewListScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => NewListScreen()),
              );
            }
            if (settings.name == NewAddScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => NewAddScreen()),
              );
            }
            if (settings.name == CompanyListScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => CompanyListScreen()),
              );
            }
            if (settings.name == ParentListScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => ParentListScreen()),
              );
            }
            return MaterialPageRoute(
              builder: ((context) => UnknownScreen()),
            );
          },
        ),
      ),
    );
  }
}

class UnknownScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unknown Screen'),
      ),
      body: Center(
        child: Text('Unknown Screen'),
      ),
    );
  }
}

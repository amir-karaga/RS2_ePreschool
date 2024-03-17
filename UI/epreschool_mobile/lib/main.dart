import 'dart:io';
import 'package:epreschool_mobile/helpers/my_http_overrides.dart';
import 'package:epreschool_mobile/models/monthlyPayment.dart';
import 'package:epreschool_mobile/providers/appConfigs_provider.dart';
import 'package:epreschool_mobile/providers/children_provider.dart';
import 'package:epreschool_mobile/providers/cities_provider.dart';
import 'package:epreschool_mobile/providers/companies_provider.dart';
import 'package:epreschool_mobile/providers/countries_provider.dart';
import 'package:epreschool_mobile/providers/employee_reviews_provider.dart';
import 'package:epreschool_mobile/providers/employees_provider.dart';
import 'package:epreschool_mobile/providers/enum_provider.dart';
import 'package:epreschool_mobile/providers/login_provider.dart';
import 'package:epreschool_mobile/providers/messages_provider.dart';
import 'package:epreschool_mobile/providers/monthly_payment_provider.dart';
import 'package:epreschool_mobile/providers/news_provider.dart';
import 'package:epreschool_mobile/providers/parents_provider.dart';
import 'package:epreschool_mobile/providers/registration_provider.dart';
import 'package:epreschool_mobile/screens/children/child_list_screen.dart';
import 'package:epreschool_mobile/screens/employees/employee_list_screen.dart';
import 'package:epreschool_mobile/screens/home/home_screen.dart';
import 'package:epreschool_mobile/screens/login/login_screen.dart';
import 'package:epreschool_mobile/screens/payments/payment_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");
  HttpOverrides.global = MyHttpOverrides();
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

   return MultiProvider(
     providers: [
       ChangeNotifierProvider(create: (_) => CountryProvider()),
       ChangeNotifierProvider(create: (_) => EnumProvider()),
       ChangeNotifierProvider(create: (_) => CityProvider()),
       ChangeNotifierProvider(create: (_) => EmployeesProvider()),
       ChangeNotifierProvider(create: (_) => MonthlyPaymentProvider()),
       ChangeNotifierProvider(create: (_) => EmployeeReviewsProvider()),
       ChangeNotifierProvider(create: (_) => ParentsProvider()),
       ChangeNotifierProvider(create: (_) => CompaniesProvider()),
       ChangeNotifierProvider(create: (_) => NewsProvider()),
       ChangeNotifierProvider(create: (_) => AppConfigsProvider()),
       ChangeNotifierProvider(create: (_) => MessagesProvider()),
       ChangeNotifierProvider(create: (_) => RegistrationProvider()),
       ChangeNotifierProvider(create: (_) => ChildrenProvider())],
     child: MaterialApp(
     home:LoginScreen(),
     onGenerateRoute: (settings) {
       if (settings.name == HomeScreen.routeName) {
         return MaterialPageRoute(
             builder: ((context) => HomeScreen()));
       }
       if (settings.name == ChildListScreen.routeName) {
         return MaterialPageRoute(
             builder: ((context) => ChildListScreen()));
       }
       if (settings.name == PaymentListScreen.routeName) {
         return MaterialPageRoute(
             builder: ((context) => PaymentListScreen()));
       }
       if (settings.name == EmployeeListScreen.routeName) {
         return MaterialPageRoute(
             builder: ((context) => EmployeeListScreen()));
       }
     },
   ));
  }
  }

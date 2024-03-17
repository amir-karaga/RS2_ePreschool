import 'package:epreschool_admin/helpers/color_constants.dart';
import 'package:epreschool_admin/providers/login_provider.dart';
import 'package:epreschool_admin/screens/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/auth_request.dart';
import '../../models/auth_response.dart';
import '../../utils/constraints.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = "login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _errorMessageController = TextEditingController();
  bool isFailed = false;

  Future<void> _login() async {
    {
      bool result = await LoginProvider.login(
          AuthRequest(_usernameController.text, _passwordController.text));
      if (result && LoginProvider.authResponse!.isAdministrator!) {
        Navigator.popAndPushNamed(context, HomeScreen.routeName);
      } else {
        setState(() {
          isFailed = true;
        });
        _errorMessageController.text = "Korisnicko ime ili lozinka pogresni";
      }
    }
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Login'),
          ),
          body: Center(
            child: Container(
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Dobrodošli u ePreschool",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  SizedBox(height: 20.0),
                  if(isFailed) Text(_errorMessageController.text,  style: TextStyle(
                    color: Colors.red,
                  )),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _usernameController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: "Korisničko ime",
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: 'Unesite svoje korisničko ime',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Unesite email adresu';
                      }
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: "Lozinka",
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: 'Unesite lozinku',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Unesite lozinku';
                      }
                    },
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(kPrimaryColor),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _login();
                            }
                          },
                          child: const Text(
                            'Prijavi se',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

import 'package:epreschool_mobile/screens/registration/registration_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/auth_request.dart';
import '../../providers/login_provider.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = "login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isFailed = false;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _errorMessageController = TextEditingController();

  void initState() {
    super.initState();
  }

  Future<void> _login() async {
    {
      bool result = await LoginProvider.login(
          AuthRequest(_usernameController.text, _passwordController.text));
      if (result && !LoginProvider.authResponse!.isAdministrator!) {
        Navigator.popAndPushNamed(context, HomeScreen.routeName);
      } else {
        setState(() {
          isFailed = true;
        });
        _errorMessageController.text = "Korisnicko ime ili lozinka pogrešni";
      }
    }
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
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Dobrodošli u ePreschool',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20.0),
                  if(isFailed) Text(_errorMessageController.text,  style: TextStyle(
                    color: Colors.red,
                  )),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Korisničko ime',
                      border: OutlineInputBorder(),
                      hintText: 'Unesite korisničko ime',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Lozinka',
                      border: OutlineInputBorder(),
                      hintText: 'Unesite lozinku',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {},
                      child: InkWell(
                        onTap: () async {
                          try {
                            if (_formKey.currentState!.validate()) {
                              _login();
                            }
                          } catch (e) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: Text("Error"),
                                      content: Text(e.toString()),
                                      actions: [
                                        TextButton(
                                          child: Text("Ok"),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        )
                                      ],
                                    ));
                          }
                        },
                        child: Center(child: Text("Login")),
                      ),
                    )),
                    SizedBox(width: 16),
                    Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: InkWell(
                            onTap: () async {
                              try {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegistrationScreen(),
                                    ),
                                  );
                                }
                              } catch (e) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                      title: Text("Error"),
                                      content: Text(e.toString()),
                                      actions: [
                                        TextButton(
                                          child: Text("Ok"),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        )
                                      ],
                                    ));
                              }
                            },
                            child: Center(child: Text("Registracija")),
                          ),
                        ))
                  ]),
                ],
              ),
            ),
          ),
        ));
  }
}

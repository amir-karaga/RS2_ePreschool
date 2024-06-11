import 'package:epreschool_mobile/models/registrationModel.dart';
import 'package:epreschool_mobile/providers/registration_provider.dart';
import 'package:epreschool_mobile/screens/children/child_list_screen.dart';
import 'package:epreschool_mobile/screens/kindergatens/kindergaten_list_screen.dart';
import 'package:epreschool_mobile/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../helpers/DateTimeHelper.dart';
import '../../models/child.dart';
import '../../models/employee.dart';
import '../../models/listItem.dart';
import '../../models/parent.dart';
import '../../providers/enum_provider.dart';

class RegistrationScreen extends StatefulWidget {
  static const String routeName = "registration";
  RegistrationScreen();

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController profilePictureController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController placeOfBirthController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController employerNameController = TextEditingController();
  TextEditingController employerAddressController = TextEditingController();
  TextEditingController employerPhoneNumberController = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  TextEditingController emergencyContactController = TextEditingController();
  TextEditingController specialNeedsController = TextEditingController();
  RegistrationProvider? _registrationProvider;
  EnumProvider? _enumProvider;
  List<ListItem> genders = [];
  List<ListItem> qualifications = [];
  List<ListItem> cities = [];
  List<ListItem> companies = [];
  List<Employee> educators = [];
  ListItem? selectedGender = null;
  ListItem? selectedQualification = null;
  ListItem? selectedMarriageStatus = null;
  ListItem? selectedCity = null;
  ListItem? selectedCompany = null;
  Employee? selectedEducator = null;
  Parent? parent = null;
  dynamic bytes = null;
  DateTime _selectedDate = DateTime.now();
  late Child? data = null;
  bool isFirstSubmit = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        dateOfBirthController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _enumProvider = context.read<EnumProvider>();
    _registrationProvider = context.read<RegistrationProvider>();
    Future.delayed(Duration.zero, () async {
      await loadGenders();
      await loadQualifications();
      await loadCities();
      await loadCompanies();
    });
  }

  Future loadGenders() async {
    var response = await _enumProvider?.getEnumItems("genders");
    setState(() {
      genders = response!;
    });
  }

  Future loadQualifications() async {
    var response = await _enumProvider?.getEnumItems("qualifications");
    setState(() {
      qualifications = response!;
    });
  }

  Future loadCities() async {
    var response = await _enumProvider?.getEnumItems("cities");
    setState(() {
      cities = response! as List<ListItem>;
    });
  }

  Future loadCompanies() async {
    var response = await _enumProvider?.getEnumItems("companies");
    setState(() {
      companies = response! as List<ListItem>;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registracija"),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0.0),
          child: Form(
              key: _formKey,
              onChanged: () {
                if(isFirstSubmit) _formKey.currentState!.validate();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text('Registracija',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KindergatenListScreen(),
                          ),
                        );
                      },
                      icon: Icon(Icons.preview),
                      label: Text(
                        'Pregled vrtića',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ]),
                  SizedBox(height: 40),
                  Row(children: [
                    Expanded(
                      child: Container(
                        height: 66.5,
                        width: double.infinity,
                        child: DropdownButtonFormField<ListItem>(
                          key: Key('companiesDropdown'),
                          value: selectedCompany,
                          onChanged: (ListItem? newValue) {
                            setState(() {
                              selectedCompany = newValue!;
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Vrtić",
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.business_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.id == 0) {
                              return 'Molimo odaberite odgajatelja';
                            }
                            return null;
                          },
                          items: companies.map((ListItem item) {
                            return DropdownMenuItem<ListItem>(
                              value: item,
                              child: Text(item.label),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: firstNameController,
                          decoration: InputDecoration(
                            labelText: 'Ime',
                            border: OutlineInputBorder(),
                            hintText: 'Unesite ime',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Molimo unesite ime';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: lastNameController,
                          decoration: InputDecoration(
                              labelText: 'Prezime',
                              border: OutlineInputBorder(),
                              hintText: 'Unesite ime',
                              hintStyle: TextStyle(color: Colors.grey)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Molimo unesite prezime';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: userNameController,
                          decoration: InputDecoration(
                              labelText: 'Korisničko ime',
                              border: OutlineInputBorder(),
                              hintText: 'Unesite korisničko ime',
                              hintStyle: TextStyle(color: Colors.grey)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Molimo unesite korisničko ime';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: phoneNumberController,
                          decoration: InputDecoration(
                            labelText: 'Broj telefona',
                            border: OutlineInputBorder(),
                            hintText: 'Unesite broj telefona',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Molimo unesite broj telefona';
                            }
                            RegExp phoneNumberLengthRegExp = RegExp(r'^\d{9,15}$');
                            if (!phoneNumberLengthRegExp.hasMatch(value)) {
                              return 'Broj telefona mora imati između 9 i 15 znakova';
                            }
                            return null;
                          },
                        ),)
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                            hintText: 'Unesite email',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Molimo unesite email';
                            }
                            return null;
                          },
                        )),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: dateOfBirthController,
                          decoration: InputDecoration(
                            labelText: 'Datum rođenja',
                            border: OutlineInputBorder(),
                            hintText: 'Unesite datum rođenja',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.date_range),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Molimo unesite datum rođenja';
                            }
                            return null;
                          },
                          onTap: () => _selectDate(context),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 66.5,
                          width: double.infinity,
                          child: DropdownButtonFormField<ListItem>(
                            key: Key('genderDropdown'),
                            value: selectedGender,
                            onChanged: (ListItem? newValue) {
                              setState(() {
                                selectedGender = newValue!;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Spol",
                              hintStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(Icons.business_outlined),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Molimo odaberite spol';
                              }
                              return null;
                            },
                            items: genders.map((ListItem item) {
                              return DropdownMenuItem<ListItem>(
                                value: item,
                                child: Text(item.label),
                              );
                            }).toList(),
                            hint: Text('Odaberite spol'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: addressController,
                          decoration: InputDecoration(
                            labelText: 'Adresa',
                            border: OutlineInputBorder(),
                            hintText: 'Unesite adresu',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Molimo unesite adresu';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: postalCodeController,
                          decoration: InputDecoration(
                            labelText: 'Poštanski broj',
                            border: OutlineInputBorder(),
                            hintText: 'Unesite poštanski broj',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Molimo unesite poštanski broj';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(children: [
                    Expanded(
                      child: Container(
                        height: 66.5,
                        width: double.infinity,
                        child: DropdownButtonFormField<ListItem>(
                          key: Key('qualificaitonDropdown'),
                          value: selectedQualification,
                          onChanged: (ListItem? newValue) {
                            setState(() {
                              selectedQualification = newValue!;
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Kvalifikacija",
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.business_outlined),
                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'Molimo odaberite kvalifikaciju';
                            }
                            return null;
                          },
                          items: qualifications.map((ListItem qualification) {
                            return DropdownMenuItem<ListItem>(
                              value: qualification,
                              child: Text(qualification.label),
                            );
                          }).toList(),
                          hint: Text('Odaberite kvalifikaciju'),
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: Text('Log In'),
                      ),
                      SizedBox(width: 30),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            isFirstSubmit = true;
                            var newUser = new RegistrationModel();
                            newUser.id = 0;
                            newUser.firstName = firstNameController.text;
                            newUser.lastName = lastNameController.text;
                            newUser.email = emailController.text;
                            newUser.phoneNumber = phoneNumberController.text;
                            newUser.userName = userNameController.text;
                            newUser.birthDate = DateTimeHelper.stringToDateTime(
                                    dateOfBirthController.text)
                                .toLocal();
                            newUser.gender = selectedGender!.id;
                            newUser.address = addressController.text;
                            newUser.postCode = postalCodeController.text;
                            newUser.kindergartenId = selectedCompany!.id;
                            newUser.qualification = selectedQualification!.id;
                            bool? result = await _registrationProvider
                                ?.registration(newUser);
                            if (result != null && result) {
                              Fluttertoast.showToast(
                                msg: "Registracija uspješna",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 5,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              Navigator.popAndPushNamed(
                                  context, LoginScreen.routeName);
                            } else {
                              Fluttertoast.showToast(
                                msg: "Greska prilikom registracije",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 5,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          }
                        },
                        child: Text('Registracija'),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      )),
    );
  }
}

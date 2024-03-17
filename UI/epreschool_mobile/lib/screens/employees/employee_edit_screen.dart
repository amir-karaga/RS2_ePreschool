import 'package:epreschool_mobile/providers/employees_provider.dart';
import 'package:epreschool_mobile/providers/login_provider.dart';
import 'package:epreschool_mobile/screens/employees/employee_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../models/employee.dart';
import '../../models/listItem.dart';
import '../../models/parent.dart';
import '../../providers/enum_provider.dart';
import '../../utils/exstenzions/iterable_extension.dart';

class EmployeeEditScreen extends StatefulWidget {
  static const String routeName = "employee/edit";
  final int id;
  EmployeeEditScreen({required this.id});

  @override
  State<EmployeeEditScreen> createState() => _EmployeeEditScreenState();
}

class _EmployeeEditScreenState extends State<EmployeeEditScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController profilePictureController = TextEditingController();
  TextEditingController jmbgController = TextEditingController();
  TextEditingController placeOfBirthController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController citizenshipController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController workExperience = TextEditingController();
  TextEditingController biographyController = TextEditingController();
  TextEditingController payController = TextEditingController();
  EmployeesProvider? _employeesProvider;
  EnumProvider? _enumProvider;
  List<ListItem> genders = [];
  List<ListItem> cities = [];
  List<ListItem> positions = [];
  List<ListItem> drivingLicenses = [];
  List<ListItem> qualifications = [];
  List<ListItem> marriageStatuses = [];
  ListItem? selectedGender = null;
  ListItem? birthPlace = null;
  ListItem? placeOfResidence = null;
  ListItem? selectedQualification = null;
  ListItem? selectedDrivingLicence = null;
  ListItem? selectedPosition = null;
  ListItem? selectedMarriageStatus = null;
  Parent? parent = null;
  DateTime _selectedDate = DateTime.now();
  late Employee? data = null;

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
    _employeesProvider = context.read<EmployeesProvider>();
    Future.delayed(Duration.zero, () async {
      await loadGenders();
      await loadCities();
      await loadMarriageStatuses();
      await loadPositions();
      await loadDrivingLicenses();
      await loadQualifications();
      await loadData();
    });
  }

  Future<void> loadData() async {
    Employee? item = await _employeesProvider?.getById(widget.id, null);
    setState(() {
      this.data = item!;
      final data = this.data;
      if (data != null) {
        firstNameController.text = data.person!.firstName;
        lastNameController.text = data.person!.lastName;
        dateOfBirthController.text = data.person!.birthDate!;
        selectedGender =
            genders.firstOrNull((item) => item.id == data.person!.gender);
        userNameController.text = data.person!.appUser!.userName;
        emailController.text = data.person!.appUser!.email;
        addressController.text = data.person!.address!;
        postalCodeController.text = data.person!.postCode!;
        citizenshipController.text = data.person!.citizenship!;
        nationalityController.text = data.person!.nationality!;
        biographyController.text = data.biography!;
        jmbgController.text = data.person!.JMBG!;
        selectedDrivingLicence = drivingLicenses
            .firstOrNull((item) => item.id == data.drivingLicence);
        birthPlace =
            cities.firstOrNull((item) => item.id == data.person!.birthPlaceId);
        placeOfResidence = cities
            .firstOrNull((item) => item.id == data.person!.placeOfResidenceId);
        selectedMarriageStatus = marriageStatuses
            .firstOrNull((item) => item.id == data.marriageStatus);
        payController.text = data.pay!.toString();
        selectedPosition =
            positions.firstOrNull((item) => item.id == data.position);
        selectedQualification =
            qualifications.firstOrNull((item) => item.id == data.qualifications);
        phoneNumberController.text = data.person!.appUser!.phoneNumber;
      }
    });
  }

  Future loadGenders() async {
    var response = await _enumProvider?.getEnumItems("genders");
    setState(() {
      genders = response!;
    });
  }

  Future loadMarriageStatuses() async {
    var response = await _enumProvider?.getEnumItems("marriageStatuses");
    setState(() {
      marriageStatuses = response!;
    });
  }

  Future loadDrivingLicenses() async {
    var response = await _enumProvider?.getEnumItems("drivingLicenses");
    setState(() {
      drivingLicenses = response!;
    });
  }

  Future loadPositions() async {
    var response = await _enumProvider?.getEnumItems("positions");
    setState(() {
      positions = response!;
    });
  }

  Future loadCities() async {
    var response = await _enumProvider?.getEnumItems("cities");
    setState(() {
      cities = response! as List<ListItem>;
    });
  }

  Future loadQualifications() async {
    var response = await _enumProvider?.getEnumItems("qualifications");
    setState(() {
      qualifications = response! as List<ListItem>;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dodavanje podataka o uposleniku"),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0.0),
          child: Form(
              key: _formKey,
              onChanged: () {
                _formKey.currentState!.validate();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  Text("Lični i kontakt podaci"),
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
                              hintText: 'Unesite prezime',
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
                        ),
                      ),
                      SizedBox(width: 10),
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
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: jmbgController,
                          decoration: InputDecoration(
                            labelText: 'JMBG',
                            border: OutlineInputBorder(),
                            hintText: 'Unesite JMBG',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Molimo unesite jmbg';
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
                          controller: nationalityController,
                          decoration: InputDecoration(
                            labelText: 'Nacionalnost',
                            border: OutlineInputBorder(),
                            hintText: 'Unesite nacionalnost',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Molimo unesite nacionalnost';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: citizenshipController,
                          decoration: InputDecoration(
                            labelText: 'Državljanstvo',
                            border: OutlineInputBorder(),
                            hintText: 'Unesite državljanstvo',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Molimo unesite državljanstvo';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text("Podaci o prebivalištu"),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 66.5,
                          width: double.infinity,
                          child: DropdownButtonFormField<ListItem>(
                            key: Key('birthPlaceDropdown'),
                            value: birthPlace,
                            onChanged: (ListItem? newValue) {
                              setState(() {
                                birthPlace = newValue!;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Mjesto rođenja",
                              hintStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(Icons.business_outlined),
                            ),
                            validator: (value) {
                              if (value == null || value.id == 0) {
                                return 'Molimo odaberite mjesto rođenja';
                              }
                              return null;
                            },
                            items: cities.map((ListItem city) {
                              return DropdownMenuItem<ListItem>(
                                value: city,
                                child: Text(city.label),
                              );
                            }).toList(),
                            hint: Text('Odaberite mjesto rođenja'),
                          ),
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
                            key: Key('placeOfResidenceDropdown'),
                            value: placeOfResidence,
                            onChanged: (ListItem? newValue) {
                              setState(() {
                                placeOfResidence = newValue!;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Mjesto prebivališta",
                              hintStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(Icons.business_outlined),
                            ),
                            validator: (value) {
                              if (value == null || value.id == 0) {
                                return 'Molimo odaberite mjesto prebivališta';
                              }
                              return null;
                            },
                            items: cities.map((ListItem city) {
                              return DropdownMenuItem<ListItem>(
                                value: city,
                                child: Text(city.label),
                              );
                            }).toList(),
                            hint: Text('Odaberite mjesto rođenja'),
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
                  SizedBox(height: 20),
                  Text("Kvalifikacije i iznos plate"),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: payController,
                          decoration: InputDecoration(
                            labelText: 'Iznos plate',
                            border: OutlineInputBorder(),
                            hintText: 'Unesite iznos plate',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Molimo unesite iznos plate';
                            }
                            double? amount = double.tryParse(value);
                            if (amount == null) {
                              return 'Molimo unesite valjanu decimalnu vrijednost';
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
                        child: Container(
                          height: 66.5,
                          width: double.infinity,
                          child: DropdownButtonFormField<ListItem>(
                            key: Key('marriageStatusDropdown'),
                            value: selectedMarriageStatus,
                            onChanged: (ListItem? newValue) {
                              setState(() {
                                selectedMarriageStatus = newValue!;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Odaberite bračni status",
                              hintStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(Icons.business_outlined),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Molimo odaberite bračni status';
                              }
                              return null;
                            },
                            items:
                                marriageStatuses.map((ListItem marriageStatus) {
                              return DropdownMenuItem<ListItem>(
                                value: marriageStatus,
                                child: Text(marriageStatus.label),
                              );
                            }).toList(),
                            hint: Text('Odaberite bračni status'),
                          ),
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
                            key: Key('drivingLicenceDropdown'),
                            value: selectedDrivingLicence,
                            onChanged: (ListItem? newValue) {
                              setState(() {
                                selectedDrivingLicence = newValue!;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Vozačka dozvola",
                              hintStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(Icons.business_outlined),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Molimo odaberite kategoriju vozačke dozvole';
                              }
                              return null;
                            },
                            items:
                                drivingLicenses.map((ListItem drivingLicence) {
                              return DropdownMenuItem<ListItem>(
                                value: drivingLicence,
                                child: Text(drivingLicence.label),
                              );
                            }).toList(),
                            hint: Text('Odaberite vozačku dozvolu'),
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
                        controller: biographyController,
                        maxLines: 5,
                            decoration: InputDecoration(
                              labelText: 'Biografija',
                              border: OutlineInputBorder(),
                              hintText: 'Unesite biografiju',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Molimo unesite biografiju';
                              }
                              return null;
                            },
                      ))
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final Map<String, dynamic> formData = {
                              'id': data!.id,
                              'workExperience': false,
                              'firstName': firstNameController.text,
                              'lastName': lastNameController.text,
                              'email': emailController.text,
                              'userName': userNameController.text,
                              'phoneNumber': phoneNumberController.text,
                              'birthDate': dateOfBirthController.text,
                              'postCode': postalCodeController.text,
                              'citizenship': citizenshipController.text,
                              'nationality': nationalityController.text,
                              'placeOfResidenceId': placeOfResidence?.id,
                              'dateOfEmployment': data!.dateOfEmployment,
                              'profilePhoto': "",
                              'address': addressController.text,
                              'phoneNumber': phoneNumberController.text,
                              'birthPlaceId': birthPlace?.id,
                              'gender': selectedGender?.id,
                              'qualifications': selectedQualification?.id,
                              'JMBG': jmbgController.text,
                              'drivingLicence': selectedDrivingLicence?.id,
                              'marriageStatus': selectedMarriageStatus?.id,
                              'biography': biographyController.text,
                              'pay': addressController.text,
                              'companyId':
                                  LoginProvider.authResponse!.currentCompanyId,
                              'postion': 0,
                              //'createdAt': data!.createdAt
                            };
                            bool? result = (await _employeesProvider
                                ?.updateFormData(formData));
                            if (result != null && result) {
                              Fluttertoast.showToast(
                                msg: "Podaci o uposleniku uspješno promjenjeni",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 5,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EmployeeListScreen(),
                                ),
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg: "Greška prilikom editovanja",
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
                        child: Text('Spasi'),
                      )
                    ],
                  ),
                ],
              )),
        ),
      )),
    );
  }
}

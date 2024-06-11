import 'dart:html' as html;
import 'dart:typed_data';
import 'package:epreschool_admin/models/city.dart';
import 'package:epreschool_admin/providers/cities_provider.dart';
import 'package:epreschool_admin/providers/companies_provider.dart';
import 'package:epreschool_admin/providers/employees_provider.dart';
import 'package:epreschool_admin/screens/employees/employee_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../models/company.dart';
import '../../models/listItem.dart';
import '../../providers/enum_provider.dart';
import 'package:http/http.dart' as http;

class EmployeeAddScreen extends StatefulWidget {
  static const String routeName = "employee/add";
  const EmployeeAddScreen({super.key});

  @override
  State<EmployeeAddScreen> createState() => _EmployeeAddScreenState();
}

class _EmployeeAddScreenState extends State<EmployeeAddScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController profilePictureController = TextEditingController();
  TextEditingController jmbgController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController citizenshipController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController biographyController = TextEditingController();
  TextEditingController payController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool workExperience = false;
  EmployeesProvider? _employeesProvider;
  EnumProvider? _enumProvider;
  CityProvider? _cityProvider;
  CompaniesProvider? _companiesProvider;
  List<ListItem> genders = [];
  List<ListItem> qualifications = [];
  List<ListItem> positions = [];
  List<ListItem> drivingLicenses = [];
  List<ListItem> marriageStatuses = [];
  List<City> cities = [];
  List<Company> companies = [];
  ListItem? selectedGender = null;
  ListItem? selectedQualification = null;
  ListItem? selectedPosition = null;
  ListItem? selectedDrivingLicence = null;
  ListItem? selectedMarriageStatus = null;
  City? selectedBirthPlace = null;
  City? selectedPlaceOfResidence = null;
  Company? selectedCompany = null;
  dynamic bytes = null;
  DateTime _selectedDate = DateTime.now();
  dynamic _imageFile;
  bool isFirstSubmit = false;

  Future<void> _selectImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      bytes = await pickedFile.readAsBytes();
      final buffer = Uint8List.fromList(bytes).buffer;

      setState(() {
        _imageFile = html.File([buffer], pickedFile.path);
        profilePictureController.text = pickedFile.path;
      });
    }
  }

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
    _imageFile = null;
    _employeesProvider = context.read<EmployeesProvider>();
    _enumProvider = context.read<EnumProvider>();
    _cityProvider = context.read<CityProvider>();
    _companiesProvider = context.read<CompaniesProvider>();
    loadGenders();
    loadCities();
    loadMarriageStatuses();
    loadPositions();
    loadDrivingLicenses();
    loadQualifications();
    loadCompanies();
  }

  Future loadCompanies() async {
    var response = await _companiesProvider?.getForPagination(
        {'searchFilter': "", 'page': "1", 'pageSize': "999"});
    setState(() {
      if (response?.items != null) {
        companies = response?.items as List<Company>;
      } else {
        companies = [];
      }
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

  Future loadMarriageStatuses() async {
    var response = await _enumProvider?.getEnumItems("marriageStatuses");
    setState(() {
      marriageStatuses = response!;
    });
  }

  Future loadCities() async {
    var response = await _cityProvider?.getForPagination(
        {'searchFilter': "", 'page': "1", 'pageSize': "999"});
    setState(() {
      if (response?.items != null) {
        cities = response?.items as List<City>;
      } else {
        cities = [];
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dodaj uposlenika"),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 150.0),
          child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              onChanged: () {
                if (isFirstSubmit) _formKey.currentState!.validate();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(100)),
                          child: ClipOval(
                              child: _imageFile != null
                                  ? Image.network(
                                      html.Url.createObjectUrlFromBlob(
                                          html.Blob([_imageFile])),
                                      fit: BoxFit.cover,
                                      width: 150,
                                      height: 100,
                                    )
                                  : Image.network(
                                      "assets/images/user.png",
                                      fit: BoxFit.cover,
                                      width: 150,
                                      height: 100,
                                    )),
                        ),
                      ),
                      SizedBox(width: 16),
                    ],
                  ),
                  SizedBox(
                    width: 16,
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _selectImage,
                        child: Text('Odaberi sliku'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Prethodno radno iskustvo'),
                      Checkbox(
                        key: Key('workExperienceCheckbox'),
                        value: workExperience,
                        onChanged: (bool? value) {
                          setState(() {
                            workExperience = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(children: [
                    Container(
                      height: 50,
                      width: 300,
                      child: DropdownButtonFormField<Company>(
                        key: Key('companiesDropdown'),
                        value: selectedCompany,
                        onChanged: (Company? newValue) {
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
                            return 'Molimo odaberite vrtić uposlenika';
                          }
                          return null;
                        },
                        items: companies.map((Company item) {
                          return DropdownMenuItem<Company>(
                            value: item,
                            child: Text(item.name),
                          );
                        }).toList(),
                      ),
                    )
                  ]),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Text(
                        "Lični i kontakt podaci",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
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
                            prefixIcon: Icon(Icons.man),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Molimo unesite ime';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: lastNameController,
                          decoration: InputDecoration(
                            labelText: 'Prezime',
                            border: OutlineInputBorder(),
                            hintText: 'Unesite prezime',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.man),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Molimo unesite prezime';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: userNameController,
                          decoration: InputDecoration(
                            labelText: 'Korisničko ime',
                            border: OutlineInputBorder(),
                            hintText: 'Unesite korisničko ime',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.man_2),
                          ),
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
                  SizedBox(height: 10),
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
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Molimo unesite email';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          height: 50,
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
                              prefixIcon: Icon(Icons.transgender),
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
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                          child: Container(
                              height: 50,
                              width: double.infinity,
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
                              ))),
                    ],
                  ),
                  SizedBox(height: 10),
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
                            RegExp phoneNumberLengthRegExp =
                                RegExp(r'^\d{9,15}$');
                            if (!phoneNumberLengthRegExp.hasMatch(value)) {
                              return 'Broj telefona mora imati između 9 i 15 znakova';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: jmbgController,
                          decoration: InputDecoration(
                            labelText: 'JMBG',
                            border: OutlineInputBorder(),
                            hintText: 'Unesite JMBG',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.perm_identity),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Molimo unesite JMBG';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: nationalityController,
                          decoration: InputDecoration(
                            labelText: 'Nacionalnost',
                            border: OutlineInputBorder(),
                            hintText: 'Unesite nacionalnost',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.perm_identity),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Molimo unesite nacionalnost';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: citizenshipController,
                          decoration: InputDecoration(
                            labelText: 'Državljanstvo',
                            border: OutlineInputBorder(),
                            hintText: 'Unesite državljanstvo',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.perm_identity),
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
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Text(
                        "Podaci o prebivalištu",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          child: DropdownButtonFormField<City>(
                            key: Key('birthPlaceDropdown'),
                            value: selectedBirthPlace,
                            onChanged: (City? newValue) {
                              setState(() {
                                selectedBirthPlace = newValue!;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Mjesto rođenja',
                              border: OutlineInputBorder(),
                              hintText: 'Odaberite mjesto rođenja',
                              hintStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(Icons.business_outlined),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Molimo unesite mjesto rođenja';
                              }
                              return null;
                            },
                            items: cities.map((City city) {
                              return DropdownMenuItem<City>(
                                value: city,
                                child: Text(city.name),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          child: DropdownButtonFormField<City>(
                            key: Key('placeOfResidenceDropdown'),
                            value: selectedPlaceOfResidence,
                            onChanged: (City? newValue) {
                              setState(() {
                                selectedPlaceOfResidence = newValue!;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Mjesto prebivališta',
                              border: OutlineInputBorder(),
                              hintText: 'Odaberite mjesto prebivališta',
                              hintStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(Icons.location_city_sharp),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Molimo unesite mjesto prebivališta';
                              }
                              return null;
                            },
                            items: cities.map((City city) {
                              return DropdownMenuItem<City>(
                                value: city,
                                child: Text(city.name),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: addressController,
                          decoration: InputDecoration(
                            labelText: 'Adresa',
                            border: OutlineInputBorder(),
                            hintText: 'Unesite adresu',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.home),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Molimo unesite adresu';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: postalCodeController,
                          decoration: InputDecoration(
                            labelText: 'Poštanski broj',
                            border: OutlineInputBorder(),
                            hintText: 'Unesite poštanski broj',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.local_post_office_sharp),
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
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Text(
                        "Kvalifikacije i iznos plate",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
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
                              labelText: 'Bračni status',
                              border: OutlineInputBorder(),
                              hintText: 'Odaberite bračni status',
                              hintStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(Icons.people_alt),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Molimo odaberite bračni status';
                              }
                              return null;
                            },
                            items: marriageStatuses.map((ListItem item) {
                              return DropdownMenuItem<ListItem>(
                                value: item,
                                child: Text(item.label),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          child: DropdownButtonFormField<ListItem>(
                            key: Key('qualificationsDropdown'),
                            value: selectedQualification,
                            onChanged: (ListItem? newValue) {
                              setState(() {
                                selectedQualification = newValue!;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Kvalifikacija',
                              border: OutlineInputBorder(),
                              hintText: 'Odaberite kvalifikaciju',
                              hintStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(Icons.school_outlined),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Molimo odaberite kvalifikaciju';
                              }
                              return null;
                            },
                            items: qualifications.map((ListItem item) {
                              return DropdownMenuItem<ListItem>(
                                value: item,
                                child: Text(item.label),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          child: DropdownButtonFormField<ListItem>(
                            key: Key('positionsDropdown'),
                            value: selectedPosition,
                            onChanged: (ListItem? newValue) {
                              setState(() {
                                selectedPosition = newValue!;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Pozicija',
                              border: OutlineInputBorder(),
                              hintText: 'Unesite poziciju',
                              hintStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(Icons.school),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Molimo unesite poziciju';
                              }
                              return null;
                            },
                            items: positions.map((ListItem item) {
                              return DropdownMenuItem<ListItem>(
                                value: item,
                                child: Text(item.label),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          child: DropdownButtonFormField<ListItem>(
                            value: selectedDrivingLicence,
                            onChanged: (ListItem? newValue) {
                              setState(() {
                                selectedDrivingLicence = newValue!;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Vozačka dozvola',
                              border: OutlineInputBorder(),
                              hintText: 'Unesite vozačku dozvolu',
                              hintStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(Icons.drive_eta),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Molimo odaberite vozačku dozvolu';
                              }
                              return null;
                            },
                            items: drivingLicenses.map((ListItem item) {
                              return DropdownMenuItem<ListItem>(
                                value: item,
                                child: Text(item.label),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: payController,
                          decoration: InputDecoration(
                            labelText: 'Iznos plate',
                            border: OutlineInputBorder(),
                            hintText: 'Unesite iznos plate',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
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
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: biographyController,
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Molimo unesite biografiju';
                            }
                            return null; // Return null if the input is valid
                          },
                          decoration: InputDecoration(
                            labelText: 'Biografija',
                            border: OutlineInputBorder(),
                            hintText: 'Unesite tekst ovdje...',
                          ),
                        ),
                      )

                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            isFirstSubmit = true;
                            final Map<String, dynamic> formData = {
                              'id': '0',
                              'workExperience': workExperience,
                              'firstName': firstNameController.text,
                              'lastName': lastNameController.text,
                              'email': emailController.text,
                              'userName': userNameController.text,
                              'phoneNumber': phoneNumberController.text,
                              'birthDate': dateOfBirthController.text,
                              'postCode': postalCodeController.text,
                              'citizenship': citizenshipController.text,
                              'nationality': nationalityController.text,
                              'placeOfResidenceId':
                                  selectedPlaceOfResidence?.id,
                              'profilePhoto': "",
                              'address': addressController.text,
                              'phoneNumber': phoneNumberController.text,
                              'birthPlaceId': selectedBirthPlace?.id,
                              'gender': selectedGender?.id,
                              'qualifications': selectedQualification?.id,
                              'JMBG': jmbgController.text,
                              'position': selectedPosition?.id,
                              'drivingLicence': selectedDrivingLicence?.id,
                              'marriageStatus': selectedMarriageStatus?.id,
                              'biography': biographyController.text,
                              'pay': payController.text,
                              'companyId': selectedCompany?.id
                            };
                            if (bytes != null) {
                              formData['file'] = http.MultipartFile.fromBytes(
                                'file',
                                bytes,
                                filename: 'image.jpg',
                              );
                            }
                            bool? result = await _employeesProvider
                                ?.insertFormData(formData);
                            print(result);
                            if (result != null && result) {
                              Fluttertoast.showToast(
                                msg: "Uposlenik uspješno dodan",
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
                                msg: "Greška prilikom dodavanja",
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
                        icon: Icon(Icons.add),
                        label: Text('Dodaj uposlenika'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.greenAccent),
                        ),
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

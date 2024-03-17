import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:epreschool_mobile/models/city.dart';
import 'package:epreschool_mobile/providers/children_provider.dart';
import 'package:epreschool_mobile/providers/cities_provider.dart';
import 'package:epreschool_mobile/providers/employees_provider.dart';
import 'package:epreschool_mobile/providers/login_provider.dart';
import 'package:epreschool_mobile/screens/children/child_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../models/child.dart';
import '../../models/employee.dart';
import '../../models/listItem.dart';
import '../../models/parent.dart';
import '../../providers/enum_provider.dart';
import 'package:http/http.dart' as http;

import '../../providers/parents_provider.dart';

class ChildAddScreen extends StatefulWidget {
  static const String routeName = "child/add";
  ChildAddScreen();

  @override
  State<ChildAddScreen> createState() => _ChildEditScreenState();
}

class _ChildEditScreenState extends State<ChildAddScreen> {
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
  TextEditingController emergencyContactController = TextEditingController();
  TextEditingController specialNeedsController = TextEditingController();
  ChildrenProvider? _childrenProvider;
  ParentsProvider? _parentsProvider;
  EmployeesProvider? _employeesProvider;
  EnumProvider? _enumProvider;
  List<ListItem> genders = [];
  List<ListItem> cities = [];
  List<Employee> educators = [];
  List<ListItem> recommendedEducators = [];
  ListItem? selectedGender = null;
  ListItem? birthPlace = null;
  ListItem? placeOfResidence = null;
  Employee? selectedEducator = null;
  Parent? parent = null;
  dynamic bytes = null;
  DateTime _selectedDate = DateTime.now();
  dynamic _imageFile;
  late Child? data = null;
  bool isFirstSubmit = false;
  int _currentIndexEmployee = 0;

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
    _childrenProvider = context.read<ChildrenProvider>();
    _enumProvider = context.read<EnumProvider>();
    _parentsProvider = context.read<ParentsProvider>();
    _employeesProvider = context.read<EmployeesProvider>();
    Future.delayed(Duration.zero, () async {
      await loadGenders();
      await loadCities();
      await loadParent();
    });
  }
  Future loadGenders() async {
    var response = await _enumProvider?.getEnumItems("genders");
    setState(() {
      genders = response!;
    });
  }
  Future loadCities() async {
    var response = await _enumProvider?.getEnumItems("cities");
    setState(() {
      cities = response! as List<ListItem>;
    });
  }
  Future loadParent() async {
    var response = await _parentsProvider?.getById(
        LoginProvider.authResponse!.userId, null);
    setState(() {
      parent = response!;
    });
    await loadEducators(parent!.kindergartenId!);
    await loadRecommendedEducators(parent!.kindergartenId!);
  }
  Future loadEducators(int companyId) async {
    var response = await _employeesProvider?.getForPagination({
      'searchFilter': "",
      'page': "1",
      'pageSize': "999",
      'position': '0',
      'companyId': companyId.toString()
    });
    setState(() {
      if (response?.items != null) {
        educators = response?.items as List<Employee>;
      } else {
        educators = [];
      }
    });
  }
  Future loadRecommendedEducators(int companyId) async {
    var response = await _employeesProvider?.getRecommendedEmployees(companyId.toString(), LoginProvider.authResponse!.userId.toString());
    setState(() {
      if (response != null) {
        recommendedEducators = response;
      } else {
        recommendedEducators = [];
      }
    });
  }

  Future<void> loadNewPicture() async{
    final picker = ImagePicker();
    File? imageResponse = null;
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageResponse = File(pickedFile.path);
      var imageBytes = await imageResponse.readAsBytes();
      String base64String = base64Encode(imageBytes);

      final Uint8List compressedBytes =
      await FlutterImageCompress.compressWithList(
        imageBytes,
        minHeight: 200,
        minWidth: 200,
      );

      setState(() {
        bytes = compressedBytes;
        profilePictureController.text = base64String;
      });
    }
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dodavanje podataka o djetetu"),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0.0),
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
                      InkWell(
                        onTap: () async {
                          await loadNewPicture();
                        },
                        child: profilePictureController.text != "" ?
                        Image.memory( base64Decode(profilePictureController.text),
                          fit: BoxFit.contain,
                          height: MediaQuery.of(context).size.height / 4,
                        ) :
                        ClipOval(
                            child: _imageFile != null
                                ? Image.file(
                              _imageFile,
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            )
                                : Image.asset(
                              "assets/images/user.png",
                              fit: BoxFit.cover,
                              width: 150,
                              height: 150,
                            )),
                      ),

                    ],
                  ),
                  SizedBox(height: 15),
                  Row(children: [
                    Expanded(
                      child: Container(
                        height: 66.5,
                        width: double.infinity,
                        child: DropdownButtonFormField<Employee>(
                          key: Key('educatorsDropdown'),
                          value: selectedEducator,
                          onChanged: (Employee? newValue) {
                            setState(() {
                              selectedEducator = newValue!;
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Odgajatelj",
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.business_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.id == 0) {
                              return 'Molimo odaberite odgajatelja';
                            }
                            return null;
                          },
                          items: educators.map((Employee item) {
                            return DropdownMenuItem<Employee>(
                              value: item,
                              child: Text(item.person!.firstName +
                                  " " +
                                  item.person!.lastName),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(height: 16),
                  if(recommendedEducators.length > 0)
                    Center(child:
                    Text(
                      "Preporučeni odgajatelji",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    )),
                  recommendedEducators.isNotEmpty ? CarouselSlider(
                    options: CarouselOptions(
                      height: 80.0,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      pauseAutoPlayOnTouch: true,
                      aspectRatio: 2.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndexEmployee = index;
                        });
                      },
                    ),
                    items: recommendedEducators.map((employee){
                      return Builder(
                          builder:(BuildContext context){
                            return       GestureDetector(
                              child: Card (
                                margin: EdgeInsets.all(10),
                                color: Colors.white,
                                elevation: 20,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      leading: Icon (
                                          Icons.person,
                                          color: Colors.lightBlueAccent,
                                          size: 45
                                      ),
                                      title: Text(
                                        employee.label,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                      );
                    }).toList(),
                  ) : Center(child: CircularProgressIndicator()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: map<Widget>(recommendedEducators, (index, url) {
                      return Container(
                        width: 10.0,
                        height: 10.0,
                        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndexEmployee == index ? Colors.blueAccent : Colors.grey,
                        ),
                      );
                    }),
                  ),
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
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
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
                        child: TextFormField(
                          controller: emergencyContactController,
                          decoration: InputDecoration(
                            labelText: 'Kontakt za hitne slučajeve',
                            border: OutlineInputBorder(),
                            hintText: 'Unesite kontakt za hitne slučajeve',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Molimo unesite kontakt za hitne slučajeve';
                            }
                            RegExp phoneNumberLengthRegExp = RegExp(r'^\d{9,15}$');
                            if (!phoneNumberLengthRegExp.hasMatch(value)) {
                              return 'Broj telefona mora imati između 9 i 15 znakova';
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
                            key: Key('genderDropdown'),
                            value: selectedGender,
                            onChanged: (ListItem? newValue) {
                              setState(() {
                                selectedGender = newValue!;
                              });
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
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: jmbgController,
                          decoration: InputDecoration(
                              labelText: 'JMBG',
                              border: OutlineInputBorder(),
                              hintText: 'Unesite JMBG',
                              hintStyle: TextStyle(color: Colors.grey)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Molimo unesite JMBG';
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
                            key: Key('birthPlaceDropdown'),
                            value: birthPlace,
                            onChanged: (ListItem? newValue) {
                              setState(() {
                                birthPlace = newValue!;
                              });
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
                            key: Key('placeOfResidenceDropdown'),
                            value: placeOfResidence,
                            onChanged: (ListItem? newValue) {
                              setState(() {
                                placeOfResidence = newValue!;
                              });
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
                          controller: nationalityController,
                          decoration: InputDecoration(
                              labelText: 'Nacionalnost',
                              border: OutlineInputBorder(),
                              hintText: 'Unesite nacionalnost',
                              hintStyle: TextStyle(color: Colors.grey)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Molimo unesite nacionalnost';
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
                          controller: citizenshipController,
                          decoration: InputDecoration(
                              labelText: 'Državljanstvo',
                              border: OutlineInputBorder(),
                              hintText: 'Unesite državljanstvo',
                              hintStyle: TextStyle(color: Colors.grey)),
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
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: postalCodeController,
                          decoration: InputDecoration(
                              labelText: 'Poštanski broj',
                              border: OutlineInputBorder(),
                              hintText: 'Unesite poštanski broj',
                              hintStyle: TextStyle(color: Colors.grey)),
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
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: addressController,
                          decoration: InputDecoration(
                              labelText: 'Adresa',
                              border: OutlineInputBorder(),
                              hintText: 'Unesite adresu',
                              hintStyle: TextStyle(color: Colors.grey)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Molimo unesite adresu';
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
                        controller: specialNeedsController,
                        maxLines: 5,
                            decoration: InputDecoration(
                                labelText: 'Posebne potrebe',
                                border: OutlineInputBorder(),
                                hintText: 'Unesite posebne potrebe',
                                hintStyle: TextStyle(color: Colors.grey)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Molimo unesite posebne potrebe';
                              }
                              return null;
                            },
                      ))
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                        controller: noteController,
                        maxLines: 5,
                            decoration: InputDecoration(
                                labelText: 'Napomena',
                                border: OutlineInputBorder(),
                                hintText: 'Unesite napomenu',
                                hintStyle: TextStyle(color: Colors.grey)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Molimo unesite napomenu';
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
                            isFirstSubmit = true;
                            final Map<String, dynamic> formData = {
                              'id': 0,
                              'firstName': firstNameController.text.toString(),
                              'lastName': lastNameController.text.toString(),
                              'birthDate': _selectedDate.toIso8601String(),
                              'postCode': postalCodeController.text.toString(),
                              'citizenship': citizenshipController.text.toString(),
                              'nationality': nationalityController.text.toString(),
                              'placeOfResidenceId':
                                  placeOfResidence?.id,
                              'address': addressController.text.toString(),
                              'birthPlaceId': birthPlace?.id,
                              'gender': selectedGender?.id,
                              'JMBG': jmbgController.text.toString(),
                              'specialNeeds': specialNeedsController.text.toString(),
                              'emergencyContact': emergencyContactController.text.toString(),
                              'note': noteController.text.toString(),
                              'parentId': parent!.id,
                              'educatorId': selectedEducator!.id,
                              'kindergartenId': parent!.kindergartenId,
                            };
                            if (bytes != null) {
                              formData['file'] = http.MultipartFile.fromBytes(
                                'file',
                                bytes,
                                filename: 'image.jpg',
                              );
                            }
                            bool? result = (await _childrenProvider?.insertFormData(formData));
                            if(result!=null && result)
                              {
                            Fluttertoast.showToast(
                              msg: "Dijete uspješno dodano",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 5,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            Navigator.popAndPushNamed(
                                context, ChildListScreen.routeName);
                              }
                            else{
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
                        child: Text('Dodaj'),
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

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:epreschool_mobile/providers/children_provider.dart';
import 'package:epreschool_mobile/screens/children/child_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../models/child.dart';
import '../../models/listItem.dart';
import '../../providers/enum_provider.dart';
import 'package:http/http.dart' as http;
import '../../utils/exstenzions/iterable_extension.dart';

class ChildEditScreen extends StatefulWidget {
  static const String routeName = "child/edit";
  final int id;
  ChildEditScreen({required this.id});

  @override
  State<ChildEditScreen> createState() => _ChildEditScreenState();
}

class _ChildEditScreenState extends State<ChildEditScreen> {
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
  TextEditingController noteController = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  TextEditingController emergencyContactController = TextEditingController();
  TextEditingController specialNeedsController = TextEditingController();
  ChildrenProvider? _childrenProvider;
  EnumProvider? _enumProvider;
  List<ListItem> genders = [];
  List<ListItem> cities = [];
  ListItem? selectedGender = null;
  ListItem? placeOfResidence = null;
  ListItem? birthPlace = null;
  bool isFirstSubmit = false;
  dynamic bytes = null;
  DateTime _selectedDate = DateTime.now();
  dynamic _imageFile;
  late Child? data = null;

  Future<void> _selectImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final Uint8List imageBytes = await pickedFile.readAsBytes();
      final Uint8List compressedBytes =
          await FlutterImageCompress.compressWithList(
        imageBytes,
        minHeight: 200,
        minWidth: 200,
      );

      setState(() {
        _imageFile = compressedBytes;
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

  Future<void> loadNewPicture() async {
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

  @override
  void initState() {
    super.initState();
    _imageFile = null;
    _childrenProvider = context.read<ChildrenProvider>();
    _enumProvider = context.read<EnumProvider>();
    Future.delayed(Duration.zero, () async {
      await loadGenders();
      await loadCities();
      await loadData();
    });
  }

  Future<void> loadData() async {
    Child? item = await _childrenProvider?.getById(widget.id, null);
    setState(() {
      this.data = item!;
      final data = this.data;
      if (data != null) {
        firstNameController.text = data.person!.firstName;
        lastNameController.text = data.person!.lastName;
        dateOfBirthController.text = data.person!.birthDate!;
        selectedGender =
            genders.firstOrNull((item) => item.id == data.person!.gender!);
        jmbgController.text = data.person!.JMBG!;
        birthPlace =
            cities.firstOrNull((city) => city.id == data.person!.birthPlaceId);
        placeOfResidence = cities
            .firstOrNull((city) => city.id == data.person!.placeOfResidenceId);
        nationalityController.text = data.person!.nationality!;
        citizenshipController.text = data.person!.citizenship!;
        postalCodeController.text = data.person!.postCode!;
        noteController.text = data.note!;
        emergencyContactController.text = data.emergencyContact!;
        specialNeedsController.text = data.specialNeeds!;
      }
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editovanje podataka o djetetu"),
      ),
      body: data != null
          ? SingleChildScrollView(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                await loadNewPicture();
                              },
                              child: profilePictureController.text != ""
                                  ? Image.memory(
                                      base64Decode(
                                          profilePictureController.text),
                                      fit: BoxFit.cover,
                                      width: 150,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              4,
                                    )
                                  : ClipOval(
                                      child: data!.person!.profilePhoto !=
                                                  null &&
                                              data!.person!.profilePhoto != ""
                                          ? Image.network(
                                              data!.person!.profilePhoto!,
                                              fit: BoxFit.cover,
                                              width: 150,
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
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
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
                                  hintText:
                                      'Unesite kontakt za hitne slučajeve',
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Molimo unesite kontakt za hitne slučajeve';
                                  }
                                  RegExp phoneNumberLengthRegExp =
                                      RegExp(r'^\d{9,15}$');
                                  if (!phoneNumberLengthRegExp
                                      .hasMatch(value)) {
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
                                controller: jmbgController,
                                decoration: InputDecoration(
                                  labelText: 'JMBG',
                                  border: OutlineInputBorder(),
                                  hintText: 'Unesite JMBG',
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
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
                                  hint: Text('Odaberite mjesto prebivališta'),
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
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
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
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
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
                                  var child = new Child();
                                  child.id = 0;
                                  child.firstName = firstNameController.text;
                                  child.lastName = lastNameController.text;
                                  child.birthDate = dateOfBirthController.text;
                                  child.postCode = postalCodeController.text;
                                  child.citizenship =
                                      citizenshipController.text;
                                  child.nationality =
                                      nationalityController.text;
                                  child.placeOfResidenceId =
                                      placeOfResidence?.id;
                                  child.profilePhoto = data!.person!.imageUrl;
                                  child.address = postalCodeController.text;
                                  child.birthPlaceId = birthPlace?.id;
                                  child.gender = selectedGender!.id;
                                  child.file = _imageFile;
                                  child.dateOfEnrollment =
                                      data!.dateOfEnrollment;
                                  child.JMBG = jmbgController.text;
                                  child.specialNeeds =
                                      specialNeedsController.text;
                                  child.emergencyContact =
                                      emergencyContactController.text;
                                  child.note = noteController.text;
                                  child.createdAt = data!.person!.createdAt;

                                  final Map<String, dynamic> formData = {
                                    'id': data!.id,
                                    'firstName': child.firstName,
                                    'lastName': child.lastName,
                                    'birthDate': child.birthDate,
                                    'postCode': child.postCode,
                                    'citizenship': child.citizenship,
                                    'nationality': child.nationality,
                                    'placeOfResidenceId':
                                        child.placeOfResidenceId.toString(),
                                    'profilePhoto': child.profilePhoto!,
                                    'address': child.address,
                                    'birthPlaceId':
                                        child.birthPlaceId.toString(),
                                    'gender': child.gender.toString(),
                                    'dateOfEnrollment': child.dateOfEnrollment,
                                    'JMBG': child.JMBG,
                                    'specialNeeds': child.specialNeeds,
                                    'emergencyContact': child.emergencyContact,
                                    'note': child.note,
                                    'parentId': data!.parentId,
                                    'educatorId': data!.educatorId,
                                    'kindergartenId': data!.kindergartenId
                                  };
                                  if (bytes != null) {
                                    formData['file'] =
                                        http.MultipartFile.fromBytes(
                                      'file',
                                      bytes,
                                      filename: 'image.jpg',
                                    );
                                  }

                                  print(formData);
                                  bool? result = (await _childrenProvider
                                      ?.updateFormData(formData));
                                  if (result != null && result) {
                                    Fluttertoast.showToast(
                                      msg:
                                          "Podaci o djetetu su uspješno promjenjeni",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 5,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                    Navigator.popAndPushNamed(
                                        context, ChildListScreen.routeName);
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
                              child: Text('Edituj dijete'),
                            )
                          ],
                        ),
                      ],
                    )),
              ),
            ))
          : Center(child: CircularProgressIndicator()),
    );
  }
}

import 'dart:html' as html;
import 'dart:typed_data';
import 'package:epreschool_admin/models/city.dart';
import 'package:epreschool_admin/providers/children_provider.dart';
import 'package:epreschool_admin/providers/cities_provider.dart';
import 'package:epreschool_admin/screens/children/child_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../models/child.dart';
import '../../models/employee.dart';
import '../../models/listItem.dart';
import '../../models/parent.dart';
import '../../providers/employees_provider.dart';
import '../../providers/enum_provider.dart';
import 'package:http/http.dart' as http;
import '../../providers/parents_provider.dart';
import '../../utils/exstenzions/iterable_extension.dart';

class ChildEditScreen extends StatefulWidget {
  static const String routeName = "child/edit";
  final int id;
  ChildEditScreen({required this.id});

  @override
  State<ChildEditScreen> createState() => _ChildEditScreenState();
}

class _ChildEditScreenState extends State<ChildEditScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController profilePictureController = TextEditingController();
  TextEditingController jmbgController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController citizenshipController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController specialNeedsController = TextEditingController();
  TextEditingController emergencyContactController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  ChildrenProvider? _childrenProvider;
  ParentsProvider? _parentsProvider;
  EmployeesProvider? _employeesProvider;
  EnumProvider? _enumProvider;
  CityProvider? _cityProvider;
  List<ListItem> genders = [];
  List<City> cities = [];
  List<Parent> parents = [];
  List<Employee> educators = [];
  ListItem? selectedGender = null;
  City? placeOfResidence;
  City? birthPlace;
  Parent? selectedParent = null;
  Employee? selectedEducator = null;
  dynamic bytes = null;
  DateTime _selectedDate = DateTime.now();
  dynamic _imageFile;
  final _formKey = GlobalKey<FormState>();
  bool isFirstSubmit = false;
  bool isLoading = true;
  Child? data;
  String? imageUrl = null;

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
    _childrenProvider = context.read<ChildrenProvider>();
    _enumProvider = context.read<EnumProvider>();
    _cityProvider = context.read<CityProvider>();
    _employeesProvider = context.read<EmployeesProvider>();
    _parentsProvider = context.read<ParentsProvider>();
    Future.delayed(Duration.zero, () async {
      await loadGenders();
      await loadCities();
      await loadParents();
      await loadData();
    });
  }

  Future<void> loadData() async {
    Child? item = await _childrenProvider?.getById(widget.id, null);
    if (item != null){
      await loadEducators(item.kindergartenId);
    }
    setState(() {
      this.data = item!;
        isLoading = true;
      final data = this.data;
      if (data != null) {
        firstNameController.text = data.person!.firstName;
        lastNameController.text = data.person!.lastName;
        dateOfBirthController.text = data.person!.birthDate.toString();
        selectedGender = genders.firstWhere((item) => item.id == data.person!.gender);
        birthPlace = cities.firstOrNull((city) => city.id == data.person!.birthPlaceId);
        placeOfResidence = cities.firstOrNull((city) => city.id == data.person!.placeOfResidenceId);
        nationalityController.text = data.person!.nationality!;
        citizenshipController.text = data.person!.citizenship!;
        emergencyContactController.text = data.emergencyContact!;
        addressController.text = data.person!.address!;
        postalCodeController.text = data.person!.postCode!;
        jmbgController.text = data.person!.JMBG!;
        specialNeedsController.text = data.specialNeeds!;
        noteController.text = data.note!;
        selectedEducator = educators.firstOrNull((educator) => educator.id == data.educatorId);
        selectedParent = parents.firstOrNull((parent) => parent.id == data.parentId);
        imageUrl = data.person?.profilePhoto ?? "";
      }
      isLoading = false;
    });
  }

  Future loadGenders() async {
    var response = await _enumProvider?.getEnumItems("genders");
    setState(() {
      genders = response!;
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

  Future loadParents() async {
    var response = await _parentsProvider?.getForPagination(
        {'searchFilter': "", 'page': "1", 'pageSize': "999"});
    setState(() {
      if (response?.items != null) {
        parents = response?.items as List<Parent>;
      } else {
        parents = [];
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editovanje podataka o djetetu"),
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : SingleChildScrollView(
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
                                  : (imageUrl != null && imageUrl != "" ?
                              Image.network(
                                imageUrl!,
                                fit: BoxFit.cover,
                                width: 150,
                                height: 100,
                              ) :
                              Image.network(
                                      "assets/images/user.png",
                                      fit: BoxFit.cover,
                                      width: 150,
                                      height: 100,
                                    )
                              )
                          ),
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
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Text(
                        "Roditelj i odgajatelj",
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
                          child: DropdownButtonFormField<Parent>(
                            key: Key('parentsDropdown'),
                            value: selectedParent,
                            onChanged: (Parent? newValue) {
                              setState(() {
                                selectedParent = newValue!;
                                loadEducators(selectedParent!.kindergartenId!);
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Roditelj",
                              hintStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(Icons.business_outlined),
                            ),
                            validator: (value) {
                              if (value == null || value.id == 0) {
                                return 'Molimo odaberite roditelja';
                              }
                              return null;
                            },
                            items: parents.map((Parent item) {
                              return DropdownMenuItem<Parent>(
                                value: item,
                                child: Text(item.person!.firstName +
                                    " " +
                                    item.person!.lastName),
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
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Text(
                        "Lični podaci",
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
                          controller: dateOfBirthController,
                          decoration: InputDecoration(
                            labelText: 'Datum rođenja',
                            border: OutlineInputBorder(),
                            hintText: 'Unesite datum rođenja',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.man),
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
                  SizedBox(height: 10),
                  Row(
                    children: [
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
                      SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: jmbgController,
                          decoration: InputDecoration(
                            labelText: 'JMBG',
                            border: OutlineInputBorder(),
                            hintText: 'Unesite JMBG',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.man),
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
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          child: DropdownButtonFormField<City>(
                            key: Key('birthPlaceDropdown'),
                            value: birthPlace,
                            onChanged: (City? newValue) {
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
                            items: cities.map((City city) {
                              return DropdownMenuItem<City>(
                                value: city,
                                child: Text(city.name),
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
                        child: TextFormField(
                          controller: nationalityController,
                          decoration: InputDecoration(
                            labelText: 'Nacionalnost',
                            border: OutlineInputBorder(),
                            hintText: 'Unesite nacionalnost',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.man),
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
                            prefixIcon: Icon(Icons.man),
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
                            key: Key('placeOfResidenceDropdown'),
                            value: placeOfResidence,
                            onChanged: (City? newValue) {
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
                            prefixIcon: Icon(Icons.man),
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
                            prefixIcon: Icon(Icons.man),
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
                        "Dodatne informacije",
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
                          controller: specialNeedsController,
                          decoration: InputDecoration(
                            labelText: 'Posebne potrebe',
                            border: OutlineInputBorder(),
                            hintText: 'Unesite posebne potrebe',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.man),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Molimo unesite posebne potrebe';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 16),
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
                            RegExp phoneNumberLengthRegExp =
                                RegExp(r'^\d{9,15}$');
                            if (!phoneNumberLengthRegExp.hasMatch(value)) {
                              return 'Broj telefona mora imati između 9 i 15 znakova';
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
                          try {
                            isFirstSubmit = true;
                            if (_formKey.currentState!.validate()) {
                              final Map<String, dynamic> formData = {
                                'id': data!.id,
                                'firstName': firstNameController.text,
                                'lastName': lastNameController.text,
                                'birthDate': dateOfBirthController.text,
                                'postCode': postalCodeController.text,
                                'citizenship': citizenshipController.text,
                                'nationality': nationalityController.text,
                                'placeOfResidenceId': placeOfResidence?.id,
                                'profilePhoto': "",
                                'address': addressController.text,
                                'birthPlaceId': birthPlace?.id,
                                'gender': selectedGender?.id,
                                'dateOfEnrollment': DateTime.now().toString(),
                                'JMBG': jmbgController.text,
                                'specialNeeds': specialNeedsController.text,
                                'emergencyContact':
                                    emergencyContactController.text,
                                'note': noteController.text,
                                'parentId': selectedParent?.id,
                                'kindergartenId':
                                    selectedParent?.kindergartenId,
                                'educatorId': selectedEducator?.id
                              };
                              if (bytes != null) {
                                formData['file'] = http.MultipartFile.fromBytes(
                                  'file',
                                  bytes,
                                  filename: 'image.jpg',
                                );
                              }
                              bool? result = await _childrenProvider
                                  ?.updateFormData(formData);
                              if (result != null && result) {
                                Fluttertoast.showToast(
                                  msg: "Dijete uspješno dodano",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 5,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ChildListScreen(),
                                  ),
                                );
                              } else {
                                Fluttertoast.showToast(
                                  msg: "Greška prilikom uređivanja",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 5,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              }
                            }
                          } catch (error) {
                            print(error.toString());
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

  void submitData(data) async {
    await _childrenProvider?.insert(data);
  }
}

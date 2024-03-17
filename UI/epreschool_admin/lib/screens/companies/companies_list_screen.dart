import 'package:epreschool_admin/models/city.dart';
import 'package:epreschool_admin/providers/companies_provider.dart';
import 'package:epreschool_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import '../../helpers/color_constants.dart';
import '../../enums/enums.dart';
import '../../models/company.dart';
import '../../providers/cities_provider.dart';
import '../../utils/colorized_text_avatar.dart';

class CompanyListScreen extends StatefulWidget {
  static const String routeName = "companies";
  const CompanyListScreen({Key? key}) : super(key: key);

  @override
  State<CompanyListScreen> createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
  final _formKey = GlobalKey<FormState>();
  CompaniesProvider? _companyProvider = null;
  CityProvider? _cityProvider = null;
  TextEditingController _searchController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _identificationNumberController =
      TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  GlobalKey<NumberPaginatorState> paginatorKey = GlobalKey();
  bool _isActive = false;
  List<Company> data = [];
  List<City> cities = [];
  int page = 1;
  int pageSize = 5;
  int totalRecordCounts = 0;
  String searchFilter = '';
  bool isLoading = true;
  int numberOfPages = 1;
  int currentPage = 1;
  List<Center> pages = [];

  @override
  void initState() {
    super.initState();
    _companyProvider = context.read<CompaniesProvider>();
    _cityProvider = context.read<CityProvider>();
    loadCities();
    loadData(searchFilter, page, pageSize);
  }

  Future loadCities() async {
    var response = await _cityProvider?.getForPagination(
        {'searchFilter': "", 'page': "1", 'pageSize': "999"});
    setState(() {
      cities = response?.items as List<City>;
    });
  }

  Future loadData(searchFilter, page, pageSize) async {
    if (searchFilter != '') {
      page = 1;
    }
    var response = await _companyProvider?.getForPagination({
      'SearchFilter': searchFilter.toString() ?? "",
      'PageNumber': page.toString(),
      'PageSize': pageSize.toString()
    });
    setState(() {
      data = response?.items as List<Company>;
    });
    totalRecordCounts = response?.totalCount as int;
    numberOfPages = ((totalRecordCounts - 1) / pageSize).toInt() + 1;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    pages = List.generate(numberOfPages, (index) => Center());
    return MasterScreenWidget(
        child: Scaffold(
      body: Visibility(
          visible: isLoading,
          child: Center(child: CircularProgressIndicator()),
          replacement: RefreshIndicator(
            onRefresh: () {
              return loadData('', 1, 5);
            },
            child: Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    _buildSearch(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Company company = new Company(id: 0, name: "");
                            company.identificationNumber = "";
                            company.phoneNumber = "";
                            company.email = "";
                            company.location = null;
                            company.address = "";
                            company.isActive = false;
                            showAddEditModal(context, company, false);
                          },
                          icon: Icon(Icons.add),
                          label: Text('Dodaj vrtić'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.greenAccent),
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                    Expanded(
                      child: _buildCompanyList(context),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: pages[currentPage - 1],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            width: 300.0,
                            child: NumberPaginator(
                              key: paginatorKey,
                              numberPages: numberOfPages,
                              onPageChange: (index) {
                                setState(() {
                                  currentPage = index + 1;
                                  loadData("", currentPage, pageSize);
                                });
                              },
                              config: NumberPaginatorUIConfig(
                                height: 36,
                              ),
                            ),
                          ),
                        ))
                  ],
                )),
          )),
    ));
  }

  DataRow recentDataRow(Company company, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              TextAvatar(
                size: 35,
                backgroundColor: Colors.white,
                textColor: Colors.white,
                fontSize: 14,
                upperCase: true,
                numberLetters: 1,
                shape: Shape.Rectangle,
                text: company.name!,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  company.name!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        DataCell(Text(company.email)),
        DataCell(Text(company.address)),
        DataCell(Container(
          padding: EdgeInsets.all(5),
          child: Checkbox(
            activeColor: custom_green,
            value: company.isActive,
            onChanged: (value) {
              setState(() {});
            },
          ),
        )),
        DataCell(
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  showAddEditModal(context, company, true);
                },
                icon: Icon(Icons.edit),
                label: Text('Uredi'),
              ),
              SizedBox(
                width: 6,
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.delete),
                label: Text('Obriši'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.redAccent),
                ),
                onPressed: () {
                  showDeleteModal(context, company);
                },
                // Delete
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        "Registered kindergatens",
        style: TextStyle(
            color: Colors.grey, fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }

  void showDeleteModal(BuildContext context, Company company) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return MaterialApp(
                home: AlertDialog(
                    title: Center(
                      child: Column(
                        children: [
                          Icon(Icons.warning_outlined,
                              size: 36, color: Colors.red),
                          SizedBox(height: 20),
                          Text("Brisanje"),
                        ],
                      ),
                    ),
                    content: Container(
                      height: 70,
                      child: Column(
                        children: [
                          Text("Da li želite obrisati vrtić ${company.name}?"),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                  icon: Icon(
                                    Icons.close,
                                    size: 14,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.grey),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  label: Text("Cancel")),
                              SizedBox(
                                width: 20,
                              ),
                              ElevatedButton.icon(
                                  icon: Icon(
                                    Icons.delete,
                                    size: 14,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.red),
                                  onPressed: () async {
                                    await deleteById(company.id);
                                    await loadData(searchFilter, 1, pageSize);
                                    Navigator.pop(context);
                                  },
                                  label: Text("Delete"))
                            ],
                          )
                        ],
                      ),
                    )));
          });
        });
  }

  void showAddEditModal(BuildContext context, Company company, bool isEdit) {
    bool firstSubmit = true;
    _nameController.text = company.name ?? '';
    _identificationNumberController.text = company.identificationNumber ?? '';
    _addressController.text = company.address ?? '';
    _phoneNumberController.text = company.phoneNumber ?? '';
    _emailController.text = company.email ?? '';
    _isActive = company.isActive ?? false;
    City? selectedLocation = null;
    if (company.location != null) {
      selectedLocation = cities.where((x) => x.id == company.locationId).first;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
                home: AlertDialog(
              title:
                  isEdit ? Text('Uredi podatke o vrtić') : Text("Dodaj vrtić"),
              content: SingleChildScrollView(
                  child: Container(
                      width: 500,
                      child: IntrinsicWidth(
                        child: Form(
                            key: _formKey,
                            onChanged: () {
                              if (!firstSubmit) {
                                _formKey.currentState!.validate();
                              }
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Text('Aktivnost'),
                                    Checkbox(
                                      key: Key('isActiveCheckbox'),
                                      value: _isActive,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _isActive = value!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(children: [
                                  Expanded(
                                      child: TextFormField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      labelText: 'Naziv',
                                      border: OutlineInputBorder(),
                                      hintText:
                                          'Unesite naziv poslovne jedinice',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      prefixIcon: Icon(Icons.business_outlined),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Molimo unesite naziv';
                                      }
                                      return null;
                                    },
                                  )),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: TextFormField(
                                      controller:
                                          _identificationNumberController,
                                      decoration: InputDecoration(
                                        labelText: 'Identifikacijski broj',
                                        border: OutlineInputBorder(),
                                        hintText:
                                            'Unesite identifikacijski broj',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        prefixIcon: Icon(Icons.numbers),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Molimo unesite identifikacijski broj';
                                        }
                                        return null;
                                      },
                                    ),
                                  )
                                ]),
                                SizedBox(height: 20),
                                Row(children: [
                                  Expanded(
                                      child: TextFormField(
                                    controller: _emailController,
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
                                  )),
                                  SizedBox(width: 16),
                                  Expanded(
                                      child: TextFormField(
                                    controller: _phoneNumberController,
                                    decoration: InputDecoration(
                                      labelText: 'Broj telefona',
                                      border: OutlineInputBorder(),
                                      hintText: 'Unesite broj telefona',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      prefixIcon: Icon(Icons.phone),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Molimo unesite broj telefona';
                                      }
                                      return null;
                                    },
                                  ))
                                ]),
                                SizedBox(height: 20),
                                Row(children: [
                                  Expanded(
                                      child: TextFormField(
                                    controller: _addressController,
                                    decoration: InputDecoration(
                                      labelText: 'Adresa',
                                      border: OutlineInputBorder(),
                                      hintText: 'Unesite adresu',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      prefixIcon: Icon(Icons.location_on),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Molimo unesite adresu';
                                      }
                                      return null;
                                    },
                                  )),
                                  SizedBox(width: 16),
                                  Expanded(
                                      child: Container(
                                    width: double.infinity,
                                    child: DropdownButtonFormField<City>(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Lokacija",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        prefixIcon: Icon(Icons.location_on),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.id == 0) {
                                          return 'Molimo odaberite lokaciju poslovne jedinice';
                                        }
                                        return null;
                                      },
                                      value: selectedLocation,
                                      onChanged: (City? newValue) {
                                        setState(() {
                                          selectedLocation = newValue!;
                                        });
                                      },
                                      items: cities.map((City city) {
                                        return DropdownMenuItem<City>(
                                          value: city,
                                          child: Text(city.name),
                                        );
                                      }).toList(),
                                      hint: Text('Odaberi lokaciju'),
                                    ),
                                  ))
                                ]),
                              ],
                            )),
                      ))),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.all(10)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  child: Text('Odustani'),
                ),
                SizedBox(width: 10),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      firstSubmit = false;
                    });
                    if (_formKey.currentState!.validate()) {
                      company.name = _nameController.text;
                      company.address = _addressController.text;
                      company.isActive = _isActive;
                      company.identificationNumber =
                          _identificationNumberController.text;
                      company.phoneNumber = _phoneNumberController.text;
                      company.email = _emailController.text;
                      company.locationId = selectedLocation!.id;
                      bool? result = false;
                      if (isEdit) {
                        result = await _companyProvider?.update(company.id, company);
                      } else {
                        result = await _companyProvider?.insert(company);
                      }
                      if (result != null && result) {
                        Fluttertoast.showToast(
                          msg: "Vrtić uspješno dodan",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 5,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        loadData("", 1, pageSize);
                        Navigator.pop(context);
                      } else {
                        Fluttertoast.showToast(
                          msg: "Greška prilikom upravljanja podacima o vrtiću",
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
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  child: Text('Spremi'),
                ),
              ],
            ));
          },
        );
      },
    );
  }

  Widget _buildSearch() {
    return Row(
      children: [
        SizedBox(
          width: 400.0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: _searchController,
              onChanged: (value) async {
                searchFilter = value;
                loadData(searchFilter, page, pageSize);
              },
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey))),
            ),
          ),
        ),
      ],
    );
  }

  Container _buildCompanyList(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: DataTable(
                horizontalMargin: 0,
                columnSpacing: 16.0,
                columns: [
                  DataColumn(
                    label: Text("Name"),
                  ),
                  DataColumn(
                    label: Text("Email"),
                  ),
                  DataColumn(
                    label: Text("Adresa"),
                  ),
                  DataColumn(
                    label: Text("Aktivnost"),
                  ),
                  DataColumn(
                    label: Text("Action"),
                  ),
                ],
                rows: List.generate(
                  data.length,
                  (index) => recentDataRow(data[index], context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> deleteById(int id) async {
    await _companyProvider?.deleteById(id);
    setState(() {
      currentPage = 1;
      loadData("", currentPage, pageSize);
      paginatorKey.currentState?.dispose();
      paginatorKey = GlobalKey();
    });
  }
}

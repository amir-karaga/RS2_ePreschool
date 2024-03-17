import 'package:epreschool_admin/models/country.dart';
import 'package:epreschool_admin/providers/countries_provider.dart';
import 'package:epreschool_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import '../../helpers/color_constants.dart';
import '../../enums/enums.dart';
import '../../utils/colorized_text_avatar.dart';

class CountryListScreen extends StatefulWidget {
  static const String routeName = "countries";

  const CountryListScreen({Key? key}) : super(key: key);

  @override
  State<CountryListScreen> createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  CountryProvider? _countryProvider = null;
  TextEditingController _searchController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _abrvController = TextEditingController();
  GlobalKey<NumberPaginatorState> paginatorKey = GlobalKey();
  bool _isActive = false;
  List<Country> data = [];
  int page = 1;
  int pageSize = 5;
  int totalRecordCounts = 0;
  String searchFilter = '';
  bool isLoading = true;
  int numberOfPages = 1;
  int currentPage = 1;
  List<Center> pages = [];
  final _formKey = GlobalKey<FormState>();
  bool isFirstSubmit = false;
  @override
  void initState() {
    super.initState();
    _countryProvider = context.read<CountryProvider>();
    loadData(searchFilter, page, pageSize);
  }

  Future loadData(searchFilter, page, pageSize) async {
    if (searchFilter != '') {
      page = 1;
    }
    var response = await _countryProvider?.getForPagination({
      'SearchFilter': searchFilter.toString() ?? "",
      'PageNumber': page.toString(),
      'PageSize': pageSize.toString()
    });
    setState(() {
      data = response?.items as List<Country>;
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
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
                  _buildCountrySearch(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Country country = new Country(id: 0, name: "");
                          country.abrv = "";
                          country.isActive = false;
                          showAddEditModal(context, country, false);
                        },
                        icon: Icon(Icons.add),
                        label: Text('Dodaj državu'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.greenAccent),
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  Expanded(child: _buildCountryList(context)),
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
                    ),
                  ),
                ],
              ),
            ),
    ));
  }

  DataRow recentDataRow(Country country, BuildContext context) {
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
                text: country.name!,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  country.name!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        DataCell(Text(country.abrv)),
        DataCell(Container(
          padding: EdgeInsets.all(5),
          child: Checkbox(
            activeColor: custom_green,
            value: country.isActive,
            onChanged: (value) {
              setState(() {});
            },
          ),
        )),
        DataCell(
          Row(
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.edit),
                label: Text('Uredi'),
                onPressed: () {
                  showAddEditModal(context, country, true);
                },
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
                  showDeleteModal(context, country);
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
        "Countries",
        style: TextStyle(
            color: Colors.grey, fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }

  void showDeleteModal(BuildContext context, Country country) {
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
                          Text("Da li želite obrisati državu ${country.name}?"),
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
                                    Navigator.of(context).pop();
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
                                    await deleteById(country.id);
                                    await loadData(searchFilter, 1, pageSize);
                                    Navigator.pop(context);
                                    ;
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

  void showAddEditModal(BuildContext context, Country country, bool isEdit) {
    _nameController.text = country.name ?? '';
    _abrvController.text = country.abrv ?? '';
    _isActive = country.isActive ?? false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
                home: AlertDialog(
              title: isEdit ? Text('Uredi državu') : Text("Dodaj državu"),
              content: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  onChanged: () {
                    if (isFirstSubmit) _formKey.currentState!.validate();
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(children: [
                        Expanded(
                            child: TextFormField(
                          key: Key('nazivTextField'),
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Naziv',
                            border: OutlineInputBorder(),
                            hintText: 'Unesite naziv',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.near_me),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Molimo unesite naziv';
                            }
                            return null;
                          },
                        ))
                      ]),
                      SizedBox(height: 16),
                      Row(children: [
                        Expanded(
                            child: TextFormField(
                          key: Key('skracenicaTextField'),
                          controller: _abrvController,
                          decoration: InputDecoration(
                            labelText: 'Skraćenica',
                            border: OutlineInputBorder(),
                            hintText: 'Unesite skraćenicu',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.abc),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Molimo unesite skraćenicu';
                            }
                            return null;
                          },
                        ))
                      ]),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text('Aktivna'),
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
                    ],
                  )),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Zatvori modal
                  },
                  child: Text('Odustani'),
                ),
                TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      isFirstSubmit = true;
                      country.name = _nameController.text;
                      country.abrv = _abrvController.text;
                      country.isActive = _isActive;
                      bool? result = false;
                      if (isEdit) {
                        result = await _countryProvider?.update(country.id, country);
                      } else {
                        result = await _countryProvider?.insert(country);
                      }
                      if (result != null && result) {
                        Fluttertoast.showToast(
                          msg: "Država uspješno dodana",
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
                          msg: "Greška prilikom upravljanja podacima o državama",
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
                  child: Text('Spremi'),
                ),
              ],
            ));
          },
        );
      },
    );
  }

  Widget _buildCountrySearch() {
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
                  hintText: "Pretraga",
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

  Container _buildCountryList(BuildContext context) {
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
                    label: Text("Abbreviation"),
                  ),
                  DataColumn(
                    label: Text("Favorite"),
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
    await _countryProvider?.deleteById(id);
    setState(() {
      currentPage = 1;
      loadData("", currentPage, pageSize);
      paginatorKey.currentState?.dispose();
      paginatorKey = GlobalKey();
    });
  }
}

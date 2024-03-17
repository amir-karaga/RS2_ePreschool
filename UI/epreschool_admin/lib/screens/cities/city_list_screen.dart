import 'package:epreschool_admin/models/city.dart';
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
import '../../providers/cities_provider.dart';
import '../../utils/colorized_text_avatar.dart';
import '../../utils/exstenzions/iterable_extension.dart';

class CityListScreen extends StatefulWidget {
  static const String routeName = "cities";
  const CityListScreen({Key? key}) : super(key: key);

  @override
  State<CityListScreen> createState() => _CityListScreenState();
}

class _CityListScreenState extends State<CityListScreen> {
  CityProvider? _cityProvider = null;
  CountryProvider? _countryProvider = null;
  TextEditingController _searchController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _abrvController = TextEditingController();
  GlobalKey<NumberPaginatorState> paginatorKey = GlobalKey();
  bool _isActive = false;
  List<City> data = [];
  List<Country> countries = [];
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
    _cityProvider = context.read<CityProvider>();
    _countryProvider = context.read<CountryProvider>();
    loadCountries();
    loadData(searchFilter, page, pageSize);
  }

  Future loadCountries() async {
    var response = await _countryProvider?.getForPagination(
        {'searchFilter': "", 'page': "1", 'pageSize': "999"});
    setState(() {
      countries = response?.items as List<Country>;
    });
  }

  Future loadData(searchFilter, page, pageSize) async {
    if (searchFilter != '') {
      page = 1;
    }
    var response = await _cityProvider?.getForPagination({
      'SearchFilter': searchFilter.toString() ?? "",
      'PageNumber': page.toString(),
      'PageSize': pageSize.toString()
    });
    setState(() {
      data = response?.items as List<City>;
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
                      _buildSearch(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              City city = new City(
                                  id: 0, name: "", abrv: "", isActive: false);
                              city.country = null;
                              showAddEditModal(context, city, false);
                            },
                            icon: Icon(Icons.add),
                            label: Text('Dodaj grad'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.greenAccent),
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                      Expanded(child: _buildCityList(context)),
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
                )),
    );
  }

  DataRow recentDataRow(City city, BuildContext context) {
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
                text: city.name!,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  city.name!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        DataCell(Text(city.abrv)),
        DataCell(Text(city.country!.name)),
        DataCell(Container(
          padding: EdgeInsets.all(5),
          child: Checkbox(
            activeColor: custom_green,
            value: city.isActive,
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
                  showAddEditModal(context, city, true);
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
                  showDeleteModal(context, city);
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
        "Cities",
        style: TextStyle(
            color: Colors.grey, fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }

  void showDeleteModal(BuildContext context, City city) {
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
                          Text("Da li želite obrisati grad ${city.name}?"),
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
                                    await deleteById(city.id);
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

  void showAddEditModal(BuildContext context, City city, bool isEdit) {
    _nameController.text = city.name ?? '';
    _abrvController.text = city.abrv ?? '';
    _isActive = city.isActive ?? false;
    Country? selectedCountry = countries[0];
    if (city.country != null) {
      selectedCountry = countries.firstOrNull((x) => x.id == city.countryId);
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
                home: AlertDialog(
              title: isEdit ? Text('Uredi grad') : Text("Dodaj grad"),
              content: IntrinsicWidth(
                child: Form(
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
                                return 'Molimo unesite skraćenicu';
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
                        Row(children: [
                          Expanded(
                              child: Container(
                            height: 50,
                            width: double.infinity,
                            child: DropdownButtonFormField<Country>(
                              key: Key('countryDropdown'),
                              value: selectedCountry,
                              onChanged: (Country? newValue) {
                                setState(() {
                                  selectedCountry = newValue!;
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Država",
                                hintStyle: TextStyle(color: Colors.grey),
                                prefixIcon: Icon(Icons.near_me_sharp),
                              ),
                              validator: (value) {
                                if (value == null || value.id == 0) {
                                  return 'Molimo odaberite državu';
                                }
                                return null;
                              },
                              items: countries.map((Country country) {
                                return DropdownMenuItem<Country>(
                                  value: country,
                                  child: Text(country.name),
                                );
                              }).toList(),
                              hint: Text('Odaberi državu'),
                            ),
                          ))
                        ]),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Text('Aktivan'),
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
              ),
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
                      city.name = _nameController.text;
                      city.abrv = _abrvController.text;
                      city.isActive = _isActive;
                      city.countryId = selectedCountry!.id;
                      bool? result = false;
                      if (isEdit) {
                        result = await _cityProvider?.update(city.id, city);
                      } else {
                        result = await _cityProvider?.insert(city);
                      }
                      if (result != null && result) {
                        Fluttertoast.showToast(
                          msg: "Grad uspješno dodan",
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
                          msg: "Greška prilikom upravljanja podacima grada",
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

  Container _buildCityList(BuildContext context) {
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
                    label: Text("Country"),
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
    await _cityProvider?.deleteById(id);
    setState(() {
      currentPage = 1;
      loadData("", currentPage, pageSize);
      paginatorKey.currentState?.dispose();
      paginatorKey = GlobalKey();
    });
  }
}

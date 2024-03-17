import 'package:epreschool_admin/models/country.dart';
import 'package:epreschool_admin/providers/news_provider.dart';
import 'package:epreschool_admin/screens/news/new_add_screen.dart';
import 'package:epreschool_admin/screens/news/new_edit_screen.dart';
import 'package:epreschool_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import '../../helpers/color_constants.dart';
import '../../models/new.dart';

class NewListScreen extends StatefulWidget {
  static const String routeName = "news";
  const NewListScreen({Key? key}) : super(key: key);

  @override
  State<NewListScreen> createState() => _NewListScreenState();
}

class _NewListScreenState extends State<NewListScreen> {
  NewsProvider? _newsProvider = null;
  List<New> data = [];
  List<Country> countries = [];
  TextEditingController _searchController = TextEditingController();
  int page = 1;
  int pageSize = 5;
  int totalRecordCounts = 0;
  String searchFilter = '';
  bool isLoading = true;
  int numberOfPages = 2;
  int currentPage = 1;
  @override
  void initState() {
    super.initState();
    _newsProvider = context.read<NewsProvider>();
    loadData(searchFilter, page, pageSize);
  }

  Future loadData(searchFilter, page, pageSize) async {
    if (searchFilter != '') {
      page = 1;
    }
    var response = await _newsProvider?.getForPagination({
      'PageNumber': page.toString(),
      'PageSize': pageSize.toString(),
      'SearchFilter': searchFilter
    });
    setState(() {
      data = response?.items as List<New>;
    });
    totalRecordCounts = response?.totalCount as int;
    numberOfPages = (totalRecordCounts / pageSize).toInt() + 1;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var pages = List.generate(numberOfPages, (index) => Center());
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewAddScreen(),
                            ),
                          );
                        },
                        icon: Icon(Icons.add),
                        label: Text(translate("news.add")),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.greenAccent),
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  Expanded(
                    child: _buildNewList(context),
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
          ),
        );
  }

  DataRow recentDataRow(New data, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(Text(data.name)),
        DataCell(Text(data.text)),
        DataCell(Text(data.user!.firstName + " " + data.user!.lastName)),
        DataCell(Container(
          padding: EdgeInsets.all(5),
          child: Checkbox(
            activeColor: custom_green,
            value: data.public,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewEditScreen(id: data.id),
                    ),
                  );
                },
                icon: Icon(Icons.edit),
                label: Text(translate("shared.edit")),
              ),
              SizedBox(
                width: 6,
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.delete),
                label: Text(translate("shared.delete")),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.redAccent),
                ),
                onPressed: () {
                  showDeleteModal(context, data);
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
        translate("news.title"),
        style: TextStyle(
            color: Colors.grey, fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }

  void showDeleteModal(BuildContext context, New item) {
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
                          Text("Da li želite obrisati obavijest ${item.name}?"),
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
                                  label: Text("Izađi")),
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
                                    await deleteById(item.id);
                                    await loadData(searchFilter, 1, pageSize);
                                    Navigator.pop(context);
                                  },
                                  label: Text(translate("shared.delete")))
                            ],
                          )
                        ],
                      ),
                    )));
          });
        });
  }

  Widget _buildSearch() {
    return Row(
      children: [
        SizedBox(
          width: 400.0,
          child: Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: _searchController,
              onChanged: (value) async {
                searchFilter = value;
                loadData(searchFilter, page, pageSize);
              },
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                  hintText: translate("shared.search"),
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

  Container _buildNewList(BuildContext context) {
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
                    label: Text(translate("shared.name")),
                  ),
                  DataColumn(
                    label: Text(translate("news.text")),
                  ),
                  DataColumn(
                    label: Text(translate("news.author")),
                  ),
                  DataColumn(
                    label: Text(translate("news.public")),
                  ),
                  DataColumn(
                    label: Text(translate("shared.actions")),
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
    await _newsProvider?.deleteById(id);
    loadData('', 1, 5);
  }
}

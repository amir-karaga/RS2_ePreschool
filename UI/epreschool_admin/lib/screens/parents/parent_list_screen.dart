import 'package:epreschool_admin/providers/parents_provider.dart';
import 'package:epreschool_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import '../../models/parent.dart';

class ParentListScreen extends StatefulWidget {
  static const String routeName = "parents";

  const ParentListScreen({Key? key}) : super(key: key);

  @override
  State<ParentListScreen> createState() => _ParentListScreenState();
}

class _ParentListScreenState extends State<ParentListScreen> {
  ParentsProvider? _parentsProvider = null;
  TextEditingController _searchController = TextEditingController();
  GlobalKey<NumberPaginatorState> paginatorKey = GlobalKey();
  List<Parent> data = [];
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
    _parentsProvider = context.read<ParentsProvider>();
    loadData(searchFilter, page, pageSize);
  }

  Future loadData(searchFilter, page, pageSize) async {
    if (searchFilter != '') {
      page = 1;
    }
    var response = await _parentsProvider?.getForPagination({
      'SearchFilter': searchFilter.toString() ?? "",
      'PageNumber': page.toString(),
      'PageSize': pageSize.toString()
    });
    setState(() {
      data = response?.items as List<Parent>;
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
                          Expanded(
                            child: _buildList(context),
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
                                  ))),
                        ],
                      )),
                ))));
  }

  DataRow recentDataRow(Parent parent, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(
            Text(parent.person!.firstName + " " + parent.person!.lastName)),
        DataCell(Text(parent.person!.appUser!.email)),
        DataCell(Text(parent.kindergarten!.name)),
        DataCell(Text(parent.person!.appUser!.phoneNumber)),
        DataCell(
          Row(
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.delete),
                label: Text('Obriši'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.redAccent),
                ),
                onPressed: () {
                  showDeleteModal(context, parent);
                },
                // Delete
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showDeleteModal(BuildContext context, Parent parent) {
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
                          Text(
                              "Da li želite obrisati vrtić ${parent.person!.firstName} ${parent.person!.lastName}?"),
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
                                    await deleteById(parent.id);
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

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        "Parents",
        style: TextStyle(
            color: Colors.grey, fontSize: 20, fontWeight: FontWeight.w600),
      ),
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

  Container _buildList(BuildContext context) {
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
                    label: Text("Ime i prezime"),
                  ),
                  DataColumn(
                    label: Text("Email"),
                  ),
                  DataColumn(
                    label: Text("Vrtić"),
                  ),
                  DataColumn(
                    label: Text("Broj telefona"),
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
    await _parentsProvider?.deleteById(id);
    setState(() {
      currentPage = 1;
      loadData("", currentPage, pageSize);
      paginatorKey.currentState?.dispose();
      paginatorKey = GlobalKey();
    });
  }
}

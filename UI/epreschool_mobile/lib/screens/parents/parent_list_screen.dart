import 'package:epreschool_mobile/models/child.dart';
import 'package:epreschool_mobile/providers/employees_provider.dart';
import 'package:epreschool_mobile/providers/login_provider.dart';
import 'package:epreschool_mobile/providers/parents_provider.dart';
import 'package:epreschool_mobile/screens/employees/employee_add_screen.dart';
import 'package:epreschool_mobile/screens/employees/employee_edit_screen.dart';
import 'package:epreschool_mobile/screens/parents/parent_previews_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import '../../models/parent.dart';
import '../../widgets/epreschool_drawer.dart';
import '../../widgets/master_screen.dart';

class ParentListScreen extends StatefulWidget {
  static const String routeName = "employees";
  final int? companyId;
  const ParentListScreen({this.companyId}) : super();

  @override
  State<ParentListScreen> createState() => _ParentListScreenState();
}

class _ParentListScreenState extends State<ParentListScreen> {
  ParentsProvider? _parentsProvider = null;
  List<Parent> data = [];
  TextEditingController _searchController = TextEditingController();
  final scrollController = ScrollController();
  int page = 1;
  int pageSize = 10;
  int totalRecordCounts = 0;
  String searchFilter = '';
  int numberOfPages = 2;
  int currentPage = 1;
  bool isLoading = true;
  bool deleteList = false;

  @override
  void initState() {
    super.initState();
    _parentsProvider = context.read<ParentsProvider>();
    scrollController.addListener(_scrollListener);
    loadData(searchFilter, page, pageSize);
  }

  Future loadData(searchFilter, page, pageSize) async {
    if (searchFilter != '') {
      page = 1;
    }
    var response = await _parentsProvider?.getForPagination({
      'SearchFilter': searchFilter.toString() ?? "",
      'PageNumber': page.toString(),
      'PageSize': pageSize.toString(),
      'Position': 0.toString(),
      'CompanyId': widget.companyId != null
          ? widget.companyId.toString()
          : (LoginProvider.authResponse?.currentCompanyId?.toString() ?? "")
    });
    setState(() {
      if (searchFilter != '' || deleteList) {
        data = response?.items as List<Parent>;
        if(searchFilter == '')
        {
          deleteList = false;
        }
      } else {
        data.addAll(response?.items as List<Parent>);
      }
    });
    totalRecordCounts = response?.totalCount as int;
    numberOfPages = ((totalRecordCounts - 1) / pageSize).toInt() + 1;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Roditelji"),
      ),
      drawer: ePreschoolDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildChildSearch(),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Container(
                    width: double.infinity,
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          // image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: data[index].person!.profilePhoto != ""
                                ? Image.network(
                                    data[index].person!.profilePhoto!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    "assets/images/user.png",
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          SizedBox(width: 10),
                          // title and subtitle
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        data[index].person!.firstName! +
                                            " " +
                                            data[index].person!.lastName!,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          child: PopupMenuButton(
                                            itemBuilder:
                                                (BuildContext context) =>
                                                    <PopupMenuEntry>[
                                              PopupMenuItem(
                                                child: ListTile(
                                                  leading:
                                                      Icon(Icons.perm_identity),
                                                  title: Text('Pregled'),
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ParentPreviewScreen(
                                                              id: data[index]
                                                                  .id),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  "Datum rođenja: ${data[index].person!.birthDate!}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                Text(
                                  "Adresa: " + data[index].person!.address!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        "Roditelji",
        style: TextStyle(
            color: Colors.grey, fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildChildSearch() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: _searchController,
              onChanged: (value) async {
                if (value.isEmpty) {
                  setState(() {
                    deleteList = true;
                    page = 1;
                  });
                } else {
                  setState(() {
                    deleteList = false;
                  });
                }
                searchFilter = value.toString();
                await loadData(searchFilter, page, pageSize);
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

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (!deleteList) {
        page++;
        loadData(searchFilter, page, pageSize);
      }
    }
  }
}

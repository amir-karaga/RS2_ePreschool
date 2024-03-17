import 'package:epreschool_mobile/models/child.dart';
import 'package:epreschool_mobile/providers/children_provider.dart';
import 'package:epreschool_mobile/providers/login_provider.dart';
import 'package:epreschool_mobile/screens/children/child_add_screen.dart';
import 'package:epreschool_mobile/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import '../../helpers/colors.dart';
import '../../widgets/epreschool_drawer.dart';
import 'child_edit_screen.dart';

class ChildListScreen extends StatefulWidget {
  static const String routeName = "children";

  const ChildListScreen({Key? key}) : super(key: key);

  @override
  State<ChildListScreen> createState() => _ChildListScreenState();
}

class _ChildListScreenState extends State<ChildListScreen> {
  ChildrenProvider? _childrenProvider = null;
  List<Child> data = [];
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
    _childrenProvider = context.read<ChildrenProvider>();
    scrollController.addListener(_scrollListener);
    loadData(searchFilter, page, pageSize);
  }

  Future loadData(searchFilter, page, pageSize) async {
    if (searchFilter != '') {
      page = 1;
    }
    int? kindergartenId = LoginProvider.authResponse?.currentCompanyId;
    var response = await _childrenProvider?.getForPagination({
      'SearchFilter': searchFilter.toString() ?? "",
      'PageNumber': page.toString(),
      'PageSize': pageSize.toString(),
      'KindergartenId': kindergartenId?.toString() ?? ""
    });
    setState(() {
      if (searchFilter != '' || deleteList) {
        data = response?.items as List<Child>;
        if (searchFilter == '') {
          deleteList = false;
        }
      } else {
        data.addAll(response?.items as List<Child>);
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
        title: Text("Djeca"),
      ),
      drawer: ePreschoolDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildChildSearch(),
          Expanded(
            child: ListView.builder(
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
                                      fit: BoxFit.cover)
                                  : Image.asset("assets/images/user.png",
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover)),
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
                                    Text(
                                      data[index].person!.firstName! +
                                          " " +
                                          data[index].person!.lastName!,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ChildEditScreen(
                                                        id: data[index].id),
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            _showModal(context, data[index]);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  "Date of birth: ${data[index].person!.birthDate!}",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade400),
                                ),
                                Text(
                                  "Date of enrollment: " +
                                      data[index].dateOfEnrollment!,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade400),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChildAddScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        "Djeca",
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

  Future<void> _showModal(BuildContext context, Child child) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Brisanje djeteta'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Da li ste sigurni da želite obrisati ili deaktivirati dijete : ' +
                        child.person!.firstName +
                        " " +
                        child.person!.lastName +
                        "?"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteById(child.id);
              },
              child: Text('Obriši', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Zatvori'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteById(int id) async {
    await _childrenProvider?.deleteById(id);
    setState(() {
      data = [];
    });
    loadData('', 1, 5);
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

import 'package:epreschool_mobile/models/child.dart';
import 'package:epreschool_mobile/providers/children_provider.dart';
import 'package:epreschool_mobile/providers/companies_provider.dart';
import 'package:epreschool_mobile/screens/children/child_add_screen.dart';
import 'package:epreschool_mobile/screens/kindergatens/kindergaten_preview_screen.dart';
import 'package:epreschool_mobile/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import '../../helpers/colors.dart';
import '../../models/company.dart';

class KindergatenListScreen extends StatefulWidget {
  static const String routeName = "companies";

  const KindergatenListScreen({Key? key}) : super(key: key);

  @override
  State<KindergatenListScreen> createState() => _KindergatenListScreenState();
}

class _KindergatenListScreenState extends State<KindergatenListScreen> {
  CompaniesProvider? _companiesProvider = null;
  List<Company> data = [];
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
    _companiesProvider = context.read<CompaniesProvider>();
    scrollController.addListener(_scrollListener);
    loadData(searchFilter, page, pageSize);
  }

  Future loadData(searchFilter, page, pageSize) async {
    if (searchFilter != '') {
      page = 1;
    }
    var response = await _companiesProvider?.getForPagination({
      'SearchFilter': searchFilter.toString() ?? "",
      'PageNumber': page.toString(),
      'PageSize': pageSize.toString()
    });
    setState(() {
      if (searchFilter != '' || deleteList) {
        data = response?.items as List<Company>;
        if(searchFilter == '')
        {
          deleteList = false;
        }
      } else {
        data.addAll(response?.items as List<Company>);
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
        title: Text("Vrtići"),
      ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        data[index].name!,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.arrow_forward_ios_outlined),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => KindergatenPreviewScreen(id: data[index].id),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Adresa: ${data[index].address}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade400),
                                  ),
                                  Text(
                                    "Lokacija: " + data[index].location!.name,
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
      );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text("Pregled vrtića", style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.w600),),
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

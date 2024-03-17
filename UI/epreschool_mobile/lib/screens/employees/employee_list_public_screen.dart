import 'package:epreschool_mobile/providers/employees_provider.dart';
import 'package:epreschool_mobile/providers/login_provider.dart';
import 'package:epreschool_mobile/screens/registration/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import '../../models/employee.dart';

class EmployeeListPublicScreen extends StatefulWidget {
  static const String routeName = "employees_public";
  final int? companyId;
  const EmployeeListPublicScreen({this.companyId}) : super();

  @override
  State<EmployeeListPublicScreen> createState() => _EmployeeListPublicScreenState();
}

class _EmployeeListPublicScreenState extends State<EmployeeListPublicScreen> {
  EmployeesProvider? _employeesProvider = null;
  List<Employee> data = [];
  TextEditingController _searchController = TextEditingController();
  final scrollController = ScrollController();
  int page = 1;
  int pageSize = 10;
  int totalRecordCounts = 0;
  String searchFilter = '';
  int numberOfPages = 2;
  int currentPage = 1;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _employeesProvider = context.read<EmployeesProvider>();
    scrollController.addListener(_scrollListener);
    loadData(searchFilter, page, pageSize);
  }

  Future loadData(searchFilter, page, pageSize) async {
    if (searchFilter != '') {
      page = 1;
    }
    var response = await _employeesProvider?.getForPagination({
      'SearchFilter': searchFilter.toString() ?? "",
      'PageNumber': page.toString(),
      'PageSize': pageSize.toString(),
      'Position': 0.toString(),
      'CompanyId': widget.companyId != null
          ? widget.companyId.toString()
          : (LoginProvider.authResponse?.currentCompanyId?.toString() ?? "")
    });
    setState(() {
      data = response?.items as List<Employee>;
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
        title: Text("Odgajatelji"),
      ),
      body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildChildSearch(),
              Row(children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrationScreen(),
                      ),
                    );
                  },
                  icon: Icon(Icons.login),
                  label: Text(
                    'Registracija',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ]),
              Container(
                child: Expanded(
              child: ListView.builder(
                    controller: scrollController,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        ],
                                      ),
                                      Text(
                                        "Date of birth: ${data[index].person!.birthDate!}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      Text(
                                        "Date of enrollment: " +
                                            data[index].dateOfEmployment!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: Row(
                                            children: List.generate(
                                              5,
                                              (index2) {
                                                return Icon(
                                                  Icons.star,
                                                  color: index2 + 1 <=
                                                          data[index]!
                                                              .averageReviewsRating!
                                                      ? Colors.orange
                                                      : Colors.grey.shade400,
                                                  size: 20,
                                                );
                                              },
                                            ),
                                          )),
                                          Expanded(
                                              child: Text(data[index]!
                                                  .averageReviewsRating!
                                                  .toStringAsFixed(2)))
                                        ],
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
              ),
            ],
          ),
      );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        "Educators",
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
              onSubmitted: (value) async {
                var tmpData = await _employeesProvider
                    ?.getForPagination({'SearchFilter': value});
                setState(() {
                  data = tmpData!.items as List<Employee>;
                });
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

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      data = data;
    }
  }
}

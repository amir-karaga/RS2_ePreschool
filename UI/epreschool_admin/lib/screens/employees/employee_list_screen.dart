import 'package:epreschool_admin/models/employee.dart';
import 'package:epreschool_admin/providers/employees_provider.dart';
import 'package:epreschool_admin/screens/employees/employee_edit_screen.dart';
import 'package:epreschool_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';

import 'employee_add_screen.dart';

class EmployeeListScreen extends StatefulWidget {
  static const String routeName = "employees";

  const EmployeeListScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  EmployeesProvider? _employeesProvider = null;
  TextEditingController _searchController = TextEditingController();
  List<Employee> data = [];
  int page = 1;
  int pageSize = 10;
  int totalRecordCounts = 0;
  String searchFilter = '';
  bool isLoading = true;
  int numberOfPages = 2;
  int currentPage = 1;
  List<Center> pages = [];
  @override
  void initState() {
    super.initState();
    _employeesProvider = context.read<EmployeesProvider>();
    loadData(searchFilter, page, pageSize);
  }

  Future loadData(searchFilter, page, pageSize) async {
    if (searchFilter != '') {
      page = 1;
    }
    var response = await _employeesProvider?.getForPagination({
      'SearchFilter': searchFilter.toString() ?? "",
      'PageNumber': page.toString(),
      'PageSize': pageSize.toString()
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
                    _buildEmployeeSearch(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EmployeeAddScreen(),
                              ),
                            );
                          },
                          icon: Icon(Icons.add),
                          label: Text('Dodaj uposlenika'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.greenAccent),
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                    SizedBox(height: 10),
                    Flexible(
                      child: LayoutBuilder(builder: (context, constraints) {
                        double screenWidth = constraints.maxWidth;
                        int crossAxisCount;
                        if (screenWidth < 648) {
                          crossAxisCount = 1;
                        } else if (screenWidth >= 648 && screenWidth <= 1199) {
                          crossAxisCount = 2;
                        } else {
                          crossAxisCount = 3;
                        }
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              childAspectRatio: 2.5,
                              mainAxisExtent: 200.0,
                            ),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                height: 200,
                                child: _buildCard(data[index]),
                              );
                            },
                          ),
                        );
                      }),
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

  Widget _buildCard(Employee data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EmployeeEditScreen(id: data.id),
              ),
            );
          },
          child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 300),
                  child: Container(
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
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: data.person!.profilePhoto! != ""
                                ? Image.network(
                                    data.person!.profilePhoto!,
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    "assets/images/user.png",
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20),
                                Text(
                                  "${data.person!.firstName} ${data.person!.lastName}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                // Checkbox(
                                //   activeColor: custom_green,
                                //   value: true,
                                //   onChanged: (value) {
                                //     // setState(() {});
                                //   },
                                // )
                                SizedBox(height: 5),
                                Text(
                                  "Date of birth: ${data.person!.birthDate}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Date of employment: ${data.dateOfEmployment}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Address: ${data.person?.address}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Post code: ${data.person?.postCode}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 5),
                                Spacer(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )))),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        "Employees",
        style: TextStyle(
            color: Colors.grey, fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildEmployeeSearch() {
    return Row(
      children: [
        SizedBox(
          child: Container(
            width: 400.0,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: _searchController,
              onChanged: (value) async {
                searchFilter = value.toString();
                var tmpData = await loadData(searchFilter, 1, 5);
                setState(() {
                  data = tmpData!;
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
}

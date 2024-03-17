import 'package:epreschool_admin/models/listItem.dart';
import 'package:epreschool_admin/providers/monthlyPayments_provider.dart';
import 'package:epreschool_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import '../../models/monthlyPayment.dart';
import '../../providers/enum_provider.dart';

class PaymentListScreen extends StatefulWidget {
  static const String routeName = "payments";

  const PaymentListScreen() : super();

  @override
  State<PaymentListScreen> createState() => _PaymentListScreenState();
}

class _PaymentListScreenState extends State<PaymentListScreen> {
  GlobalKey<NumberPaginatorState> paginatorKey = GlobalKey();
  MonthlyPaymentProvider? _monthlyPaymentProvider = null;
  EnumProvider? _enumProvider = null;
  List<MonthlyPayment> data = [];
  List<ListItem> companies = [];
  ListItem? selectedCompany = null;
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
    _monthlyPaymentProvider = context.read<MonthlyPaymentProvider>();
    _enumProvider = context.read<EnumProvider>();
    loadCompanies();
  }

  Future loadCompanies() async {
    var response = await _enumProvider?.getEnumItems("companies");
    setState(() {
      companies = response!;
    });
    setState(() {
      isLoading = false;
    });
  }

  Future loadData(searchFilter, page, pageSize) async {
    if (searchFilter != '') {
      page = 1;
    }
    var response = await _monthlyPaymentProvider?.getForPagination({
      'SearchFilter': searchFilter.toString() ?? "",
      'PageNumber': page.toString(),
      'PageSize': pageSize.toString(),
      'IsPaid': "true",
      'CompanyId': selectedCompany != null ? selectedCompany!.id.toString() : ""
    });
    setState(() {
      data = response?.items as List<MonthlyPayment>;
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
                        SizedBox(width: 10),
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                          child: selectedCompany == null
                              ? Container(
                                  child: Text(
                                      "Potrebno je odabrati vrtić kako bi se prikazale mjesečne uplate"))
                              : _buildList(context),
                        ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Expanded(
                        child: Container(
                          child: pages[currentPage - 1],
                        ),
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
      ),
    );
  }

  DataRow recentDataRow(MonthlyPayment payment, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(Text(payment.month.toString())),
        DataCell(Text(payment.year.toString())),
        DataCell(Text(payment.parent!.person!.firstName +
            " " +
            payment.parent!.person!.lastName)),
        DataCell(Text(payment.child!.person!.firstName +
            " " +
            payment.child!.person!.lastName)),
        DataCell(Text(payment.price.toInt().toString())),
        DataCell(Text(payment.discount.toInt().toString())),
        DataCell(Text(payment.note)),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        "Monthly payments",
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
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    child: DropdownButtonFormField<ListItem>(
                      key: Key('companiesDropdown'),
                      value: selectedCompany,
                      onChanged: (ListItem? newValue) {
                        setState(() {
                          selectedCompany = newValue!;
                          loadData(searchFilter, page, pageSize);
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Vrtić",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.business_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.id == 0) {
                          return 'Molimo odaberite vrtić ';
                        }
                        return null;
                      },
                      items: companies.map((ListItem item) {
                        return DropdownMenuItem<ListItem>(
                          value: item,
                          child: Text(item.label),
                        );
                      }).toList(),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
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
                    label: Text("Mjesec"),
                  ),
                  DataColumn(
                    label: Text("Godina"),
                  ),
                  DataColumn(
                    label: Text("Roditelj"),
                  ),
                  DataColumn(
                    label: Text("Dijete"),
                  ),
                  DataColumn(
                    label: Text("Cijena"),
                  ),
                  DataColumn(
                    label: Text("Popust"),
                  ),
                  DataColumn(
                    label: Text("Napomena"),
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
}

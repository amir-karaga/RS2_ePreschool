import 'package:epreschool_mobile/models/child.dart';
import 'package:epreschool_mobile/models/monthlyPayment.dart';
import 'package:epreschool_mobile/providers/children_provider.dart';
import 'package:epreschool_mobile/screens/payments/payment_page.dart';
import 'package:epreschool_mobile/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../providers/login_provider.dart';

class PaymentListScreen extends StatefulWidget {
  static const String routeName = "payments";

  const PaymentListScreen({Key? key}) : super(key: key);

  @override
  State<PaymentListScreen> createState() => _PaymentListScreenState();
}

class _PaymentListScreenState extends State<PaymentListScreen> {
  ChildrenProvider? _childrenProvider = null;
  List<MonthlyPayment> data = [];
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
    _childrenProvider = context.read<ChildrenProvider>();
    scrollController.addListener(_scrollListener);
    loadData(searchFilter, page, pageSize);
  }

  Future loadData(searchFilter, page, pageSize) async {
    if (searchFilter != '') {
      page = 1;
    }
    int? companyId = LoginProvider.authResponse?.currentCompanyId;
    bool? isPaid = null;
    if(LoginProvider.authResponse!.isPreschoolOwner!)
      {
        isPaid = true;
      }
    var response = await _childrenProvider?.getMonthlyPayments({
      'SearchFilter': searchFilter.toString() ?? "",
      'PageNumber': page.toString(),
      'PageSize': pageSize.toString(),
      'CompanyId': companyId?.toString() ?? "",
      'IsPaid': isPaid?.toString() ?? ""
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
    return MasterScreenWidget(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Container(
                child: SizedBox(
                  height: 500,
                  child: new ListView.builder(
                    controller: scrollController,
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
                                            data[index].child!.person!.firstName + " " + data[index].child!.person!.lastName,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              !data[index].isPaid ? TextButton.icon(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => PaymentPage(payment: data[index]),
                                                    ),
                                                  );
                                                },
                                                label: Text('Plati', style: TextStyle(fontSize: 12)),
                                                icon: Icon(Icons.arrow_forward_ios_outlined),
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStateProperty.all(Colors.greenAccent),
                                                  foregroundColor: MaterialStateProperty.all(Colors.white),
                                                  elevation: MaterialStateProperty.all(0),
                                                  mouseCursor: MaterialStateProperty.all(SystemMouseCursors.click),
                                                ),
                                              ) :
                                              TextButton.icon(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => PaymentPage(payment: data[index]),
                                                    ),
                                                  );
                                                },
                                                icon: Icon(Icons.arrow_forward_ios_outlined),
                                                label: Text('Pregled', style: TextStyle(fontSize: 12)),
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStateProperty.all(Colors.lightBlueAccent),
                                                  foregroundColor: MaterialStateProperty.all(Colors.white),
                                                  elevation: MaterialStateProperty.all(0),
                                                  mouseCursor: MaterialStateProperty.all(SystemMouseCursors.click),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "Mjesec: ${data[index].month}",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey.shade600),
                                      ),
                                      Text(
                                        "Godina: ${data[index].year}",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey.shade600),
                                      ),
                                      Text(
                                        "Plaćeno:" + (data[index].isPaid ? "DA" : "NE"),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey.shade600),
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
        ),
      ),
    );
  }


  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text("Mjesečne uplate", style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.w600),),
    );
  }

    void _scrollListener(){
      if(scrollController.position.pixels==scrollController.position.maxScrollExtent)
      {
        data=data;
      }
    }
}

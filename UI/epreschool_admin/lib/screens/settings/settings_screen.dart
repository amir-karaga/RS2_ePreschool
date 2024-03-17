import 'package:epreschool_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../models/appConfig.dart';
import '../../providers/appConfigs_provider.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = "settings";
  const SettingsScreen() : super();

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isFirstSubmit = false;
  AppConfigsProvider? _appConfigsProvider = null;
  TextEditingController monthlyFeeController = TextEditingController();
  AppConfig? data = null;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _appConfigsProvider = context.read<AppConfigsProvider>();
    loadData();
  }

  Future loadData() async {
    var response = await _appConfigsProvider?.getForPagination(
        {'searchFilter': "", 'page': "1", 'pageSize': "999"});
    setState(() {
      data = response!.items.first;
      monthlyFeeController.text = data!.monthlyFee.toString();
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        child: Scaffold(
            body: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    onChanged: () {
                      if (isFirstSubmit) _formKey.currentState!.validate();
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
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    controller: monthlyFeeController,
                                    decoration: InputDecoration(
                                      labelText: 'Mjesečna naknada',
                                      border: OutlineInputBorder(),
                                      hintText: 'Unesite mjesečnu naknadu',
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Molimo unesite mjesečnu naknadu';
                                      }
                                      double? amount = double.tryParse(value);
                                      if (amount == null) {
                                        return 'Molimo unesite valjanu decimalnu vrijednost';
                                      }
                                      return null;
                                    },
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      isFirstSubmit = true;
                                      AppConfig config = new AppConfig();
                                      config.id = data!.id;
                                      double? monthlyFee = double.tryParse(
                                          monthlyFeeController.text);
                                      if (monthlyFee != null) {
                                        config.monthlyFee = monthlyFee;
                                        config.createdAt = data!.createdAt;
                                        await _appConfigsProvider?.update(
                                            config.id, config);
                                        Fluttertoast.showToast(
                                          msg: "Postavke uspješno promjenjene",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 5,
                                          backgroundColor: Colors.green,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SettingsScreen(),
                                          ),
                                        );
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: "Format pogrešan",
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
                                  child: Text('Spasi'),
                                ),
                              ],
                            ),
                          ],
                        )),
                  )));
  }
}

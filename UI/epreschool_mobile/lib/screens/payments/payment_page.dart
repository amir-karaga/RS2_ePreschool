import 'dart:convert';
import 'package:epreschool_mobile/models/monthlyPayment.dart';
import 'package:epreschool_mobile/providers/monthly_payment_provider.dart';
import 'package:epreschool_mobile/screens/payments/payment_success.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:provider/provider.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/appConfig.dart';
import '../../providers/appConfigs_provider.dart';

class PaymentPage extends StatefulWidget {
  static const String routeName = 'payment';
  final MonthlyPayment payment;
  PaymentPage({required this.payment});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  MonthlyPaymentProvider? _paymentProvider = null;
  AppConfigsProvider? _appConfigsProvider = null;
  AppConfig? appConfigData = null;
  bool isLoading = false;
  double monthlyFee = 0.0;

  @override
  void initState() {
    super.initState();
    _paymentProvider = context.read<MonthlyPaymentProvider>();
    _appConfigsProvider = context.read<AppConfigsProvider>();
    loadAppConfig();
  }

  Future loadAppConfig() async {
    var response = await _appConfigsProvider?.getForPagination(
        {'searchFilter': "", 'page': "1", 'pageSize': "999"});
    setState(() {
      if (response?.items != null && response!.items.length > 0) {
        appConfigData = response!.items.first;
        monthlyFee = appConfigData!.monthlyFee;
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  showPaymentSheet() async {
    setState(() {
      isLoading = true;
    });
    var paymentIntentData =
        await createPaymentIntent((monthlyFee * 100).toString(), 'BAM');
    await Stripe.instance
        .initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentData['client_secret'],
        merchantDisplayName: 'ePreschool',
        appearance: const PaymentSheetAppearance(
          primaryButton: PaymentSheetPrimaryButtonAppearance(
              colors: PaymentSheetPrimaryButtonTheme(
                  light: PaymentSheetPrimaryButtonThemeColors(
                      background: Colors.cyan))),
        ),
      ),
    )
        .then((value) {
      print(value);
    }).onError((error, stackTrace) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Text("Transakcija nije uspjela"),
              ));
    });

    try {
      await Stripe.instance.presentPaymentSheet();
      addNewMonthlyPayment();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PaymentSuccess(),
        ),
      );
    } catch (e) {
      //silent
    }
    setState(() {
      isLoading = false;
    });
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': ((monthlyFee.toInt() ?? 0) * 100).toString(),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer ${dotenv.env['STRIPE_SECRET']}',
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      return jsonDecode(response.body);
    } catch (err) {
      //silent
    }
  }

  Widget build(BuildContext context) {
    final MonthlyPayment payment = widget.payment;
    return Scaffold(
      appBar: AppBar(
        title: Text("Prikaz detalja uplate"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: payment != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("Detalji plaćanja:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      Divider(),
                      if (payment != null)
                        _buildDetailItem(
                            Icons.person,
                            "Ime i prezime",
                            "${payment.child!.person!.firstName} ${payment.child!.person!.lastName}" ??
                                '',
                            Colors.greenAccent),
                      _buildDetailItem(Icons.date_range, "Mjesec",
                          payment.month.toString() ?? '', Colors.blueAccent),
                      _buildDetailItem(Icons.date_range, "Godina",
                          payment.year.toString() ?? '', Colors.grey),
                      _buildDetailItem(Icons.price_change, "Cijena",
                          payment.price.toString() + "KM" ?? '', Colors.cyan),
                      _buildDetailItem(Icons.discount, "Popust",
                          payment.discount.toString() ?? '', Colors.cyan),
                      payment.isPaid == false
                          ? Container(
                              width: double.infinity,
                              child: FractionallySizedBox(
                                  widthFactor: 1,
                                  child: SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.greenAccent,
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: isLoading
                                            ? null
                                            : () async =>
                                                await showPaymentSheet(),
                                        child: Text(
                                          "Plati",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ))))
                          : Container()
                    ],
                  )
                : Column()),
      ),
    );
  }

  Widget _buildDetailItem(
      IconData icon, String label, String value, Color iconColor) {
    return Card(
      elevation: 3,
      shadowColor: Colors.grey[300],
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Icon(
              icon,
              size: 36,
              color: iconColor,
            ),
            title: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              value,
              style: TextStyle(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  addNewMonthlyPayment() async {
    final MonthlyPayment newMonthlyPayment = widget.payment;
    newMonthlyPayment.note = "";
    newMonthlyPayment.price = appConfigData!.monthlyFee;
    newMonthlyPayment.isPaid = true;
    newMonthlyPayment.statusPayment = 0;
    await _paymentProvider?.insert(newMonthlyPayment);
  }
}

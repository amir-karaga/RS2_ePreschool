import 'package:epreschool_mobile/models/company.dart';
import 'package:epreschool_mobile/providers/companies_provider.dart';
import 'package:epreschool_mobile/screens/employees/employee_list_public_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class KindergatenPreviewScreen extends StatefulWidget {
  static const String routeName = "kindergaten/preview";
  final int id;
  KindergatenPreviewScreen({required this.id});

  @override
  State<KindergatenPreviewScreen> createState() =>
      _KindergatenPreviewScreenState();
}

class _KindergatenPreviewScreenState extends State<KindergatenPreviewScreen> {
  CompaniesProvider? _companiesProvider;
  late Company? data = null;
  String? averageReviewRatings = '0';

  @override
  void initState() {
    super.initState();
    _companiesProvider = context.read<CompaniesProvider>();
    Future.delayed(Duration.zero, () async {
      await loadData();
    });
  }

  Future<void> loadData() async {
    Company? item = await _companiesProvider?.getById(widget.id, null);
    setState(() {
      this.data = item!;
      final data = this.data;
      if (data != null) {
        averageReviewRatings = data.rating.toString();
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prikaz detalja vrtića"),
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
          child: data != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (averageReviewRatings != null)
                      Row(
                        children: [
                          Expanded(
                            child: _buildDetailItem(Icons.star, "Ocjena",
                                averageReviewRatings!, Colors.orange),
                          ),
                        ],
                      ),
                    SizedBox(height: 16),
                    Row(children: [
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EmployeeListPublicScreen(
                                  companyId: data!.id),
                            ),
                          );
                        },
                        icon: Icon(Icons.rate_review),
                        label: Text(
                          'Odgajatelji',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ]),
                    SizedBox(height: 16),
                    Text("Informacije",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    Divider(),
                    if (data != null)
                      _buildDetailItem(Icons.business_outlined, "Naziv",
                          "${data?.name ?? ''}", Colors.greenAccent),
                    _buildDetailItem(Icons.mail, "Email", data?.email ?? '',
                        Colors.blueAccent),
                    _buildDetailItem(Icons.phone, "Broj telefona",
                        data?.phoneNumber ?? '', Colors.grey),
                    if (data?.location != null)
                      _buildDetailItem(Icons.near_me, "Lokacija",
                          data?.location!.name ?? '', Colors.cyan),
                    _buildDetailItem(Icons.near_me, "Adresa",
                        data?.address ?? '', Colors.cyan)
                  ],
                )
              : Column(),
        ),
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
}

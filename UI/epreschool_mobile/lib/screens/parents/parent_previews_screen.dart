import 'package:epreschool_mobile/models/employee.dart';
import 'package:epreschool_mobile/providers/employees_provider.dart';
import 'package:epreschool_mobile/providers/login_provider.dart';
import 'package:epreschool_mobile/providers/parents_provider.dart';
import 'package:epreschool_mobile/screens/employees/employee_add_review_screen.dart';
import 'package:epreschool_mobile/screens/messages/message_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../models/listItem.dart';
import '../../models/parent.dart';
import '../../providers/enum_provider.dart';

class ParentPreviewScreen extends StatefulWidget {
  static const String routeName = "parent/preview";
  final int id;
  ParentPreviewScreen({required this.id});

  @override
  State<ParentPreviewScreen> createState() => _ParentPreviewScreenState();
}

class _ParentPreviewScreenState extends State<ParentPreviewScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController profilePictureController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  ParentsProvider? _parentsProvider;
  EnumProvider? _enumProvider;
  List<ListItem> genders = [];
  List<ListItem> cities = [];
  ListItem? selectedGender = null;
  ListItem? selectedCity = null;
  dynamic bytes = null;
  dynamic _imageFile;
  late Parent? data = null;
  String? averageReviewRatings = '0';
  bool isReviewEmployee = false;

  @override
  void initState() {
    super.initState();
    _imageFile = null;
    _parentsProvider = context.read<ParentsProvider>();
    _enumProvider = context.read<EnumProvider>();
    Future.delayed(Duration.zero, () async {
      await loadGenders();
      await loadCities();
      await loadData();
    });
  }

  Future<void> loadData() async {
    Parent? item = await _parentsProvider?.getById(widget.id, null);
    setState(() {
      this.data = item!;
      final data = this.data;
      if (data != null) {
        firstNameController.text = data.person!.firstName;
        lastNameController.text = data.person!.lastName;
        dateOfBirthController.text = data.person!.birthDate!;
        selectedGender =
            genders.firstWhere((item) => item.id == data.person!.gender!);
        selectedCity =
            cities.firstWhere((item) => item.id == data.person!.birthPlaceId!);
        postalCodeController.text = data.person!.postCode!;
      }
    });
  }

  Future loadGenders() async {
    var response = await _enumProvider?.getEnumItems("genders");
    setState(() {
      genders = response!;
    });
  }

  Future loadCities() async {
    var response = await _enumProvider?.getEnumItems("cities");
    setState(() {
      cities = response! as List<ListItem>;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prikaz detalja roditelja"),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: ClipOval(
                              child: _imageFile != null
                                  ? Image.file(
                                      _imageFile,
                                      fit: BoxFit.cover,
                                      width: 100,
                                      height: 100,
                                    )
                                  : Image.asset(
                                      "assets/images/user.png",
                                      fit: BoxFit.cover,
                                      width: 150,
                                      height: 100,
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(children: [
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MessageListScreen(
                                  userId: data!.id),
                            ),
                          );
                        },
                        icon: Icon(Icons.rate_review),
                        label: Text(
                          'Poruke',
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    ]),
                    SizedBox(height: 16),
                    Text("Informacije",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    Divider(),
                    if (data != null)
                      _buildDetailItem(
                          Icons.person,
                          "Ime i prezime",
                          "${data?.person?.firstName ?? ''} ${data?.person?.lastName ?? ''}",
                          Colors.greenAccent),
                    if (selectedGender != null)
                      _buildDetailItem(Icons.face, "Spol",
                          selectedGender?.label ?? '', Colors.redAccent),
                    if (selectedCity != null)
                      _buildDetailItem(Icons.location_on, "Mjesto rođenja",
                          selectedCity?.label ?? '', Colors.yellowAccent),
                    _buildDetailItem(Icons.mail, "Poštanski broj",
                        data?.person?.postCode ?? '', Colors.cyan)
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

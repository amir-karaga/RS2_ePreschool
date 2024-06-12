import 'package:epreschool_mobile/models/employee.dart';
import 'package:epreschool_mobile/providers/employees_provider.dart';
import 'package:epreschool_mobile/providers/login_provider.dart';
import 'package:epreschool_mobile/screens/employees/employee_add_review_screen.dart';
import 'package:epreschool_mobile/screens/messages/message_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../models/listItem.dart';
import '../../providers/enum_provider.dart';

class EmployeePreviewScreen extends StatefulWidget {
  static const String routeName = "child/edit";
  final int id;
  EmployeePreviewScreen({required this.id});

  @override
  State<EmployeePreviewScreen> createState() => _EmployeePreviewScreenState();
}

class _EmployeePreviewScreenState extends State<EmployeePreviewScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController profilePictureController = TextEditingController();
  TextEditingController placeOfBirthController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  TextEditingController dateOfEnrollment = TextEditingController();
  TextEditingController specialNeedsController = TextEditingController();
  EmployeesProvider? _employeesProvider;
  EnumProvider? _enumProvider;
  List<ListItem> genders = [];
  List<ListItem> cities = [];
  ListItem? selectedGender = null;
  ListItem? selectedCity = null;
  dynamic bytes = null;
  dynamic _imageFile;
  late Employee? data = null;
  String? averageReviewRatings = '0';
  bool isReviewEmployee = false;

  @override
  void initState() {
    super.initState();
    _imageFile = null;
    _employeesProvider = context.read<EmployeesProvider>();
    _enumProvider = context.read<EnumProvider>();
    Future.delayed(Duration.zero, () async {
      await loadGenders();
      await loadCities();
      await loadData();
    });
  }

  Future<void> loadData() async {
    Employee? item = await _employeesProvider?.getById(widget.id, null);
    setState(() {
      this.data = item!;
      final data = this.data;
      if (data != null) {
        averageReviewRatings = data.averageReviewsRating.toString();
        firstNameController.text = data.person!.firstName;
        lastNameController.text = data.person!.lastName;
        dateOfBirthController.text = data.person!.birthDate!;
        selectedGender =
            genders.firstWhere((item) => item.id == data.person!.gender!);
        selectedCity =
            cities.firstWhere((item) => item.id == data.person!.birthPlaceId!);
        nationalityController.text = data.person!.nationality!;
        postalCodeController.text = data.person!.postCode!;
        if (LoginProvider.authResponse!.isParent!) {
          int userId = LoginProvider.authResponse!.userId;
          for (var review in data.reviews) {
            if (review.parentReviewerId == userId) {
              isReviewEmployee = true;
            }
          }
        }
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
        title: Text("Prikaz detalja uposlenika"),
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
                    LoginProvider.authResponse!.isParent!? Row(children: [
                      !isReviewEmployee? TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EmployeeAddReviewsScreen(
                                  employeeId: data!.id),
                            ),
                          );
                        },
                        icon: Icon(Icons.rate_review),
                        label: Text(
                          'Ostavi recenziju',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ):Text("Ostavili ste već recenziju za odgajatelja"),
                    ]):Row(),
                    SizedBox(height: 10),
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
                    _buildDetailItem(Icons.date_range, "Datum zaposlenja",
                        data?.dateOfEmployment ?? '', Colors.blueAccent),
                    if (selectedGender != null)
                      _buildDetailItem(Icons.face, "Spol",
                          selectedGender?.label ?? '', Colors.redAccent),
                    if (selectedCity != null)
                      _buildDetailItem(Icons.location_on, "Mjesto rođenja",
                          selectedCity?.label ?? '', Colors.yellowAccent),
                    _buildDetailItem(Icons.language, "Nacionalnost",
                        data?.person?.nationality ?? '', Colors.grey),
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
